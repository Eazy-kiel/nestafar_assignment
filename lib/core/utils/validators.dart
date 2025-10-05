// lib/core/utils/validators.dart
class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }

    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      return 'Phone number is required';
    }

    final phoneRegex = RegExp(r'^(\+234|0)[789][01]\d{8}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Please enter a valid Nigerian phone number';
    }

    return null;
  }

  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? validateAddress(String? address) {
    if (address == null || address.trim().isEmpty) {
      return 'Address is required';
    }

    if (address.trim().length < 10) {
      return 'Please provide a more detailed address';
    }

    return null;
  }
}
