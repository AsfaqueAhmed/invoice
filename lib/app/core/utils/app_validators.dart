abstract class AppValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field is required';
    }
    if (value.trim().length < 2) {
      return 'Field must be at least 2 characters';
    }
    return null;
  }

  static String? validateNameOptional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    if (value.trim().length < 2) {
      return 'Field must be at least 2 characters';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phone = value.trim();
    if (!RegExp(r'^01\d{9}$').hasMatch(phone)) {
      return 'Enter a valid 11-digit phone number';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();

    final regex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  static String? validateEmailOptional(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final email = value.trim();

    final regex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!regex.hasMatch(email)) {
      return 'Enter a valid email address';
    }

    return null;
  }
}
