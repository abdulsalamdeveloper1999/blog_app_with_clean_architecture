import 'package:blog_clean_architecture/core/error/exceptions.dart';
import 'package:blog_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/supabase_constants.dart';

//abstract class
abstract interface class AuthRemoteDataSource {
  Session? get currentUserSession;

  Future<UserModel> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel?> getCurrentUser();
}

//implemnted class
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;

  AuthRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Session? get currentUserSession => supabaseClient.auth.currentSession;

  @override
  Future<UserModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        password: password,
        email: email,
      );
      if (response.user == null) {
        throw ServerException(error: 'User is null');
      }
      return UserModel.fromJson(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(error: e.message);
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }

  @override
  Future<UserModel> signupWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        password: password,
        email: email,
        data: {'name': name},
      );
      if (response.user == null) {
        throw ServerException(error: 'User is null');
      }
      final user = UserModel.fromJson(response.user!.toJson());
      return user;
    } on AuthException catch (e) {
      throw ServerException(error: e.message);
    } on ServerException catch (e) {
      throw ServerException(error: e.error);
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (currentUserSession != null) {
        final userData = await supabaseClient
            .from(SupabaseConstants.userTableName)
            .select()
            .eq(
              'id',
              currentUserSession!.user.id,
            );
        return UserModel.fromJson(userData.first).copyWith(
          email: currentUserSession!.user.email,
        );
      }
      return null;
    } catch (e) {
      throw ServerException(error: e.toString());
    }
  }
}
