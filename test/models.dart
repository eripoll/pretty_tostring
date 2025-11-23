import 'package:pretty_tostring/pretty_tostring.dart';

part 'models.pretty.g.dart';

@PrettyPrintable()
class Comment {
  Comment({required this.author, required this.text});
  final String author;
  final String text;

  @override
  String toString() => prettyToString();
}

@PrettyPrintable()
class Article {
  Article({
    required this.id,
    required this.internalSecret,
    required this.email,
    required this.title,
    required this.comments,
  });
  final int id;

  @PrettyIgnore()
  final String internalSecret;

  @PrettyObfuscate()
  final String email;

  final String title;
  final List<Comment> comments;

  @override
  String toString() => prettyToString();
}
