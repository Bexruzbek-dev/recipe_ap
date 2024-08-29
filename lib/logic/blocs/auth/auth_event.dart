import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterEvent extends AuthEvent {
  final String name;
  final String phone;
  final String email;
  final String password;
  final String passwordConfirmation;

  RegisterEvent(
    this.name,
    this.phone,
    this.email,
    this.password,
    this.passwordConfirmation,
  );

  @override
  List<Object?> get props => [name,phone,email, password,passwordConfirmation];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

class CheckLoginEvent extends AuthEvent {}

class AppStartedEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}
