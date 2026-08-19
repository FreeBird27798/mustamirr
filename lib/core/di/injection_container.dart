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
import '../../features/teacher/data/datasources/teacher_remote_datasource.dart';
import '../../features/teacher/data/repositories/teacher_repository_impl.dart';
import '../../features/teacher/domain/repositories/teacher_repository.dart';
import '../../features/teacher/domain/usecases/add_lesson_usecase.dart';
import '../../features/teacher/domain/usecases/delete_lesson_usecase.dart';
import '../../features/teacher/domain/usecases/get_dashboard_stats_usecase.dart';
import '../../features/teacher/domain/usecases/get_my_lessons_usecase.dart';
import '../../features/teacher/domain/usecases/get_my_students_usecase.dart';
import '../../features/teacher/domain/usecases/update_lesson_usecase.dart';
import '../../features/teacher/presentation/bloc/dashboard/dashboard_bloc.dart';
import '../../features/teacher/presentation/bloc/students/students_bloc.dart';
import '../../features/teacher/presentation/bloc/teacher_lessons/teacher_lessons_bloc.dart';
import '../../features/admin/data/datasources/admin_remote_datasource.dart';
import '../../features/admin/data/repositories/admin_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_repository.dart';
import '../../features/admin/domain/usecases/get_admin_stats_usecase.dart';
import '../../features/admin/domain/usecases/get_users_usecase.dart';
import '../../features/admin/domain/usecases/toggle_user_active_usecase.dart';
import '../../features/admin/domain/usecases/delete_user_usecase.dart';
import '../../features/admin/domain/usecases/get_enrollment_requests_usecase.dart';
import '../../features/admin/domain/usecases/approve_request_usecase.dart';
import '../../features/admin/domain/usecases/reject_request_usecase.dart';
import '../../features/admin/domain/usecases/get_institutions_usecase.dart';
import '../../features/admin/domain/usecases/add_institution_usecase.dart';
import '../../features/admin/domain/usecases/delete_institution_usecase.dart';
import '../../features/admin/domain/usecases/get_admin_subjects_usecase.dart';
import '../../features/admin/domain/usecases/add_subject_usecase.dart';
import '../../features/admin/domain/usecases/delete_subject_usecase.dart';
import '../../features/admin/domain/usecases/get_content_usecase.dart';
import '../../features/admin/domain/usecases/delete_content_usecase.dart';
import '../../features/admin/presentation/bloc/admin_dashboard/admin_dashboard_bloc.dart';
import '../../features/admin/presentation/bloc/users/users_bloc.dart';
import '../../features/admin/presentation/bloc/enrollment/enrollment_bloc.dart';
import '../../features/admin/presentation/bloc/institutions/institutions_bloc.dart';
import '../../features/admin/presentation/bloc/admin_subjects/admin_subjects_bloc.dart';
import '../../features/admin/presentation/bloc/content/content_bloc.dart';
import '../api/api_client.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/resend_verification_usecase.dart';
import '../../features/auth/domain/usecases/verify_email_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/cubit/session_cubit.dart';

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
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
  sl.registerLazySingleton(() => ResendVerificationUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Auth — Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      verifyEmailUseCase: sl(),
      resendVerificationUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Auth — Session (app-wide current user)
  sl.registerLazySingleton(() => SessionCubit(sl()));

  // Student — Data sources
  sl.registerLazySingleton<StudentRemoteDataSource>(
    () => StudentRemoteDataSourceImpl(apiClient: sl()),
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

  // ===== Teacher =====

  // Teacher - Data source
  sl.registerLazySingleton<TeacherRemoteDataSource>(
    () => TeacherRemoteDataSourceImpl(),
  );

  // Teacher - Repository
  sl.registerLazySingleton<TeacherRepository>(
    () => TeacherRepositoryImpl(remoteDataSource: sl()),
  );

  // Teacher - Use cases
  sl.registerLazySingleton(() => GetDashboardStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetMyLessonsUseCase(sl()));
  sl.registerLazySingleton(() => GetMyStudentsUseCase(sl()));
  sl.registerLazySingleton(() => AddLessonUseCase(sl()));
  sl.registerLazySingleton(() => UpdateLessonUseCase(sl()));
  sl.registerLazySingleton(() => DeleteLessonUseCase(sl()));

  // Teacher - Blocs
  sl.registerFactory(
    () => DashboardBloc(
      getDashboardStatsUseCase: sl(),
      getMyLessonsUseCase: sl(),
      addLessonUseCase: sl(),
      updateLessonUseCase: sl(),
      deleteLessonUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => TeacherLessonsBloc(
      getMyLessonsUseCase: sl(),
      deleteLessonUseCase: sl(),
      addLessonUseCase: sl(),
      updateLessonUseCase: sl(),
    ),
  );
  sl.registerFactory(() => StudentsBloc(getMyStudentsUseCase: sl()));

  // ===== Admin =====

  // Admin - Data source
  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(),
  );

  // Admin - Repository
  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(remoteDataSource: sl()),
  );

  // Admin - Use cases
  sl.registerLazySingleton(() => GetAdminStatsUseCase(sl()));
  sl.registerLazySingleton(() => GetUsersUseCase(sl()));
  sl.registerLazySingleton(() => ToggleUserActiveUseCase(sl()));
  sl.registerLazySingleton(() => DeleteUserUseCase(sl()));
  sl.registerLazySingleton(() => GetEnrollmentRequestsUseCase(sl()));
  sl.registerLazySingleton(() => ApproveRequestUseCase(sl()));
  sl.registerLazySingleton(() => RejectRequestUseCase(sl()));
  sl.registerLazySingleton(() => GetInstitutionsUseCase(sl()));
  sl.registerLazySingleton(() => AddInstitutionUseCase(sl()));
  sl.registerLazySingleton(() => DeleteInstitutionUseCase(sl()));
  sl.registerLazySingleton(() => GetAdminSubjectsUseCase(sl()));
  sl.registerLazySingleton(() => AddSubjectUseCase(sl()));
  sl.registerLazySingleton(() => DeleteSubjectUseCase(sl()));
  sl.registerLazySingleton(() => GetContentUseCase(sl()));
  sl.registerLazySingleton(() => DeleteContentUseCase(sl()));

  // Admin - Blocs
  sl.registerFactory(() => AdminDashboardBloc(getAdminStatsUseCase: sl()));
  sl.registerFactory(
    () => UsersBloc(
      getUsersUseCase: sl(),
      toggleUserActiveUseCase: sl(),
      deleteUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => EnrollmentBloc(
      getEnrollmentRequestsUseCase: sl(),
      approveRequestUseCase: sl(),
      rejectRequestUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => InstitutionsBloc(
      getInstitutionsUseCase: sl(),
      addInstitutionUseCase: sl(),
      deleteInstitutionUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => AdminSubjectsBloc(
      getAdminSubjectsUseCase: sl(),
      addSubjectUseCase: sl(),
      deleteSubjectUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ContentBloc(getContentUseCase: sl(), deleteContentUseCase: sl()),
  );
}
