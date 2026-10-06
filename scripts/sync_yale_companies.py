#!/usr/bin/env python3
"""Sync local company JSON with the Yale SOM Russia business retreat list.

Behaviour:
1. Parse company rows from the Yale SOM page sections:
   Digging In, Buying Time, Scaling Back, Suspension, Withdrawal.
2. Match local records by company name (case-insensitive + conservative variants).
3. Update changed fields for matched records:
   Status, Action, Country.
4. Add missing companies, except when source status is Withdrawal or Suspension.
5. Write an optional summary JSON report.
"""

from __future__ import annotations

import argparse
import hashlib
import html
import json
import re
import ssl
import sys
import unicodedata
from collections import Counter, defaultdict
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any
from urllib.error import URLError
from urllib.request import Request, urlopen

DEFAULT_SOURCE_URL = (
    "https://som.yale.edu/story/2022/"
    "over-1000-companies-have-curtailed-operations-russia-some-remain"
)

SECTION_ID_TO_STATUS = {
    "diggingin": "Digging In",
    "buyingtime": "Buying Time",
    "scalingback": "Scaling Back",
    "suspension": "Suspension",
    "withdrawal": "Withdrawal",
}

NORMALIZED_STATUS = {
    "digging in": "Digging In",
    "buying time": "Buying Time",
    "scaling back": "Scaling Back",
    "suspension": "Suspension",
    "withdrawal": "Withdrawal",
}

SKIP_ADD_STATUSES = {"Withdrawal", "Suspension"}


def collapse_ws(value: Any) -> str:
    return " ".join(str(value or "").replace("\xa0", " ").split()).strip()


def normalize_status(value: str) -> str:
    key = collapse_ws(value).casefold()
    return NORMALIZED_STATUS.get(key, collapse_ws(value))


def normalize_text_for_compare(value: Any) -> str:
    return collapse_ws(value).casefold()


def normalize_name(value: str) -> str:
    text = unicodedata.normalize("NFKD", value or "")
    text = text.encode("ascii", "ignore").decode("ascii")
    text = text.casefold().strip()
    text = text.replace("&", " and ")
    text = text.replace("+", " and ")
    text = text.replace("@", " at ")
    text = text.replace("'", "")
    text = re.sub(r"[^a-z0-9]+", " ", text)
    text = re.sub(
        (
            r"\b("
            r"the|incorporated|inc|corp|corporation|co|company|companies|"
            r"group|holdings|holding|plc|ag|sa|nv|llc|ltd|limited|spa|srl|kg|"
            r"gmbh|pte|oyj|ab|asa|bv|lp|international|int l|int|com"
            r")\b"
        ),
        " ",
        text,
    )
    text = re.sub(r"\s+", " ", text).strip()
    return text


def generate_match_keys(
    name: str,
    source_canonical_keys: set[str] | None = None,
) -> list[str]:
    """Generate ordered, conservative match keys for a company name.

    Priority:
    1. Canonical full name
    2. Name without parenthetical text
    3. Long alias parts from separators ("|" and ";")
    4. Parenthetical variants (unless that variant exists as a canonical source name)
    5. Single-token trailing "co" alias (PepsiCo -> Pepsi)
    """
    base = collapse_ws(name)
    if not base:
        return []

    keys: list[str] = []
    seen: set[str] = set()

    def push_key(raw: str) -> None:
        key = normalize_name(raw)
        if key and key not in seen:
            seen.add(key)
            keys.append(key)

    push_key(base)

    no_parens = collapse_ws(re.sub(r"\([^)]*\)", " ", base))
    if no_parens and no_parens != base:
        push_key(no_parens)

    # Split only separators that are typically aliases.
    # Intentionally avoid "/" because it frequently appears in legal forms like "A/S".
    for sep in ("|", ";"):
        if sep not in base:
            continue
        for part in base.split(sep):
            part = collapse_ws(part)
            if not part:
                continue
            part_key = normalize_name(part)
            if not part_key:
                continue
            # Avoid very short generic tokens (e.g. "MOL", "S").
            if " " in part_key or len(part_key) >= 5:
                push_key(part)

            part_no_parens = collapse_ws(re.sub(r"\([^)]*\)", " ", part))
            if part_no_parens:
                part_no_parens_key = normalize_name(part_no_parens)
                if part_no_parens_key and (" " in part_no_parens_key or len(part_no_parens_key) >= 5):
                    push_key(part_no_parens)

    # Add parenthetical variants only when they are not already canonical source names.
    # This prevents over-matching pairs like:
    # "Japan Credit Bureau (JCB)" and separate "JCB" rows.
    for inner in re.findall(r"\(([^)]*)\)", base):
        inner = collapse_ws(inner)
        if not inner:
            continue
        inner_key = normalize_name(inner)
        if not inner_key:
            continue
        if source_canonical_keys and inner_key in source_canonical_keys:
            continue
        if len(inner_key) < 2:
            continue
        push_key(inner)

    canonical_key = normalize_name(base)
    if canonical_key and " " not in canonical_key and canonical_key.endswith("co") and len(canonical_key) >= 6:
        push_key(base[:-2])

    return keys


