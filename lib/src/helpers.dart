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
    final StringBuffer buffer = StringBuffer();
    buffer.writeln('[');
    for (final Object? item in value) {
      buffer.writeln(_prettyValueFor$className(item, indent + 1));
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
