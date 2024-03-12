import 'package:blog_clean_architecture/core/common/entities/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(UserEntity? userEntity) {
    if (userEntity == null) {
      emit(
        AppUserInitial(),
      );
    } else {
      emit(
        AppUserLoggedIn(userEntity: userEntity),
      );
    }
  }
}
