class ValidationUtils {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Invalid email format';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    final upperCase = RegExp(r'[A-Z]');
    final lowerCase = RegExp(r'[a-z]');
    final number = RegExp(r'\d');
    final specialChar = RegExp(r'[!@#\$&*~]');

    if (!upperCase.hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!lowerCase.hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!number.hasMatch(password)) {
      return 'Password must contain at least one number';
    }

    if (!specialChar.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    final commonPasswords = [
      '123456',
      'password',
      '123456789',
      'qwerty',
      '12345678',
    ];
    if (commonPasswords.contains(password.toLowerCase())) {
      return 'This password is too common. Please choose a stronger one';
    }

    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }

    if (name.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    final nameRegex = RegExp(r'^[a-zA-Z\s]+$');
    if (!nameRegex.hasMatch(name)) {
      return 'Name can only contain letters';
    }

    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return null;

    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    if (!phoneRegex.hasMatch(phone)) {
      return 'Invalid phone number';
    }

    return null;
  }

  static String? validateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'Date of birth is required';
    }

    final now = DateTime.now();
    final age =
        now.year -
        birthDate.year -
        ((now.month < birthDate.month ||
                (now.month == birthDate.month && now.day < birthDate.day))
            ? 1
            : 0);

    if (age < 13) {
      return 'You must be at least 13 years old';
    }

    return null;
  }
}
