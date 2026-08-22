import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../models/affiliation_models.dart';
import '../models/lesson_model.dart';
import '../models/notification_model.dart';
import '../models/subject_model.dart';

abstract class StudentRemoteDataSource {
  Future<List<SubjectModel>> getSubjects();
  Future<List<LessonModel>> getRecentLessons();
  Future<List<LessonModel>> getLessons(int subjectId);
  Future<List<LessonModel>> getFavorites();
  Future<List<LessonModel>> getDownloads();
  Future<List<NotificationModel>> getNotifications();
  Future<int> getUnreadCount();
  Future<void> markAllNotificationsRead();
  Future<void> toggleFavorite(int lessonId);
  Future<void> downloadLesson(int lessonId);
  Future<void> deleteDownload(int lessonId);

  // ===== Affiliation (institution selection) =====
  Future<List<InstitutionTypeModel>> getInstitutionTypes();
  Future<List<InstitutionModel>> getInstitutions(String type);
  Future<List<AcademicLevelModel>> getLevels(int institutionId);
  Future<List<SpecializationModel>> getSpecializations(int levelId);
  Future<AffiliationStatusModel?> getAffiliationStatus();
  Future<void> submitAffiliation({
    required String institutionType,
    required int institutionId,
    required int academicLevelId,
    required int specializationId,
  });
}

class StudentRemoteDataSourceImpl implements StudentRemoteDataSource {
  final ApiClient apiClient;

  StudentRemoteDataSourceImpl({required this.apiClient});

  Dio get _dio => apiClient.dio;

  List<Map<String, dynamic>> _asList(dynamic data) {
    return (data as List)
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  @override
  Future<List<SubjectModel>> getSubjects() async {
    final res = await _dio.get('/student/subjects');
    return _asList(res.data['data']).map(SubjectModel.fromJson).toList();
  }

  @override
  Future<List<LessonModel>> getRecentLessons() async {
    // NOTE: recent lessons live in /student/dashboard, which currently returns
    // a 500 on the backend while affiliation is pending. Returns empty until
    // the backend fixes the dashboard query.
    return [];
  }

  @override
  Future<List<LessonModel>> getLessons(int subjectId) async {
    final res = await _dio.get('/student/subjects/$subjectId/lessons');
    return _asList(res.data['data']).map(LessonModel.fromJson).toList();
  }

  @override
  Future<List<LessonModel>> getFavorites() async {
    final res = await _dio.get('/student/favorites');
    return _asList(res.data['data']).map(LessonModel.fromJson).toList();
  }

  @override
  Future<List<LessonModel>> getDownloads() async {
    // Shape: { data: { storage: {...}, items: [...] } }
    final res = await _dio.get('/student/downloads');
    return _asList(
      res.data['data']['items'],
    ).map(LessonModel.fromJson).toList();
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final res = await _dio.get('/notifications');
    return _asList(res.data['data']).map(NotificationModel.fromJson).toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final res = await _dio.get('/notifications/unread-count');
    return (res.data['data']['unread_count'] as num?)?.toInt() ?? 0;
  }

  @override
  Future<void> markAllNotificationsRead() async {
    // The host (LiteSpeed) blocks the PATCH method with a 403, so we use
    // Laravel's method spoofing: POST with a `_method=PATCH` form field.
    await _dio.post(
      '/notifications/read-all',
      data: {'_method': 'PATCH'},
      options: Options(contentType: Headers.formUrlEncodedContentType),
    );
  }

  @override
  Future<void> toggleFavorite(int lessonId) async {
    await _dio.post('/student/favorites/$lessonId/toggle');
  }

  @override
  Future<void> downloadLesson(int lessonId) async {
    await _dio.post('/student/downloads/$lessonId');
  }

  @override
  Future<void> deleteDownload(int lessonId) async {
    await _dio.delete('/student/downloads/$lessonId');
  }

  // ===== Affiliation =====

  @override
  Future<List<InstitutionTypeModel>> getInstitutionTypes() async {
    final res = await _dio.get('/student/affiliation/institution-types');
    return _asList(
      res.data['data'],
    ).map(InstitutionTypeModel.fromJson).toList();
  }

  @override
  Future<List<InstitutionModel>> getInstitutions(String type) async {
    final res = await _dio.get(
      '/student/institutions',
      queryParameters: {'type': type},
    );
    return _asList(res.data['data']).map(InstitutionModel.fromJson).toList();
  }

  @override
  Future<List<AcademicLevelModel>> getLevels(int institutionId) async {
    final res = await _dio.get('/student/institutions/$institutionId/levels');
    return _asList(res.data['data']).map(AcademicLevelModel.fromJson).toList();
  }

  @override
  Future<List<SpecializationModel>> getSpecializations(int levelId) async {
    final res = await _dio.get('/student/levels/$levelId/specializations');
    return _asList(res.data['data']).map(SpecializationModel.fromJson).toList();
  }

  @override
  Future<AffiliationStatusModel?> getAffiliationStatus() async {
    final res = await _dio.get('/student/affiliation/status');
    final data = res.data['data'];
    if (data is Map && data['status'] != null) {
      return AffiliationStatusModel.fromJson(data.cast<String, dynamic>());
    }
    return null; // no request submitted yet
  }

  @override
  Future<void> submitAffiliation({
    required String institutionType,
    required int institutionId,
    required int academicLevelId,
    required int specializationId,
  }) async {
    await _dio.post(
      '/student/affiliation/requests',
      data: {
        'institution_type': institutionType,
        'institution_id': institutionId,
        'academic_level_id': academicLevelId,
        'specialization_id': specializationId,
      },
    );
  }
}
