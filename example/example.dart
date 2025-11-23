import 'package:pretty_tostring/pretty_tostring.dart';

part '../example.pretty.g.dart';

@PrettyPrintable()
class Person {
  final String name;

  @PrettyObfuscate()
  final String email;

  Person({required this.name, required this.email});

  @override
  String toString() => prettyToString();
}

void main() {
  print(Person(name: 'Erwan', email: 'erwan@example.com'));
}
