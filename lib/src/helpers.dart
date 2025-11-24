String buildPrettyValueHelper(String className) {
  return '''
String _prettyValueFor$className(Object? value, int indent) {
  final String i = "\\t" * indent;
  final String ii = "\\t" * (indent + 1);

  if (value == null) {
    return 'null';
  }

  if (value is num || value is bool) {
    return value.toString();
  }

  if (value is String) {
    return '"\$value"';
  }

  if (value is List) {
    if (value.isEmpty) {
      return '[]';
    }

    // Smart sorting
    List<Object?> sorted = List<Object?>.from(value);

    // Sort strings alphabetically
    if (sorted.every((e) => e is String)) {
      sorted.sort((a, b) => (a as String).compareTo(b as String));
    }
    // Sort other Comparables
    else if (sorted.every((e) => e is Comparable)) {
      sorted.sort((a, b) => (a as Comparable).compareTo(b));
    }
    // Otherwise do not sort (mixed types)

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('[');

    for (int index = 0; index < sorted.length; index++) {
      final Object? item = sorted[index];
      buffer.write(ii);
      buffer.write(_prettyValueFor$className(item, indent + 1));

      if (index < sorted.length - 1) {
        buffer.writeln(',');
      } else {
        buffer.writeln();
      }
    }

    buffer.write('\$i]');
    return buffer.toString();
  }

  if (value is Map) {
    if (value.isEmpty) {
      return '{}';
    }
    final List<Object?> keys = value.keys.toList()
      ..sort((a, b) => a.toString().compareTo(b.toString()));
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('{');
    for (final Object? key in keys) {
      final Object? v = value[key];
      buffer.write('\$ii\$key: ');
      buffer.writeln(_prettyValueFor$className(v, indent + 1));
    }
    buffer.write('\$i}');
    return buffer.toString();
  }

  final String raw = value.toString();
  if (raw.contains('(') && raw.contains(')')) {
    return raw.replaceAll('\\n', '\\n\$i');
  }

  return value.toString();
}
''';
}
