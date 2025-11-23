// ignore_for_file: always_use_package_imports

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

class PrettySharedHelperGenerator extends Generator {
  const PrettySharedHelperGenerator();

  @override
  String generate(LibraryReader library, BuildStep buildStep) {
    return r'''
// === pretty_tostring shared helper ===

String obfuscateValue(Object? value) {
  if (value == null) return 'null';

  final RegExp email = RegExp(r'^([^@]{1})([^@]*)(@)([^\.]+)(.*)$');
  final match = email.firstMatch(value.toString());
  if (match != null) {
    final first = match.group(1);
    final middle = match.group(2)!.replaceAll(RegExp(r'.'), '*');
    final domainFirst = match.group(4)!.replaceAll(RegExp(r'.'), '*');
    final rest = match.group(5);
    return '"$first$middle@$domainFirst$rest"';
  }

  if (value is String && value.length >= 2) {
    final first = value[0];
    final last = value[value.length - 1];
    return "\"$first${'*' * (value.length - 2)}$last\"";
  }

  if (value is num) return '"***"';

  return '"***"';
}
''';
  }
}
