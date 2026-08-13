import 'package:equatable/equatable.dart';

class AdminStatsEntity extends Equatable {
  final int studentsCount;
  final int subjectsCount;
  final int teachersCount;
  final int filesCount;

  const AdminStatsEntity({
    required this.studentsCount,
    required this.subjectsCount,
    required this.teachersCount,
    required this.filesCount,
  });

  @override
  List<Object?> get props => [
    studentsCount,
    subjectsCount,
    teachersCount,
    filesCount,
  ];
}
