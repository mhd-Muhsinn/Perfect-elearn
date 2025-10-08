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
  const SignInEvent({required this.email, required this.password});
}

//SignUP or Register
class SignUpEvent extends AuthEvent {
  final UserModel user;
  final BuildContext context;
  const SignUpEvent({required this.user,required this.context});
}

//Googlesign
class GoogleSignInEvent extends AuthEvent {
  final BuildContext context;

  const GoogleSignInEvent({required this.context});
}

//CompleteProfile
class CompleteProfileEvent extends AuthEvent {
  final UserModel user;
  final String? uid;
  final BuildContext context;
  const CompleteProfileEvent({required this.context,required this.user, required this.uid});
}

//ForgotPassword
class ForgotPasswordEvent extends AuthEvent {
  final String email;
  const ForgotPasswordEvent({required this.email});
}

//Logout
class LogOutEvent extends AuthEvent {}
