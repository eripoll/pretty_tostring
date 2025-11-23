# pretty_tostring

A code-generation package that produces beautifully formatted, deeply-nested,
alphabetically-ordered `toString()` output for Dart classes.

This package is designed for developers who want **debug-friendly, human-readable**
string representations without writing boilerplate. Simply annotate your class with
`@PrettyPrintable()`, run the generator, and enjoy clean output.

```dart
@PrettyPrintable()
class Article {
  final int id;

  @PrettyIgnore()
  final String secretCode;

  @PrettyObfuscate()
  final String email;

  final String title;
  final List<Comment> comments;

  Article({
    required this.id,
    required this.secretCode,
    required this.email,
    required this.title,
    required this.comments,
  });

  @override
  String toString() => prettyToString();
}
```

Generated output:

```
Article(
    comments: [],
    email: "e*********@*****.com",
    id: 10,
    title: "My Article",
)
```

## ✨ Features

- Alphabetical property ordering
- Pretty indentation with tabs
- Deep recursive rendering of nested objects
- List and Map pretty-printing
- `@PrettyIgnore()` to omit sensitive fields
- `@PrettyObfuscate()` to anonymize Personal Information fields such as emails
- Optional multi-line and indentation control
- Zero boilerplate — fully code-generated

## 🛠 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  pretty_tostring: ^1.0.0

dev_dependencies:
  build_runner: ^2.4.0
```

## 🚀 Usage

Annotate your class:

```dart
@PrettyPrintable()
class MyClass {
  final String name;

  @override
  String toString() => prettyToString();
}
```

Add a part statement:

```dart
part 'my_class.pretty.g.dart';
```

Then run:

```bash
dart run build_runner build
```

Your `.pretty.g.dart` file will be generated automatically.

## 🧩 Field-level Annotations

### Ignore a field

```dart
@PrettyIgnore()
final String internalSecret;
```

### Obfuscate a field (example: email)

```dart
@PrettyObfuscate()
final String email;
```

## 📦 Example

See the `example/` folder for a complete working demo.

## 📚 API Reference

Full documentation is generated when the package is published to pub.dev.

## 🤝 Contributions

Issues and pull requests are welcome!  
Visit the repository:  
<your GitHub URL>

## 📄 License

MIT License — see [LICENSE](LICENSE).
