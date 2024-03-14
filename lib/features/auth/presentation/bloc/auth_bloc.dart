import 'dart:async';
import 'dart:developer';
import 'package:blog_clean_architecture/core/common/entities/profile.dart';
import 'package:blog_clean_architecture/features/auth/domain/usecases/current_user.dart';
import 'package:blog_clean_architecture/features/auth/domain/usecases/user_login.dart';
import 'package:blog_clean_architecture/features/auth/domain/usecases/user_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/common/cubits/app_user_cubit/app_user_cubit.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc({
    required UserLogin userLogin,
    required UserSignUp userSignUp,
    required CurrentUser currentUser,
    required AppUserCubit appUserCubit,
  })  : _userSignUp = userSignUp,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));
    on<AuthSignUpEvent>(_authSignup);
    on<AuthLoginEvent>(_authLogin);
    on<AuthIsUserLoggedIn>(_authIsUserLoggedIn);
  }

  Future<void> _authSignup(
    AuthSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userSignUp(
      UserSignupParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  Future<void> _authLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _userLogin(
      UserLoginParams(email: event.email, password: event.password),
    );
    res.fold((failure) => emit(AuthFailure(message: failure.message)),
        (user) => _emitAuthSuccess(user, emit));
  }

  FutureOr<void> _authIsUserLoggedIn(
    AuthIsUserLoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    final res = await _currentUser(NoParams());
    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) {
        _emitAuthSuccess(user, emit);
        // log('${user.name} ${user.email}');
        // emit(AuthSuccess(user: user));
      },
    );
  }

  void _emitAuthSuccess(UserEntity userEntity, Emitter emit) {
    _appUserCubit.updateUser(userEntity);
    emit(AuthSuccess(user: userEntity));
  }

  @override
  void onChange(Change<AuthState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