def get_ssl_context() -> ssl.SSLContext:
    try:
        import certifi
        return ssl.create_default_context(cafile=certifi.where())
    except Exception:
        pass
    try:
        return ssl.create_default_context()
    except Exception:
        return ssl._create_unverified_context()


def fetch_html(url: str) -> str:
    request = Request(
        url,
        headers={
            "User-Agent": (
                "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) "
                "AppleWebKit/537.36 (KHTML, like Gecko) "
                "Chrome/124.0.0.0 Safari/537.36"
            )
        },
    )
    context = get_ssl_context()
    try:
        with urlopen(request, timeout=60, context=context) as response:
            return response.read().decode("utf-8", "replace")
    except Exception as exc:
        if "CERTIFICATE_VERIFY_FAILED" in str(exc) or isinstance(exc,
                                                                 (ssl.SSLError,
                                                                  URLError)):
            unverified_context = ssl._create_unverified_context()
            with urlopen(request, timeout=60,
                         context=unverified_context) as response:
                return response.read().decode("utf-8", "replace")
        raise


def clean_cell(cell_html: str) -> str:
    cell_html = re.sub(r"<br\s*/?>", " ", cell_html, flags=re.IGNORECASE)
    cell_html = re.sub(r"<[^>]+>", " ", cell_html)
    return collapse_ws(html.unescape(cell_html))


@dataclass(frozen=True)
class YaleRow:
    name: str
    action: str
    industry: str
    country: str
    status: str

    @property
    def key(self) -> str:
        return normalize_name(self.name)


