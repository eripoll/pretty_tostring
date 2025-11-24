import 'dart:async';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class PrettySharedHelperGenerator extends Generator {
  const PrettySharedHelperGenerator();

  static final TypeChecker prettyChecker = const TypeChecker.fromUrl(
    'package:pretty_tostring/src/annotation.dart#PrettyPrintable',
  );

  @override
  FutureOr<String?> generate(LibraryReader library, BuildStep buildStep) {
    // Skip if library has no @PrettyPrintable()
    final bool hasAnnotatedClass = library.classes.any(
      (ClassElement c) => prettyChecker.hasAnnotationOfExact(c),
    );

    if (!hasAnnotatedClass) {
      return null; // silent skip, no warnings
    }

    return _emitHelper();
  }

  String _emitHelper() {
    return '''
// === pretty_tostring shared helper ===

String obfuscateValue(Object? value) {
  if (value == null) return 'null';

  final RegExp email = RegExp(r'^([^@]{1})([^@]*)(@)([^\\.]+)(.*)\$');
  final match = email.firstMatch(value.toString());
  if (match != null) {
    final first = match.group(1);
    final middle = match.group(2)!.replaceAll(RegExp(r'.'), '*');
    final domainFirst = match.group(4)!.replaceAll(RegExp(r'.'), '*');
    final rest = match.group(5);
    return '"\$first\$middle@\${domainFirst}\$rest"';
  }

  if (value is String && value.length >= 2) {
    final first = value[0];
    final last = value[value.length - 1];
    return '"\$first\${'*' * (value.length - 2)}\$last"';
  }

  return '"***"';
}
    ''';
  }
}
