# AI Agent Project Rules

Keep control flow readable and direct.

- Prefer an explicit `else` branch over an early `return`.
- Prefer this style:

```dart
if (condition) {
  emit(firstState);
} else {
  emit(secondState);
}
```

- Avoid this style when an `else` branch would express the same logic more clearly:

```dart
if (condition) {
  emit(firstState);
  return;
}

emit(secondState);
```

## Vertical ordering of functions

If one function calls another, they should be vertically close, and the caller should be above the callee, if at all possible.
