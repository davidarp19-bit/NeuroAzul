import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/auth_repository.dart';

class AuthState {
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

final authViewModelProvider =
    NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);

class AuthViewModel extends Notifier<AuthState> {
  @override
  AuthState build() {
    return const AuthState();
  }

  Future<bool> register({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.register(
        email: email,
        password: password,
      );

      return true;
    } on AuthException catch (error) {
      state = state.copyWith(
        errorMessage: error.message,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage:
            'Ocurrió un error inesperado. Intenta nuevamente.',
      );

      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.login(
        email: email,
        password: password,
      );

      return true;
    } on AuthException catch (error) {
      state = state.copyWith(
        errorMessage: error.message,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage:
            'Ocurrió un error inesperado. Intenta nuevamente.',
      );

      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> logout() async {
    state = state.copyWith(
      isLoading: true,
      clearError: true,
    );

    try {
      final repository = ref.read(authRepositoryProvider);

      await repository.logout();

      return true;
    } on AuthException catch (error) {
      state = state.copyWith(
        errorMessage: error.message,
      );

      return false;
    } catch (_) {
      state = state.copyWith(
        errorMessage:
            'No fue posible cerrar la sesión. Intenta nuevamente.',
      );

      return false;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}