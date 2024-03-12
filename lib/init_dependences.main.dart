part of 'init_dependences.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlogs();

  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnnonKey,
  );
  //lazy single tone use single instance and factory register use new instance every time it calls

  Hive.defaultDirectory = (await getApplicationCacheDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(internetConnection: serviceLocator()),
  );
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImp(
        authRemoteDataSource: serviceLocator(),
        connectionChecker: serviceLocator(),
      ),
    )
    ..registerFactory(() => UserSignUp(
          authRepository: serviceLocator(),
        ))
    ..registerFactory(() => UserLogin(
          authRepository: serviceLocator(),
        ))
    ..registerFactory(() => CurrentUser(
          authRepository: serviceLocator(),
        ))
    ..registerLazySingleton(() => AuthBloc(
          userSignUp: serviceLocator(),
          userLogin: serviceLocator(),
          currentUser: serviceLocator(),
          appUserCubit: serviceLocator(),
        ));
}

void _initBlogs() {
  //Datasource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(() => BlogRemoteDataSourceImpl(
          supabaseClient: serviceLocator(),
        ))
    ..registerFactory<BlogLocalDataSource>(() => BlogLocalDataSourceImpl(
          box: serviceLocator(),
        ))
    //Repository
    ..registerFactory<BlogRepository>(() => BlogRepositoryImpl(
          blogRemoteDataSource: serviceLocator(),
          blogLocalDataSource: serviceLocator(),
          connectionChecker: serviceLocator(),
        ))
    //Usecase
    ..registerFactory(() => UploadBlog(
          blogRepository: serviceLocator(),
        ))
    ..registerFactory(() => GetAllBlogs(
          blogRepository: serviceLocator(),
        ))
    //Presentaion
    ..registerLazySingleton(() => BlogBloc(
          uploadBlog: serviceLocator(),
          getAllBlogs: serviceLocator(),
        ));
}
