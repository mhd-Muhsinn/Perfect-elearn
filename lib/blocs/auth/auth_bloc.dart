import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:perfect/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:perfect/repositories/auth_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<CheckLoginStatusEvent>(_checkLoginStatus);
    on<SignUpEvent>(_signUp);
    on<LogOutEvent>(_signOut);
    on<SignInEvent>(_signIn);
    on<GoogleSignInEvent>(_googleSign);
    on<CompleteProfileEvent>(_profileCompletion);
    on<ForgotPasswordEvent>(_forgotPassword);
  }
  Future<void> _forgotPassword(ForgotPasswordEvent event, Emitter<AuthState> emit) async {
  emit(ForgotPasswordLoading());
  try {
    await _authRepository.forgotPasswordemail(event.email);
    emit(ForgotPasswordSuccess());
  } catch (e) {
    emit(ForgotPasswordFailure(message: e.toString()));
  }
}

  Future<void> _profileCompletion(
      CompleteProfileEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.completeProfile(event.user, event.uid);
      emit(ProfileCompleted());
    } catch (e) {
      emit(ProfileCompletionError(message: e.toString()));
    }
  }

  Future<void> _googleSign(
      GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authRepository.signInWithGoogle();
      if (result != null) {
        if (result.isNew) {
          emit(NeedProfileCompletion(result.user));
        } else {
          emit(Authenticated(result.user));
        }
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthenticatedError(message: e.toString()));
    }
  }

  Future<void> _signIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await _authRepository.signInUser(event.email, event.password);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthenticatedError(message: e.toString()));
    }
  }

  Future<void> _signOut(LogOutEvent event, Emitter<AuthState> emit) async {
    try {
      await _authRepository.googleSignOut();
      emit(UnAuthenticated());
    } catch (e) {
      emit(AuthenticatedError(message: e.toString()));
    }
  }

  Future _signUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signUpUser(event.user);
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(UnAuthenticated());
      }
    } catch (e) {
      emit(AuthenticatedError(message: e.toString()));
    }
  }

  Future<void> _checkLoginStatus(
      CheckLoginStatusEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Future.delayed(Duration(seconds: 3), () async {
        final user = await _authRepository.getCurrentUser();
        user != null ? emit(Authenticated(user)) : emit(UnAuthenticated());
      });
    } catch (e) {
      emit(AuthenticatedError(message: e.toString()));
    }
  }
}
