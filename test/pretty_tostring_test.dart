import 'package:test/test.dart';
import 'models.dart';

void main() {
  group('pretty_tostring', () {
    test('prints simple objects in alphabetical order', () {
      final Article article = Article(
        id: 10,
        internalSecret: 'XYZ123',
        email: 'erwan@example.com',
        title: 'My Article',
        comments: <Comment>[],
      );

      final String output = article.toString();

      expect(output.contains('Article('), isTrue);

      // alphabetical keys: comments, email, id, title
      final int commentsIndex = output.indexOf('comments:');
      final int emailIndex = output.indexOf('email:');
      final int idIndex = output.indexOf('id:');
      final int titleIndex = output.indexOf('title:');

      expect(commentsIndex < emailIndex, isTrue);
      expect(emailIndex < idIndex, isTrue);
      expect(idIndex < titleIndex, isTrue);
    });

    test('ignores @PrettyIgnore fields', () {
      final Article article = Article(
        id: 10,
        internalSecret: 'SHOULD_NOT_APPEAR',
        email: 'erwan@example.com',
        title: 'My Article',
        comments: <Comment>[],
      );

      final String output = article.toString();

      expect(output.contains('internalSecret'), isFalse);
    });

    test('obfuscates @PrettyObfuscate fields', () {
      final Article article = Article(
        id: 10,
        internalSecret: 'NOPE',
        email: 'erwan@example.com',
        title: 'My Article',
        comments: <Comment>[],
      );

      final String output = article.toString();

      expect(output.contains('erwan@example.com'), isFalse);
    });

    test('prints nested objects with indentation', () {
      final Article article = Article(
        id: 10,
        internalSecret: 'NOPE',
        email: 'erwan@example.com',
        title: 'My Article',
        comments: <Comment>[Comment(author: 'Alex', text: 'Great!')],
      );

      final String output = article.toString();

      expect(output.contains('Comment('), isTrue);

      // Nested indentation => should contain "\t\t" before fields
      expect(output.contains('\t\tauthor:'), isTrue);
      expect(output.contains('\t\ttext:'), isTrue);
    });
  });
}