def parse_yale_rows(page_html: str) -> tuple[list[YaleRow], list[dict[str, Any]]]:
    section_markers: list[tuple[int, str, str]] = []
    for section_id, status in SECTION_ID_TO_STATUS.items():
        match = re.search(rf'<section[^>]*id="{section_id}"[^>]*>', page_html, re.IGNORECASE)
        if not match:
            raise RuntimeError(f"Could not find Yale section '{section_id}' in source HTML.")
        section_markers.append((match.start(), section_id, status))

    section_markers.sort(key=lambda item: item[0])

    parsed_rows: list[YaleRow] = []
    for idx, (start, _section_id, status) in enumerate(section_markers):
        end = section_markers[idx + 1][0] if idx + 1 < len(section_markers) else len(page_html)
        section_html = page_html[start:end]

        tbody_match = re.search(r"<tbody>(.*?)</tbody>", section_html, re.IGNORECASE | re.DOTALL)
        if not tbody_match:
            raise RuntimeError(f"Could not parse table body for Yale section status '{status}'.")

        tbody_html = tbody_match.group(1)
        row_matches = re.findall(
            r'<tr[^>]*class="table__row"[^>]*>(.*?)</tr>',
            tbody_html,
            re.IGNORECASE | re.DOTALL,
        )

        for row_html in row_matches:
            cols = re.findall(
                r'<td[^>]*class="table__cell"[^>]*>(.*?)</td>',
                row_html,
                re.IGNORECASE | re.DOTALL,
            )
            values = [clean_cell(col) for col in cols[:4]]
            while len(values) < 4:
                values.append("")

            name, action, industry, country = values
            if not name:
                continue

            parsed_rows.append(
                YaleRow(
                    name=name,
                    action=action,
                    industry=industry,
                    country=country,
                    status=status,
                )
            )

    # Deduplicate by normalized name, keeping the last occurrence.
    rows_by_key: dict[str, YaleRow] = {}
    duplicate_events: list[dict[str, Any]] = []
    for row in parsed_rows:
        key = row.key
        if not key:
            continue
        if key in rows_by_key:
            previous = rows_by_key[key]
            duplicate_events.append(
                {
                    "key": key,
                    "replaced": {
                        "Name": previous.name,
                        "Status": previous.status,
                    },
                    "kept": {
                        "Name": row.name,
                        "Status": row.status,
                    },
                }
            )
        rows_by_key[key] = row

    deduped_rows = list(rows_by_key.values())

    # Collapse short acronym-only rows when a longer row explicitly carries
    # the same acronym in parentheses with the same status + country.
    # Example:
    # "BSI" and "British Standards Institution (BSI)" in same category.
    acronym_context: dict[tuple[str, str, str], list[YaleRow]] = defaultdict(list)
    for row in deduped_rows:
        for inner in re.findall(r"\(([^)]*)\)", row.name):
            inner_key = normalize_name(inner)
            if not inner_key:
                continue
            context = (
                inner_key,
                normalize_status(row.status),
                normalize_text_for_compare(row.country),
            )
            acronym_context[context].append(row)

    filtered_rows: list[YaleRow] = []
    for row in deduped_rows:
        row_key = row.key
        context = (
            row_key,
            normalize_status(row.status),
            normalize_text_for_compare(row.country),
        )
        candidates = acronym_context.get(context, [])

        is_short_acronym = bool(row_key) and " " not in row_key and len(row_key) <= 4
        has_longer_explicit_alias = any(len(candidate.key) > len(row_key) for candidate in candidates)

        if is_short_acronym and has_longer_explicit_alias:
            duplicate_events.append(
                {
                    "key": row_key,
                    "replaced": {"Name": row.name, "Status": row.status},
                    "kept": {
                        "Name": max(candidates, key=lambda item: len(item.key)).name,
                        "Status": row.status,
                    },
                    "reason": "acronym_collapsed",
                }
            )
            continue

        filtered_rows.append(row)

    return filtered_rows, duplicate_events


def build_existing_name_index(records: list[dict[str, Any]]) -> dict[str, set[int]]:
    index: dict[str, set[int]] = defaultdict(set)
    for i, record in enumerate(records):
        name = record.get("fields", {}).get("Name", "")
        for key in generate_match_keys(name):
            index[key].add(i)
    return index


def match_record_indices(
    yale_row: YaleRow,
    existing_index: dict[str, set[int]],
    source_canonical_keys: set[str],
) -> set[int]:
    for key in generate_match_keys(yale_row.name, source_canonical_keys=source_canonical_keys):
        if key in existing_index:
            return existing_index[key]
    return set()


def make_record_id(base_name_key: str, existing_ids: set[str]) -> str:
    salt = 0
    while True:
        digest = hashlib.sha1(f"{base_name_key}:{salt}".encode("utf-8")).hexdigest()[:14]
        candidate = f"rec{digest}"
        if candidate not in existing_ids:
            existing_ids.add(candidate)
            return candidate
        salt += 1


