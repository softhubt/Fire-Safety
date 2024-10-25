class FormValidationServices {
  static String? Function(String?)? validateField({required String fieldName}) {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return '$fieldName is required';
      }
      return null;
    };
  }

  static String? Function(String?)? validateEmail() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Email is required';
      }
      if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
          .hasMatch(value)) {
        return 'Enter a valid email';
      }
      return null;
    };
  }

  static String? Function(String?)? validatePhone() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return 'Mobile number is required';
      }

      String numericValue = value.replaceAll(RegExp(r'[^0-9]'), '');

      if (numericValue.length != 10) {
        return 'Enter a valid 10-digit mobile number';
      }
      return null;
    };
  }

  static String? Function(String?)? validatePassword() {
    return (String? value) {
      if (value == null || value.isEmpty) {
        return "Password is required";
      } else if (value.length < 8) {
        return "Password must have a minimum of 8 characters";
      } else if (!value.contains(RegExp(r'[A-Z]'))) {
        return "Password must contain at least 1 uppercase letter";
      } else if (!value.contains(RegExp(r'[a-z]'))) {
        return "Password must contain at least 1 lowercase letter";
      } else if (!value.contains(RegExp(r'[0-9]'))) {
        return "Password must contain at least 1 number";
      } else if (value.contains(RegExp(r'\s'))) {
        return "Password must not contain spaces";
      }
      return null;
    };
  }
}
