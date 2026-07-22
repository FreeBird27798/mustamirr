import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/student/data/datasources/student_remote_datasource.dart';
import '../../features/student/data/repositories/student_repository_impl.dart';
import '../../features/student/domain/repositories/student_repository.dart';
import '../../features/student/domain/usecases/delete_download_usecase.dart';
import '../../features/student/domain/usecases/download_lesson_usecase.dart';
import '../../features/student/domain/usecases/get_downloads_usecase.dart';
import '../../features/student/domain/usecases/get_favorites_usecase.dart';
import '../../features/student/domain/usecases/get_lessons_usecase.dart';
import '../../features/student/domain/usecases/get_notifications_usecase.dart';
import '../../features/student/domain/usecases/get_recent_lessons_usecase.dart';
import '../../features/student/domain/usecases/get_subjects_usecase.dart';
import '../../features/student/domain/usecases/toggle_favorite_usecase.dart';
import '../../features/student/presentation/bloc/downloads/downloads_bloc.dart';
import '../../features/student/presentation/bloc/favorites/favorites_bloc.dart';
import '../../features/student/presentation/bloc/lessons/lessons_bloc.dart';
import '../../features/student/presentation/bloc/notifications/notifications_bloc.dart';
import '../../features/student/presentation/bloc/student_home/student_home_bloc.dart';
import '../../features/student/presentation/bloc/subjects/subjects_bloc.dart';
import '../api/api_client.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());

  // Core
  sl.registerLazySingleton(() => ApiClient(sl()));

  // Auth — Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl(), sharedPreferences: sl()),
  );

  // Auth — Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Auth — Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Auth — Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Student — Data sources
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(),
  );

  // Student — Repository
  sl.registerLazySingleton<StudentRepository>(
    () => StudentRepositoryImpl(remoteDataSource: sl()),
  );

  // Student — Use cases
  sl.registerLazySingleton(() => GetSubjectsUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentLessonsUseCase(sl()));

  // Student - Bloc
  sl.registerFactory(
    () => StudentHomeBloc(
      getSubjectsUseCase: sl(),
      getRecentLessonsUseCase: sl(),
      toggleFavoriteUseCase: sl(),
    ),
  );

  // Student - Use cases (Favorites)
  sl.registerLazySingleton(() => GetFavoritesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleFavoriteUseCase(sl()));

  // Student - Bloc (Favorites)
  sl.registerFactory(
    () => FavoritesBloc(getFavoritesUseCase: sl(), toggleFavoriteUseCase: sl()),
  );

  // Student - Use cases (Downloads)
  sl.registerLazySingleton(() => GetDownloadsUseCase(sl()));
  sl.registerLazySingleton(() => DeleteDownloadUseCase(sl()));

  // Student - Bloc (Downloads)
  sl.registerFactory(
    () => DownloadsBloc(getDownloadsUseCase: sl(), deleteDownloadUseCase: sl()),
  );

  // Student - Bloc (Lessons)
  sl.registerFactory(
    () => LessonsBloc(
      getLessonsUseCase: sl(),
      toggleFavoriteUseCase: sl(),
      downloadLessonUseCase: sl(),
    ),
  );

  // Student - Use cases (Lessons)
  sl.registerLazySingleton(() => GetLessonsUseCase(sl()));
  sl.registerLazySingleton(() => DownloadLessonUseCase(sl()));

  // Student - Use cases (Notifications)
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));

  // Student - Bloc (Notifications)
  sl.registerFactory(() => NotificationsBloc(getNotificationsUseCase: sl()));

  // Student - Bloc (Subjects)
  // Reuses GetSubjectsUseCase already registered above (Student — Use cases)
  sl.registerFactory(() => SubjectsBloc(getSubjectsUseCase: sl()));
}
