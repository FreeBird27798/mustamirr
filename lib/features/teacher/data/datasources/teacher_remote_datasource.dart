import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/errors/exceptions.dart';
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
}
