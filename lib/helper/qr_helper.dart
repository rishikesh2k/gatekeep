class QrHelper {
  static String? readVisitorId(String? rawValue) {
    if (rawValue == null) {
      return null;
    }
    final value = rawValue.trim();
    if (value.isEmpty || value.length > 40) {
      return null;
    }
    if (!RegExp(r'^[A-Za-z0-9-_]+$').hasMatch(value)) {
      return null;
    }
    return value;
  }
}