def sync_dataset(
    dataset: list[dict[str, Any]],
    yale_rows: list[YaleRow],
    sync_timestamp: str,
) -> dict[str, Any]:
    existing_index = build_existing_name_index(dataset)
    existing_ids = {record.get("id", "") for record in dataset}
    source_canonical_keys = {row.key for row in yale_rows if row.key}

    changed_fields_counter: Counter[str] = Counter()
    status_transition_counter: Counter[tuple[str, str]] = Counter()
    updated_records: dict[int, dict[str, Any]] = {}

    unmatched_rows: list[YaleRow] = []
    matched_source_rows = 0

    for row in yale_rows:
        matched_indices = match_record_indices(row, existing_index, source_canonical_keys)
        if not matched_indices:
            unmatched_rows.append(row)
            continue

        matched_source_rows += 1
        for idx in matched_indices:
            record = dataset[idx]
            fields = record.setdefault("fields", {})
            record_changed = False

            existing_name = collapse_ws(fields.get("Name", ""))
            update_entry = updated_records.setdefault(
                idx,
                {"Name": existing_name, "changedFields": {}},
            )

            for field_name, new_value in (
                ("Status", row.status),
                ("Action", row.action),
                ("Country", row.country),
            ):
                new_value = collapse_ws(new_value)
                if not new_value:
                    continue

                old_value = collapse_ws(fields.get(field_name, ""))

                if field_name == "Status":
                    old_norm_status = normalize_status(old_value)
                    new_norm_status = normalize_status(new_value)
                    if old_norm_status == new_norm_status:
                        continue

                    fields[field_name] = new_norm_status
                    changed_fields_counter[field_name] += 1
                    status_transition_counter[(old_norm_status, new_norm_status)] += 1
                    update_entry["changedFields"][field_name] = {
                        "old": old_value,
                        "new": new_norm_status,
                    }
                    record_changed = True
                    continue

                if normalize_text_for_compare(old_value) == normalize_text_for_compare(new_value):
                    continue

                fields[field_name] = new_value
                changed_fields_counter[field_name] += 1
                update_entry["changedFields"][field_name] = {"old": old_value, "new": new_value}
                record_changed = True

            if record_changed:
                fields["Last Modified"] = sync_timestamp
            else:
                # Remove empty update stubs when no field changed for this row.
                if not update_entry["changedFields"]:
                    updated_records.pop(idx, None)

    added_companies: list[dict[str, Any]] = []
    skipped_companies: list[dict[str, Any]] = []

    for row in unmatched_rows:
        if row.status in SKIP_ADD_STATUSES:
            skipped_companies.append({"Name": row.name, "Status": row.status})
            continue

        row_key = row.key or normalize_name(row.name)
        new_record_id = make_record_id(row_key, existing_ids)

        new_fields = {
            "Name": collapse_ws(row.name),
            "Action": collapse_ws(row.action),
            "Status": normalize_status(row.status),
            "Country": collapse_ws(row.country),
            "Industry": collapse_ws(row.industry),
            "Last Modified": sync_timestamp,
        }
        new_fields = {k: v for k, v in new_fields.items() if v}

        dataset.append(
            {
                "id": new_record_id,
                "createdTime": sync_timestamp,
                "fields": new_fields,
            }
        )
        added_companies.append({"Name": new_fields.get("Name", ""), "Status": new_fields.get("Status", "")})

    updated_companies = sorted(
        (
            {
                "Name": details["Name"],
                "changedFields": details["changedFields"],
            }
            for details in updated_records.values()
        ),
        key=lambda item: item["Name"].casefold(),
    )

    added_companies.sort(key=lambda item: item["Name"].casefold())
    skipped_companies.sort(key=lambda item: item["Name"].casefold())

    return {
        "matchedSourceRows": matched_source_rows,
        "unmatchedSourceRows": len(unmatched_rows),
        "updatedRecordCount": len(updated_companies),
        "updatedFieldChangeCounts": dict(changed_fields_counter),
        "statusTransitions": [
            {"from": old, "to": new, "count": count}
            for (old, new), count in status_transition_counter.most_common()
        ],
        "updatedCompanies": updated_companies,
        "addedCompanyCount": len(added_companies),
        "addedCompanies": added_companies,
        "skippedCompanyCount": len(skipped_companies),
        "skippedCompanies": skipped_companies,
    }


ALLOWED_FIELDS = {
    "Name",
    "Brands",
    "Status",
    "Action",
    "Country",
    "Website URL",
    "Link to Announcement",
    "Sector",
    "Industry",
    "Description",
    "Exception",
    "Date of Last Action",
}


