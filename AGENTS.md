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
- **Type Safety & Avoiding `dynamic`**: Prefer strong typing (such as `Object?`)
  over `dynamic` to maintain compile-time type checks.
- **Avoiding `as` Type Casts**: Prefer `is` / `is!` type checks with Dart type
  promotion over explicit `as` casts to prevent runtime type errors.
- **Method Parameters**: Prefer named parameters (using `{required ...}`) when a
  function or method takes more than one parameter.
- **Class Member Ordering (Stepdown Rule)**: Sort class members logically so
  a class reads like a book from top to bottom—callers should be placed above
  callees. Never place a private method above a public method. For widget states,
  `dispose` should be placed below `build` to match the lifecycle order.
- **User-Facing Copy & Terminology**: Never include backend database names (such
  as "Open Food Facts" or "Open Products Facts") in user-facing texts, dialogs,
  release notes, or UI copy, as end users are unaware of internal database
  implementations.

### File Organization & Architecture

- **Clean Architecture:** This project strictly follows Clean Architecture principles as defined in [Clean Architecture by Robert C. Martin](https://a.co/d/06KjhpG8) (Entities, Use Cases, Interface Adapters, Frameworks & Drivers).
- **One Class Per File:** Maintain one class per file, except for obvious
  exceptions such as state classes for stateful widgets, or enum-like classes
  such as events and states for BLoC/Cubit.

### File Maintenance & Guidelines Limit

- The `AGENTS.md` file must never exceed 200 lines, and this rule must always be
  placed at the very end of the file (and must not be placed below line 200). If
  a new rule needs to be added, concise existing content or remove less critical
  rules to remain strictly under the 200 line limit.
