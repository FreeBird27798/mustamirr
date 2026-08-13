import 'package:equatable/equatable.dart';

/// A lesson shown in the admin "content management" screen.
class AdminContentEntity extends Equatable {
  final int id;
  final String title;
  final String subject;
  final String teacherName;
  final String fileType; // pdf, video, word, doc
  final int downloadsCount;

  const AdminContentEntity({
    required this.id,
    required this.title,
    required this.subject,
    required this.teacherName,
    required this.fileType,
    required this.downloadsCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subject,
    teacherName,
    fileType,
    downloadsCount,
  ];
}
