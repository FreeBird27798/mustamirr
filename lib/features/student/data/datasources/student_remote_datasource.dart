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
  static const _delay = Duration(milliseconds: 600);

  LessonModel _mockLesson({
    required int id,
    required String title,
    required String subjectName,
    String teacherName = 'أ. محمد سالم',
    String fileType = 'pdf',
    double rating = 4.0,
    int pageCount = 10,
    String date = '2026-06-01',
    bool isFavorite = false,
    bool isDownloaded = false,
    String description = 'وصف الدرس',
    String fileUrl = 'https://example.com/file.pdf',
  }) {
    return LessonModel(
      id: id,
      title: title,
      teacherName: teacherName,
      subjectName: subjectName,
      fileType: fileType,
      rating: rating,
      pageCount: pageCount,
      date: date,
      isFavorite: isFavorite,
      isDownloaded: isDownloaded,
      description: description,
      fileUrl: fileUrl,
    );
  }

  late final List<LessonModel> _lessons;
  final List<SubjectModel> _subjects = [
    const SubjectModel(id: 1, name: 'رياضيات', lessonCount: 2),
    const SubjectModel(id: 2, name: 'علوم', lessonCount: 1),
    const SubjectModel(id: 3, name: 'لغة عربية', lessonCount: 2),
    const SubjectModel(id: 4, name: 'لغة إنجليزية', lessonCount: 1),
  ];

  StudentRemoteDataSourceImpl() {
    _lessons = [
      _mockLesson(
        id: 1,
        subjectName: 'رياضيات',
        title: 'مقدمة في التفاضل والتكامل',
        isFavorite: false,
        isDownloaded: true,
      ),
      _mockLesson(
        id: 2,
        subjectName: 'رياضيات',
        title: 'الجبر الخطي',
        fileType: 'video',
        isFavorite: true,
      ),
      _mockLesson(
        id: 3,
        subjectName: 'علوم',
        title: 'مقدمة في الفيزياء',
        fileType: 'word',
        isFavorite: false,
      ),
      _mockLesson(
        id: 4,
        subjectName: 'لغة عربية',
        title: 'النحو والصرف',
        isFavorite: true,
        isDownloaded: true,
      ),
      _mockLesson(
        id: 5,
        subjectName: 'لغة عربية',
        title: 'الأدب العربي',
        fileType: 'doc',
        isFavorite: false,
      ),
      _mockLesson(
        id: 6,
        subjectName: 'لغة إنجليزية',
        title: 'قواعد اللغة الإنجليزية',
        isFavorite: false,
        isDownloaded: true,
      ),
    ];
  }

  final List<NotificationModel> _notifications = [
    const NotificationModel(
      id: 1,
      title: 'درس جديد متاح',
      body: 'تم إضافة درس جديد في مادة الرياضيات.',
      type: 'info',
      isRead: false,
      createdAt: '2026-06-01T10:00:00Z',
    ),
    const NotificationModel(
      id: 2,
      title: 'تحديث في الدرس',
      body: 'تم تحديث محتوى درس الجبر الخطي.',
      type: 'update',
      isRead: true,
      createdAt: '2026-06-02T12:30:00Z',
    ),
    const NotificationModel(
      id: 3,
      title: 'تنبيه مهم',
      body: 'يرجى مراجعة الدرس الأخير قبل الامتحان.',
      type: 'alert',
      isRead: false,
      createdAt: '2026-06-03T15:45:00Z',
    ),
  ];

  @override
  Future<List<SubjectModel>> getSubjects() async {
    await Future.delayed(_delay);
    return _subjects;
  }

  @override
  Future<List<LessonModel>> getRecentLessons() async {
    await Future.delayed(_delay);
    // TODO: Return the most recent lessons based on date or other criteria
    return _lessons.take(5).toList();
  }

  @override
  Future<List<LessonModel>> getLessons(int subjectId) async {
    await Future.delayed(_delay);
    final subjectName = _subjects.firstWhere((s) => s.id == subjectId).name;
    return _lessons
        .where((lesson) => lesson.subjectName == subjectName)
        .toList();
  }

  @override
  Future<List<LessonModel>> getFavorites() async {
    await Future.delayed(_delay);
    return _lessons.where((lesson) => lesson.isFavorite).toList();
  }

  @override
  Future<List<LessonModel>> getDownloads() async {
    await Future.delayed(_delay);
    return _lessons.where((lesson) => lesson.isDownloaded).toList();
  }

  @override
  Future<List<NotificationModel>> getNotifications() async {
    await Future.delayed(_delay);
    return _notifications;
  }

  @override
  Future<void> toggleFavorite(int lessonId) async {
    await Future.delayed(_delay);
    final index = _lessons.indexWhere((lesson) => lesson.id == lessonId);
    if (index == -1) {
      throw Exception('Lesson with id $lessonId not found');
    }
    _lessons[index] = _lessons[index].copyWith(
      isFavorite: !_lessons[index].isFavorite,
    );
  }

  @override
  Future<void> downloadLesson(int lessonId) async {
    await Future.delayed(_delay);
    final index = _lessons.indexWhere((lesson) => lesson.id == lessonId);
    if (index == -1) {
      throw Exception('Lesson with id $lessonId not found');
    }
    _lessons[index] = _lessons[index].copyWith(isDownloaded: true);
  }

  @override
  Future<void> deleteDownload(int lessonId) async {
    await Future.delayed(_delay);
    final index = _lessons.indexWhere((lesson) => lesson.id == lessonId);
    if (index == -1) {
      throw Exception('Lesson with id $lessonId not found');
    }
    _lessons[index] = _lessons[index].copyWith(isDownloaded: false);
  }
}
