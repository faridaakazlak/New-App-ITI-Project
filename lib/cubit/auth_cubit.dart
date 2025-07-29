import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/user_model.dart';
import 'package:news_app/services/local_auth_service.dart';
import 'auth_state.dart';
import '../utils/validation_utils.dart';

class AuthCubit extends Cubit<AuthState> {
  final LocalAuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> login(String email, String password, bool rememberMe) async {
    emit(AuthLoading());

    final error =
        ValidationUtils.validateEmail(email) ??
        ValidationUtils.validatePassword(password);

    if (error != null) {
      emit(AuthError(error, 'email/password'));
      return;
    }

    final success = await _authService.login(email, password, rememberMe: true);
    if (success) {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Failed to load user', 'internal'));
      }
    } else {
      emit(AuthError('Invalid email or password', 'login'));
    }
  }

  Future<void> register(UserModel userData) async {
    emit(AuthLoading());

    final errors = <String, String>{};

    final emailError = ValidationUtils.validateEmail(userData.email);
    final passError = ValidationUtils.validatePassword(userData.passwordHash);
    final nameError = ValidationUtils.validateName(userData.firstName);
    final phoneError = userData.phoneNumber != null
        ? ValidationUtils.validatePhone(userData.phoneNumber!)
        : null;
    final ageError = ValidationUtils.validateAge(userData.dateOfBirth);

    if (emailError != null) errors['email'] = emailError;
    if (passError != null) errors['password'] = passError;
    if (nameError != null) errors['firstName'] = nameError;
    if (phoneError != null) errors['phoneNumber'] = phoneError;
    if (ageError != null) errors['dateOfBirth'] = ageError;

    if (errors.isNotEmpty) {
      emit(AuthValidationError(errors));
      return;
    }

    final exists = await _authService.isUserExists(userData.email);
    if (exists) {
      emit(AuthError('Email already registered', 'email'));
      return;
    }

    final success = await _authService.register(userData);
    if (success) {
      emit(AuthRegistered(userData));
    } else {
      emit(AuthError('Registration failed', 'internal'));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authService.logout();
    emit(AuthLoggedOut());
  }

  Future<void> checkAuthStatus() async {
    final user = await _authService.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthLoggedOut());
    }
  }

  void validateForm(Map<String, dynamic> formData) {
    final errors = <String, String>{};

    if (formData.containsKey('email')) {
      final emailError = ValidationUtils.validateEmail(formData['email']);
      if (emailError != null) errors['email'] = emailError;
    }

    if (formData.containsKey('password')) {
      final passError = ValidationUtils.validatePassword(formData['password']);
      if (passError != null) errors['password'] = passError;
    }

    if (formData.containsKey('firstName')) {
      final nameError = ValidationUtils.validateName(formData['firstName']);
      if (nameError != null) errors['firstName'] = nameError;
    }

    if (formData.containsKey('phoneNumber') &&
        formData['phoneNumber'] != null) {
      final phoneError = ValidationUtils.validatePhone(formData['phoneNumber']);
      if (phoneError != null) errors['phoneNumber'] = phoneError;
    }

    if (formData.containsKey('dateOfBirth')) {
      final ageError = ValidationUtils.validateAge(formData['dateOfBirth']);
      if (ageError != null) errors['dateOfBirth'] = ageError;
    }

    if (errors.isNotEmpty) {
      emit(AuthValidationError(errors));
    }
  }

  Future<void> updateProfile(UserModel updatedUser) async {
    emit(AuthLoading());
    final success = await _authService.updateProfile(updatedUser);
    if (success) {
      emit(AuthSuccess(updatedUser));
    } else {
      emit(AuthError('Failed to update profile', 'update'));
    }
  }

  Future<void> changePassword(
    String email,
    String oldPassword,
    String newPassword,
  ) async {
    emit(AuthLoading());

    final passError = ValidationUtils.validatePassword(newPassword);
    if (passError != null) {
      emit(AuthError(passError, 'password'));
      return;
    }

    final success = await _authService.changePassword(
      email,
      oldPassword,
      newPassword,
    );
    if (success) {
      final user = await _authService.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(
          AuthError(
            'Password changed but user could not be loaded',
            'internal',
          ),
        );
      }
    } else {
      emit(AuthError('Old password is incorrect', 'oldPassword'));
    }
  }
}
