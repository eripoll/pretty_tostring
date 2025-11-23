// ignore_for_file: lines_longer_than_80_chars, always_use_package_imports

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'annotation.dart';
import 'helpers.dart';

const TypeChecker _prettyIgnoreChecker = TypeChecker.fromUrl(
  'package:pretty_tostring/src/field_annotations.dart#PrettyIgnore',
);

const TypeChecker _prettyObfuscateChecker = TypeChecker.fromUrl(
  'package:pretty_tostring/src/field_annotations.dart#PrettyObfuscate',
);

class PrettyGenerator extends GeneratorForAnnotation<PrettyPrintable> {
  const PrettyGenerator();

  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    if (element is! ClassElement) {
      throw InvalidGenerationSourceError(
        '@PrettyPrintable can only be used on classes.',
        element: element,
      );
    }

    final ClassElement clazz = element;
    final String className = clazz.name!; // non-null for classes

    final List<FieldElement> fields =
        clazz.fields
            .where((FieldElement f) => !f.isStatic && !f.isSynthetic)
            .toList()
          ..sort(
            (FieldElement a, FieldElement b) => a.name!.compareTo(b.name!),
          );

    final StringBuffer buf = StringBuffer();

    // ---------- Extension with prettyToString ----------
    buf.writeln('// pretty_tostring for $className');
    buf.writeln('extension ${className}PrettyToString on $className {');
    buf.writeln('  String prettyToString({int indent = 0}) {');
    buf.writeln('    return _pretty$className(this, indent);');
    buf.writeln('  }');
    buf.writeln('}');
    buf.writeln('');

    // ---------- Per-class pretty printer ----------
    buf.writeln('String _pretty$className($className instance, int indent) {');
    buf.writeln("  final String i = '\\t' * indent;");
    buf.writeln("  final String ii = '\\t' * (indent + 1);");
    buf.writeln('  final StringBuffer buffer = StringBuffer();');
    // IMPORTANT: avoid `$i$className` → that becomes `iComment`
    buf.writeln("  buffer.writeln('\${i}$className(');");

    for (final FieldElement field in fields) {
      final String fieldName = field.name!;

      final bool ignore = _prettyIgnoreChecker.hasAnnotationOf(field);
      if (ignore) {
        continue;
      }

      final bool obfuscate = _prettyObfuscateChecker.hasAnnotationOf(field);

      final String valueExpression = obfuscate
          ? 'obfuscateValue(instance.$fieldName)'
          : '_prettyValueFor$className(instance.$fieldName, indent + 1)';

      buf.writeln(
        '  buffer.writeln("\${ii}$fieldName: \${$valueExpression},");',
      );
    }

    buf.writeln("  buffer.write('\${i})');");
    buf.writeln('  return buffer.toString();');
    buf.writeln('}');
    buf.writeln('');

    // ---------- Nested value helper (per class) ----------
    buf.write(buildPrettyValueHelper(className));

    return buf.toString();
  }
}
