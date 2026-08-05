import 'package:equatable/equatable.dart';

class TeacherStatsEntity extends Equatable {
  final int studentsCount;
  final int lessonsCount;
  final int coursesCount;
  final int downloadsCount;

  const TeacherStatsEntity({
    required this.studentsCount,
    required this.lessonsCount,
    required this.coursesCount,
    required this.downloadsCount,
  });

  @override
  List<Object?> get props => [
    studentsCount,
    lessonsCount,
    coursesCount,
    downloadsCount,
  ];
}
