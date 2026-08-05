import 'package:equatable/equatable.dart';

/// A single content section inside a lesson (e.g. "المفهوم الأساسي", "تمارين").
class LessonContentEntity extends Equatable {
  final String title;
  final String body;

  const LessonContentEntity({required this.title, required this.body});

  @override
  List<Object?> get props => [title, body];
}
