import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
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
  Future<void> toggleFavorite(int lessonId);
  Future<void> downloadLesson(int lessonId);
  Future<void> deleteDownload(int lessonId);
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
    return _asList(res.data['data']['items']).map(LessonModel.fromJson).toList();
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final res = await _dio.get('/notifications');
    return _asList(res.data['data']).map(NotificationModel.fromJson).toList();
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
}
