import 'package:bloc/bloc.dart';
import 'package:recipe_app/logic/blocs/auth/auth_event.dart';
import 'package:recipe_app/logic/blocs/auth/auth_state.dart';
import 'package:recipe_app/logic/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<RegisterEvent>(_onRegister);
    on<AppStartedEvent>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<CheckLoginEvent>(_onCheckLogin);
    on<LogoutEvent>(_onLogout);
    add(AppStartedEvent());
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final data = await authRepository.registerUser(
        event.name,
        event.phone,
        event.email,
        event.password,
        event.passwordConfirmation,
      );
      emit(AuthAuthenticated(data['data']['token']));
    } catch (e) {
      emit(AuthError(_handleError(e)));
    }
  }

  Future<void> _onAppStarted(
      AppStartedEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String userToken = sharedPreferences.getString('userToken')!;

      emit(AuthAuthenticated(userToken));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final data = await authRepository.loginUser(event.email, event.password);

      emit(AuthAuthenticated(data['data']['token']));
    } catch (e) {
      emit(
        AuthError(
          _handleError(e),
        ),
      );
    }
  }

  Future<void> _onCheckLogin(
      CheckLoginEvent event, Emitter<AuthState> emit) async {
    final isLoggedIn = await authRepository.isLoggedIn();
    if (isLoggedIn) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      String userToken = sharedPreferences.getString('userToken')!;
      emit(AuthAuthenticated(userToken));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await authRepository.logout();
    emit(AuthUnauthenticated());
  }

  String _handleError(Object e) {
    String message = e.toString();
    if (message.contains("EMAIL_EXISTS")) {
      return "Bu email mavjud";
    } else if (message.contains("WEAK_PASSWORD")) {
      return "Parol juda qisqa!";
    } else if (message.contains("INVALID_LOGIN_CREDENTIALS")) {
      return "Parol yokiy email hato!";
    } else {
      return "$message Xato ro'y berdi. Iltimos, qayta urinib ko'ring.";
    }
  }
}
