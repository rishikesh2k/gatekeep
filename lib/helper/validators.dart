class Validators {
  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
      return 'Mobile number must be exactly 10 digits';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)*\.[a-zA-Z]{2,}$');
    if (!pattern.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? dropdown(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please select $fieldName';
    }
    return null;
  }
}
