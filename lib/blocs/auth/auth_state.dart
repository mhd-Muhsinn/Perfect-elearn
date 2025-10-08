part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  User? user;
  final UserModel? userModel;
  Authenticated(
    this.user,
    {
      this.userModel
    }
  );
}

class GoogleAuthenticated extends AuthState {
  User? user;
}

class NeedProfileCompletion extends AuthState {
  final User user;

  const NeedProfileCompletion(
    this.user,
  );
}

class UnAuthenticated extends AuthState {
  final String? message;
  const UnAuthenticated({this.message});
}

class AuthenticatedError extends AuthState {
  final String message;
  const AuthenticatedError({required this.message});
}

class ProfileCompleted extends AuthState {
  final UserModel user;

  const ProfileCompleted(this.user);
}

class ProfileCompletionError extends AuthState {
  String message;
  ProfileCompletionError({required this.message});
}

class ForgotPasswordLoading extends AuthState {}

class ForgotPasswordSuccess extends AuthState {}

class ForgotPasswordFailure extends AuthState {
  final String message;
  const ForgotPasswordFailure({required this.message});
}
