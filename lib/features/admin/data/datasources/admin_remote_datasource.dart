import '../models/admin_content_model.dart';
import '../models/admin_stats_model.dart';
import '../models/admin_subject_model.dart';
import '../models/admin_user_model.dart';
import '../models/enrollment_request_model.dart';
import '../models/institution_model.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStatsModel> getStats();
  Future<List<AdminUserModel>> getUsers();
  Future<void> toggleUserActive(int userId);
  Future<void> deleteUser(int userId);
  Future<List<EnrollmentRequestModel>> getEnrollmentRequests();
  Future<void> approveRequest(int requestId);
  Future<void> rejectRequest(int requestId);
  Future<List<InstitutionModel>> getInstitutions(String type);
  Future<void> addInstitution(InstitutionModel institution);
  Future<void> deleteInstitution(int institutionId);
  Future<List<AdminSubjectModel>> getSubjects();
  Future<void> addSubject(AdminSubjectModel subject);
  Future<void> deleteSubject(int subjectId);
  Future<List<AdminContentModel>> getContent();
  Future<void> deleteContent(int contentId);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  static const _delay = Duration(milliseconds: 600);

  final List<AdminUserModel> _users = [
    const AdminUserModel(
      id: 1,
      name: 'ندى الزهراني',
      email: 'nada@school.edu',
      role: 'student',
      isActive: true,
      affiliation: 'مدرسة النور - الصف الأول الثانوي',
    ),
    const AdminUserModel(
      id: 2,
      name: 'يوسف أحمد',
      email: 'yousef@school.edu',
      role: 'student',
      isActive: false,
      affiliation: 'جامعة - تخصص تصميم وبرمجة تطبيقات الموبايل',
    ),
    const AdminUserModel(
      id: 3,
      name: 'كريم منير',
      email: 'kareem@school.edu',
      role: 'student',
      isActive: false,
      affiliation: 'جامعة - تخصص تصميم وبرمجة تطبيقات الموبايل',
    ),
    const AdminUserModel(
      id: 4,
      name: 'أحمد العلي',
      email: 'ahmad@school.edu',
      role: 'teacher',
      isActive: true,
      affiliation: 'مدرسة النور - الرياضيات',
    ),
    const AdminUserModel(
      id: 5,
      name: 'محمد الحسن',
      email: 'mohammad@school.edu',
      role: 'teacher',
      isActive: true,
      affiliation: 'مدرسة الرواد - الكيمياء',
    ),
    const AdminUserModel(
      id: 6,
      name: 'ليلى أنور',
      email: 'laila@school.edu',
      role: 'teacher',
      isActive: false,
      affiliation: 'ثانوية الفيصل - الأحياء',
    ),
  ];

  @override
  Future<AdminStatsModel> getStats() async {
    await Future.delayed(_delay);
    return const AdminStatsModel(
      studentsCount: 143,
      subjectsCount: 28,
      teachersCount: 78,
      filesCount: 1100,
    );
  }

  @override
  Future<List<AdminUserModel>> getUsers() async {
    await Future.delayed(_delay);
    return _users.toList(); // fresh copy so BLoC states compare as changed
  }

  @override
  Future<void> toggleUserActive(int userId) async {
    await Future.delayed(_delay);
    final index = _users.indexWhere((u) => u.id == userId);
    if (index == -1) {
      throw Exception('User with id $userId not found');
    }
    _users[index] = _users[index].copyWith(isActive: !_users[index].isActive);
  }

  @override
  Future<void> deleteUser(int userId) async {
    await Future.delayed(_delay);
    _users.removeWhere((u) => u.id == userId);
  }

  final List<EnrollmentRequestModel> _requests = [
    const EnrollmentRequestModel(
      id: 1,
      name: 'مساء حسن الحسن',
      role: 'student',
      affiliation: 'مدرسة النور الأهلية - الصف الثالث الثانوي',
      status: 'pending',
      createdAt: 'الآن',
    ),
    const EnrollmentRequestModel(
      id: 2,
      name: 'نورة الزهراني',
      role: 'student',
      affiliation: 'جامعة الملك سعود - بكالوريوس - علوم الحاسب',
      status: 'approved',
      createdAt: 'اليوم 09:12',
    ),
    const EnrollmentRequestModel(
      id: 3,
      name: 'أحمد الغامدي',
      role: 'teacher',
      affiliation: 'مدرسة الرواد الدولية - الرياضيات',
      status: 'pending',
      createdAt: 'أمس',
    ),
  ];

  @override
  Future<List<EnrollmentRequestModel>> getEnrollmentRequests() async {
    await Future.delayed(_delay);
    return _requests.toList(); // fresh copy so BLoC states compare as changed
  }

  @override
  Future<void> approveRequest(int requestId) async {
    await Future.delayed(_delay);
    final index = _requests.indexWhere((r) => r.id == requestId);
    if (index == -1) {
      throw Exception('Request with id $requestId not found');
    }
    _requests[index] = _requests[index].copyWith(status: 'approved');
  }

  @override
  Future<void> rejectRequest(int requestId) async {
    await Future.delayed(_delay);
    _requests.removeWhere((r) => r.id == requestId);
  }

  // ===== Institutions =====
  final List<InstitutionModel> _institutions = [
    const InstitutionModel(id: 1, type: 'university', name: 'جامعة الملك سعود', subtitle: 'الرياض'),
    const InstitutionModel(id: 2, type: 'university', name: 'جامعة الملك عبدالعزيز', subtitle: 'جدة'),
    const InstitutionModel(id: 3, type: 'school', name: 'مدرسة النور الأهلية', subtitle: 'الرياض'),
    const InstitutionModel(id: 4, type: 'school', name: 'مدرسة الرواد الدولية', subtitle: 'جدة'),
    const InstitutionModel(id: 5, type: 'specialization', name: 'علوم الحاسب', subtitle: 'جامعة الملك سعود - بكالوريوس'),
    const InstitutionModel(id: 6, type: 'specialization', name: 'هندسة البرمجيات', subtitle: 'جامعة الملك سعود - بكالوريوس'),
    const InstitutionModel(id: 7, type: 'grade', name: 'الصف الأول الثانوي', subtitle: 'مدرسة النور الأهلية'),
    const InstitutionModel(id: 8, type: 'grade', name: 'الصف الثاني الثانوي', subtitle: 'مدرسة الرواد الدولية'),
  ];
  int _nextInstitutionId = 9;

  @override
  Future<List<InstitutionModel>> getInstitutions(String type) async {
    await Future.delayed(_delay);
    return _institutions.where((i) => i.type == type).toList();
  }

  @override
  Future<void> addInstitution(InstitutionModel institution) async {
    await Future.delayed(_delay);
    _institutions.add(
      InstitutionModel(
        id: _nextInstitutionId++,
        type: institution.type,
        name: institution.name,
        subtitle: institution.subtitle,
      ),
    );
  }

  @override
  Future<void> deleteInstitution(int institutionId) async {
    await Future.delayed(_delay);
    _institutions.removeWhere((i) => i.id == institutionId);
  }

  // ===== Subjects =====
  final List<AdminSubjectModel> _subjects = [
    const AdminSubjectModel(id: 1, name: 'الرياضيات', grade: 'الصف الثالث الثانوي', lessonsCount: 24),
    const AdminSubjectModel(id: 2, name: 'الفيزياء', grade: 'الصف الثالث الثانوي', lessonsCount: 18),
    const AdminSubjectModel(id: 3, name: 'الكيمياء', grade: 'الصف الثاني الثانوي', lessonsCount: 16),
    const AdminSubjectModel(id: 4, name: 'اللغة العربية', grade: 'كل الصفوف', lessonsCount: 30),
  ];
  int _nextSubjectId = 5;

  @override
  Future<List<AdminSubjectModel>> getSubjects() async {
    await Future.delayed(_delay);
    return _subjects.toList();
  }

  @override
  Future<void> addSubject(AdminSubjectModel subject) async {
    await Future.delayed(_delay);
    _subjects.add(
      AdminSubjectModel(
        id: _nextSubjectId++,
        name: subject.name,
        grade: subject.grade,
        lessonsCount: 0,
      ),
    );
  }

  @override
  Future<void> deleteSubject(int subjectId) async {
    await Future.delayed(_delay);
    _subjects.removeWhere((s) => s.id == subjectId);
  }

  // ===== Content =====
  final List<AdminContentModel> _content = [
    const AdminContentModel(id: 1, title: 'مقدمة في الدوال والمتباينات', subject: 'الرياضيات', teacherName: 'أ. أحمد العلي', fileType: 'pdf', downloadsCount: 100),
    const AdminContentModel(id: 2, title: 'التفاعلات الكيميائية والاتزان', subject: 'الكيمياء', teacherName: 'أ. محمد الحسن', fileType: 'video', downloadsCount: 40),
    const AdminContentModel(id: 3, title: 'علم الوراثة والصفات', subject: 'الأحياء', teacherName: 'أ. ليلى أنور', fileType: 'pdf', downloadsCount: 100),
    const AdminContentModel(id: 4, title: 'البلاغة: التشبيه والاستعارة', subject: 'اللغة العربية', teacherName: 'أ. أحمد العلي', fileType: 'video', downloadsCount: 40),
  ];

  @override
  Future<List<AdminContentModel>> getContent() async {
    await Future.delayed(_delay);
    return _content.toList();
  }

  @override
  Future<void> deleteContent(int contentId) async {
    await Future.delayed(_delay);
    _content.removeWhere((c) => c.id == contentId);
  }
}
