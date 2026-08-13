import '../models/lesson_content_model.dart';
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
  static const _delay = Duration(milliseconds: 600);

  TeacherLessonModel _mockLesson({
    required int id,
    required String title,
    required String subject,
    String description = 'وصف مختصر للدرس.',
    String grade = 'الصف الثالث الثانوي',
    String fileType = 'pdf',
    double fileSizeMb = 2.0,
  }) {
    return TeacherLessonModel(
      id: id,
      title: title,
      description: description,
      subject: subject,
      grade: grade,
      fileType: fileType,
      fileSizeMb: fileSizeMb,
      contents: const [
        LessonContentModel(title: 'المفهوم الأساسي', body: 'شرح المفهوم.'),
      ],
    );
  }

  late final List<TeacherLessonModel> _lessons;

  final List<TeacherStudentModel> _students = const [
    TeacherStudentModel(id: 1, name: 'محمد خالد حسن', grade: 'الصف الثالث عشر'),
    TeacherStudentModel(id: 2, name: 'عادل رضوان', grade: 'الصف الثالث عشر'),
    TeacherStudentModel(id: 3, name: 'سعدي حرب', grade: 'الصف الثالث عشر'),
    TeacherStudentModel(id: 4, name: 'حسن عثمان', grade: 'الصف الثالث عشر'),
  ];

  TeacherRemoteDataSourceImpl() {
    _lessons = [
      _mockLesson(
        id: 1,
        title: 'مقدمة في أخلاقيات المهنية',
        subject: 'أخلاقيات المهنة',
        fileType: 'pdf',
        fileSizeMb: 2.0,
      ),
      _mockLesson(
        id: 2,
        title: 'اللياقة القلبية',
        subject: 'اللياقة البدنية',
        fileType: 'video',
        fileSizeMb: 6.0,
      ),
      _mockLesson(
        id: 3,
        title: 'مفاهيم الأمن الأساسية',
        subject: 'أمن المعلومات',
        fileType: 'pdf',
        fileSizeMb: 2.0,
      ),
      _mockLesson(
        id: 4,
        title: 'أمان معدوم',
        subject: 'أمن المعلومات',
        fileType: 'video',
        fileSizeMb: 2.0,
      ),
    ];
  }

  @override
  Future<TeacherStatsModel> getDashboardStats() async {
    await Future.delayed(_delay);
    return TeacherStatsModel(
      studentsCount: _students.length * 36, // mock: 143-ish
      lessonsCount: _lessons.length * 7, // mock: 28-ish
      coursesCount: 2,
      downloadsCount: 1100,
    );
  }

  @override
  Future<List<TeacherLessonModel>> getMyLessons() async {
    await Future.delayed(_delay);
    return _lessons.toList(); // fresh copy so BLoC states compare as changed
  }

  @override
  Future<List<TeacherStudentModel>> getMyStudents() async {
    await Future.delayed(_delay);
    return _students.toList();
  }

  @override
  Future<void> addLesson(TeacherLessonModel lesson) async {
    await Future.delayed(_delay);
    final nextId = _lessons.isEmpty
        ? 1
        : _lessons.map((l) => l.id).reduce((a, b) => a > b ? a : b) + 1;
    _lessons.insert(
      0,
      TeacherLessonModel(
        id: nextId,
        title: lesson.title,
        description: lesson.description,
        subject: lesson.subject,
        grade: lesson.grade,
        fileType: lesson.fileType,
        fileSizeMb: lesson.fileSizeMb,
        contents: lesson.contents
            .map((e) => LessonContentModel(title: e.title, body: e.body))
            .toList(),
      ),
    );
  }

  @override
  Future<void> updateLesson(TeacherLessonModel lesson) async {
    await Future.delayed(_delay);
    final index = _lessons.indexWhere((l) => l.id == lesson.id);
    if (index == -1) {
      throw Exception('Lesson with id ${lesson.id} not found');
    }
    _lessons[index] = lesson;
  }

  @override
  Future<void> deleteLesson(int lessonId) async {
    await Future.delayed(_delay);
    _lessons.removeWhere((l) => l.id == lessonId);
  }
}
