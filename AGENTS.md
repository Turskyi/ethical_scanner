# Agent Guidelines & Preferences

## Code Style Preferences

- **Conditional Control Flow**: Prefer explicit `if-else` blocks over early
  returns where applicable.
- **Constants & Enums**: Avoid hardcoded string literals (such as status keys,
  country barcode prefixes, etc.). Place them in constants or class/enum
  getters/properties.
- **Null Safety & Safe Accessors**: Prefer safe accessors (such as
  `.firstOrNull` instead of `.first` or direct indexing) to avoid runtime
  exceptions on empty collections.
- **Method Parameters**: Prefer named parameters (using `{required ...}`) when a
  function or method takes more than one parameter.

### File Organization & Architecture

- **One Class Per File:** Maintain one class per file, except for obvious
  exceptions such as state classes for stateful widgets, or enum-like classes
  such as events and states for BLoC/Cubit.

### File Maintenance & Guidelines Limit

- The `AGENTS.md` file must never exceed 200 lines, and this rule must always be
  placed at the very end of the file (and must not be placed below line 200). If
  a new rule needs to be added, concise existing content or remove less critical
  rules to remain strictly under the 200 line limit.

