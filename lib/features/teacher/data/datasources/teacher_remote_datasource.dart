import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../student/data/models/affiliation_models.dart';
import '../../../student/data/models/lesson_model.dart';
import '../models/teacher_affiliation_models.dart';
import '../models/teacher_lesson_model.dart';
import '../models/teacher_stats_model.dart';
import '../models/teacher_student_model.dart';

abstract class TeacherRemoteDataSource {
  Future<TeacherStatsModel> getDashboardStats();
  Future<List<TeacherLessonModel>> getMyLessons();
  Future<List<TeacherStudentModel>> getMyStudents();
  Future<void> addLesson(TeacherLessonModel lesson);
  Future<void> updateLesson(TeacherLessonModel lesson);
  Future<void> deleteLesson(int lessonId);

  // ===== Affiliation (institution selection) — shared shape with student =====
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

  // ===== Teacher-specific affiliation (multi-select levels + subjects) =====
  Future<List<SubjectOptionModel>> getSubjectOptions();
  Future<TeacherAffiliationStatusModel?> getTeacherAffiliationStatus();
  Future<void> submitTeacherAffiliation({
    required String institutionType,
    required int institutionId,
    required List<int> academicLevelIds,
    required List<int> subjectIds,
    required int specializationId,
  });

  // ===== Search =====
  Future<List<LessonModel>> search(String query);
  Future<List<String>> getRecentSearches();
}

class TeacherRemoteDataSourceImpl implements TeacherRemoteDataSource {
  final ApiClient apiClient;

  TeacherRemoteDataSourceImpl({required this.apiClient});

  Dio get _dio => apiClient.dio;

  List<Map<String, dynamic>> _asList(dynamic data) {
    return (data as List)
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  @override
  Future<TeacherStatsModel> getDashboardStats() async {
    final res = await _dio.get('/teacher/dashboard');
    final stats = (res.data['data']['stats'] as Map).cast<String, dynamic>();
    return TeacherStatsModel.fromJson(stats);
  }

  @override
  Future<List<TeacherLessonModel>> getMyLessons() async {
    final res = await _dio.get('/teacher/lessons');
    return _asList(res.data['data']).map(TeacherLessonModel.fromJson).toList();
  }

  @override
  Future<List<TeacherStudentModel>> getMyStudents() async {
    final res = await _dio.get('/teacher/students');
    return _asList(res.data['data']).map(TeacherStudentModel.fromJson).toList();
  }

  @override
  Future<void> addLesson(TeacherLessonModel lesson) async {
    // Publishing a lesson is a multipart upload (`POST /teacher/lessons` with a
    // `file` field). Wiring it depends on the backend's file mechanism, which
    // is still pending — blocked for now.
    throw const ServerException('رفع الدروس قيد التطوير — قريبًا.');
  }

  @override
  Future<void> updateLesson(TeacherLessonModel lesson) async {
    throw const ServerException('تعديل الدروس قيد التطوير — قريبًا.');
  }

  @override
  Future<void> deleteLesson(int lessonId) async {
    await _dio.delete('/teacher/lessons/$lessonId');
  }

  // ===== Affiliation =====

  @override
  Future<List<InstitutionTypeModel>> getInstitutionTypes() async {
    final res = await _dio.get('/teacher/affiliation/institution-types');
    return _asList(
      res.data['data'],
    ).map(InstitutionTypeModel.fromJson).toList();
  }

  @override
  Future<List<InstitutionModel>> getInstitutions(String type) async {
    final res = await _dio.get(
      '/teacher/institutions',
      queryParameters: {'type': type},
    );
    return _asList(res.data['data']).map(InstitutionModel.fromJson).toList();
  }

  @override
  Future<List<AcademicLevelModel>> getLevels(int institutionId) async {
    final res = await _dio.get('/teacher/institutions/$institutionId/levels');
    return _asList(res.data['data']).map(AcademicLevelModel.fromJson).toList();
  }

  @override
  Future<List<SpecializationModel>> getSpecializations(int levelId) async {
    final res = await _dio.get('/teacher/levels/$levelId/specializations');
    return _asList(res.data['data']).map(SpecializationModel.fromJson).toList();
  }

  @override
  Future<AffiliationStatusModel?> getAffiliationStatus() async {
    final res = await _dio.get('/teacher/affiliation/status');
    final data = res.data['data'];
    if (data is Map && data['status'] != null) {
      return AffiliationStatusModel.fromJson(data.cast<String, dynamic>());
    }
    return null;
  }

  @override
  Future<void> submitAffiliation({
    required String institutionType,
    required int institutionId,
    required int academicLevelId,
    required int specializationId,
  }) async {
    await _dio.post(
      '/teacher/affiliation/requests',
      data: {
        'institution_type': institutionType,
        'institution_id': institutionId,
        'academic_level_id': academicLevelId,
        'specialization_id': specializationId,
      },
    );
  }

  // ===== Teacher-specific affiliation =====

  @override
  Future<List<SubjectOptionModel>> getSubjectOptions() async {
    final res = await _dio.get('/teacher/subjects');
    return _asList(res.data['data']).map(SubjectOptionModel.fromJson).toList();
  }

  @override
  Future<TeacherAffiliationStatusModel?> getTeacherAffiliationStatus() async {
    final res = await _dio.get('/teacher/affiliation/status');
    final data = res.data['data'];
    if (data is Map && data['status'] != null) {
      return TeacherAffiliationStatusModel.fromJson(
        data.cast<String, dynamic>(),
      );
    }
    return null;
  }

  @override
  Future<void> submitTeacherAffiliation({
    required String institutionType,
    required int institutionId,
    required List<int> academicLevelIds,
    required List<int> subjectIds,
    required int specializationId,
  }) async {
    await _dio.post(
      '/teacher/affiliation/requests',
      data: {
        'institution_type': institutionType,
        'institution_id': institutionId,
        'academic_level_ids': academicLevelIds,
        'subject_ids': subjectIds,
        'specialization_id': specializationId,
      },
    );
  }

  // ===== Search =====

  @override
  Future<List<LessonModel>> search(String query) async {
    final res = await _dio.get(
      '/teacher/search',
      queryParameters: {'q': query},
    );
    return _asList(res.data['data']).map(LessonModel.fromJson).toList();
  }

  @override
  Future<List<String>> getRecentSearches() async {
    final res = await _dio.get('/teacher/search/recent');
    return _asList(res.data['data'])
        .map((e) => (e['term'] ?? '') as String)
        .where((t) => t.isNotEmpty)
        .toList();
  }
}
