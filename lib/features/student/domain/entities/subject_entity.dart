import 'package:equatable/equatable.dart';

class SubjectEntity extends Equatable {
  final int id;
  final String name;
  final int lessonCount;

  const SubjectEntity({
    required this.id,
    required this.name,
    required this.lessonCount,
  });

  @override
  List<Object?> get props => [id, name, lessonCount];
}