def trim_dataset(dataset: list[dict[str, Any]]) -> list[dict[str, Any]]:
    trimmed = []
    for item in dataset:
        record = {}
        if "id" in item:
            record["id"] = item["id"]
        fields = item.get("fields", {})
        cleaned_fields = {}
        for k in ALLOWED_FIELDS:
            v = fields.get(k)
            if v is not None and v != "" and v != []:
                cleaned_fields[k] = v
        if cleaned_fields:
            record["fields"] = cleaned_fields
        trimmed.append(record)
    return trimmed


def load_dataset(path: Path) -> list[dict[str, Any]]:
    with path.open("r", encoding="utf-8") as file:
        payload = json.load(file)
    if not isinstance(payload, list):
        raise RuntimeError(f"Expected top-level JSON array in {path}.")
    return payload


def write_json(path: Path, payload: Any, indent: int) -> None:
    with path.open("w", encoding="utf-8") as file:
        json.dump(payload, file, indent=indent, ensure_ascii=False)
        file.write("\n")


def main() -> int:
    parser = argparse.ArgumentParser(description="Sync local JSON dataset with Yale SOM company statuses.")
    parser.add_argument(
        "--input",
        default="assets/data/russia_sponsors.json",
        help="Path to existing dataset JSON file.",
    )
    parser.add_argument(
        "--output",
        default=None,
        help="Output path for updated dataset. Defaults to --input.",
    )
    parser.add_argument(
        "--source-url",
        default=DEFAULT_SOURCE_URL,
        help="Yale source page URL.",
    )
    parser.add_argument(
        "--summary-json",
        default=None,
        help="Optional path to write machine-readable summary JSON.",
    )
    parser.add_argument(
        "--indent",
        type=int,
        default=2,
        help="JSON indentation size for written files.",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Run sync and print summary without writing dataset output.",
    )

    args = parser.parse_args()

    input_path = Path(args.input).resolve()
    output_path = Path(args.output).resolve() if args.output else input_path
    summary_path = Path(args.summary_json).resolve() if args.summary_json else None

    if not input_path.exists():
        raise RuntimeError(f"Input dataset does not exist: {input_path}")

    dataset = load_dataset(input_path)

    source_html = fetch_html(args.source_url)
    yale_rows, duplicate_events = parse_yale_rows(source_html)

    sync_timestamp = datetime.now(timezone.utc).isoformat(timespec="milliseconds").replace("+00:00", "Z")
    summary = sync_dataset(dataset, yale_rows, sync_timestamp)

    source_status_counts = Counter(row.status for row in yale_rows)

    final_summary = {
        "sourceUrl": args.source_url,
        "syncTimestamp": sync_timestamp,
        "sourceRowsParsed": len(yale_rows),
        "sourceStatusCounts": dict(source_status_counts),
        "sourceDuplicateRowsCollapsed": len(duplicate_events),
        "sourceDuplicateSamples": duplicate_events[:20],
        **summary,
    }

    if not args.dry_run:
        trimmed = trim_dataset(dataset)
        write_json(output_path, trimmed, indent=args.indent)

    if summary_path:
        write_json(summary_path, final_summary, indent=args.indent)

    # Print a concise, human-readable summary to stdout.
    print(
        json.dumps(
            {
                "outputPath": str(output_path),
                "dryRun": args.dry_run,
                "sourceRowsParsed": final_summary["sourceRowsParsed"],
                "matchedSourceRows": final_summary["matchedSourceRows"],
                "unmatchedSourceRows": final_summary["unmatchedSourceRows"],
                "updatedRecordCount": final_summary["updatedRecordCount"],
                "addedCompanyCount": final_summary["addedCompanyCount"],
                "skippedCompanyCount": final_summary["skippedCompanyCount"],
                "updatedFieldChangeCounts": final_summary["updatedFieldChangeCounts"],
            },
            indent=args.indent,
            ensure_ascii=False,
        )
    )

    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except Exception as exc:  # pylint: disable=broad-except
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)
