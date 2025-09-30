part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckLoginStatusEvent extends AuthEvent {}

//Login or SignInEvnet
class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  SignInEvent({required this.email, required this.password});
}

//SignUP or Register
class SignUpEvent extends AuthEvent {
  final UserModel user;
  SignUpEvent({required this.user});
}

//Googlesign
class GoogleSignInEvent extends AuthEvent {}

//CompleteProfile
class CompleteProfileEvent extends AuthEvent {
  final UserModel user;
  final String? uid;
  CompleteProfileEvent({required this.user, required this.uid});
}

//ForgotPassword
class ForgotPasswordEvent extends AuthEvent {
  final String email;
  ForgotPasswordEvent({required this.email});
}

//Logout
class LogOutEvent extends AuthEvent {}
