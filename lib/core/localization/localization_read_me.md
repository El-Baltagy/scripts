# Easy Localization `tr()` Guide

This document explains how to use the `tr()` function from the `easy_localization` package.

---

# What is `tr()`?

`tr()` is the main translation function used to translate localization keys into the current language.

```dart
'hello'.tr();
```

If your `en.json` contains:

```json
{
  "hello": "Hello"
}
```

The result will be:

```
Hello
```

---

# Function Signature

```dart
String tr({
  List<String>? args,
  Map<String, String>? namedArgs,
  String? gender,
  BuildContext? context,
})
```

| Parameter | Description |
|-----------|-------------|
| `args` | Replaces anonymous placeholders `{}` from left to right. |
| `namedArgs` | Replaces named placeholders like `{name}` or `{price}`. |
| `gender` | Selects a translation based on gender (`male`, `female`, `other`). |
| `context` | Optional `BuildContext`. Usually not needed. |

---

# Basic Translation

## JSON

```json
{
  "hello": "Hello",
  "welcome": "Welcome"
}
```

## Dart

```dart
Text('hello'.tr())
```

or

```dart
Text(
  'hello'.tr(),
)
```

Output

```
Hello
```

---

# Using `args`

`args` replaces every `{}` in order.

## JSON

```json
{
  "message": "{} is written in {}"
}
```

## Dart

```dart
Text(
  'message'.tr(
    args: [
      'Flutter',
      'Dart',
    ],
  ),
)
```

Output

```
Flutter is written in Dart
```

### Another Example

#### JSON

```json
{
  "welcome": "Hello {}, welcome to {}!"
}
```

#### Dart

```dart
Text(
  'welcome'.tr(
    args: [
      'Mohamed',
      'Egypt',
    ],
  ),
)
```

Output

```
Hello Mohamed, welcome to Egypt!
```

---

# Using `namedArgs`

Named arguments replace placeholders by name instead of position.

## JSON

```json
{
  "welcome": "Hello {name}, welcome to {country}"
}
```

## Dart

```dart
Text(
  'welcome'.tr(
    namedArgs: {
      'name': 'Mohamed',
      'country': 'Egypt',
    },
  ),
)
```

Output

```
Hello Mohamed, welcome to Egypt
```

This approach is usually easier to read and maintain.

---

# Using `args` and `namedArgs` Together

You can mix positional and named placeholders.

## JSON

```json
{
  "message": "{} is written in {language}"
}
```

## Dart

```dart
Text(
  'message'.tr(
    args: [
      'Easy Localization',
    ],
    namedArgs: {
      'language': 'Dart',
    },
  ),
)
```

Output

```
Easy Localization is written in Dart
```

---

# Using `gender`

Different translations can be returned depending on gender.

## JSON

```json
{
  "greeting": {
    "male": "Hello Mr. {}",
    "female": "Hello Ms. {}",
    "other": "Hello {}"
  }
}
```

## Male

```dart
Text(
  'greeting'.tr(
    gender: 'male',
    args: ['John'],
  ),
)
```

Output

```
Hello Mr. John
```

---

## Female

```dart
Text(
  'greeting'.tr(
    gender: 'female',
    args: ['Sara'],
  ),
)
```

Output

```
Hello Ms. Sara
```

---

## Other

```dart
Text(
  'greeting'.tr(
    gender: 'other',
    args: ['Alex'],
  ),
)
```

Output

```
Hello Alex
```

---

# Using `context`

Normally you **do not need** to pass a `BuildContext`.

```dart
'hello'.tr();
```

works perfectly.

`context` is only useful in advanced scenarios where Easy Localization cannot determine the correct localization context automatically.

---

# Complete Example

## en.json

```json
{
  "price": "Price: {} {currency}",
  "welcome": "Hello {name}",
  "login": {
    "male": "Welcome Mr. {}",
    "female": "Welcome Ms. {}"
  }
}
```

## Dart

### Positional + Named

```dart
Text(
  'price'.tr(
    args: ['250'],
    namedArgs: {
      'currency': 'SAR',
    },
  ),
)
```

Output

```
Price: 250 SAR
```

---

### Named Arguments

```dart
Text(
  'welcome'.tr(
    namedArgs: {
      'name': 'Mohamed',
    },
  ),
)
```

Output

```
Hello Mohamed
```

---

### Gender

```dart
Text(
  'login'.tr(
    gender: 'male',
    args: ['Mohamed'],
  ),
)
```

Output

```
Welcome Mr. Mohamed
```

---

# Best Practices

## ✅ Simple text

```dart
'home.title'.tr()
```

JSON

```json
{
  "home": {
    "title": "Home"
  }
}
```

---

## ✅ Dynamic values (Recommended)

```dart
'user.welcome'.tr(
  namedArgs: {
    'name': user.name,
  },
)
```

JSON

```json
{
  "user": {
    "welcome": "Welcome {name}"
  }
}
```

---

## ✅ Positional values

```dart
'result'.tr(
  args: [
    score.toString(),
    total.toString(),
  ],
)
```

JSON

```json
{
  "result": "{} out of {}"
}
```

---

## ✅ Gender-specific text

```dart
'profile.greeting'.tr(
  gender: user.gender,
  args: [user.name],
)
```

JSON

```json
{
  "profile": {
    "greeting": {
      "male": "Welcome Mr. {}",
      "female": "Welcome Ms. {}",
      "other": "Welcome {}"
    }
  }
}
```

---

# Summary

| Use Case | Recommended Parameter |
|----------|------------------------|
| Simple translation | None |
| Insert values by position | `args` |
| Insert values by name | `namedArgs` ✅ |
| Mix both | `args` + `namedArgs` |
| Gender-specific translations | `gender` |
| Advanced localization context | `context` (rarely needed) |

---

# Recommendation

For most Flutter projects:

- ✅ Use plain keys for static text.
- ✅ Prefer `namedArgs` for dynamic values because they are clearer and easier to maintain.
- ✅ Use `args` when positional placeholders (`{}`) make sense.
- ✅ Use `gender` only when translations genuinely differ by gender.
- ✅ Ignore `context` unless you have a specific advanced use case.