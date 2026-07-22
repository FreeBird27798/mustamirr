import 'package:equatable/equatable.dart';

class LessonEntity extends Equatable {
  final int id;
  final String title;
  final String teacherName;
  final String subjectName;
  final String fileType;
  final double rating;
  final int pageCount;
  final String date;
  final bool isFavorite;
  final bool isDownloaded;
  final String description;
  final String fileUrl;

  const LessonEntity({
    required this.id,
    required this.title,
    required this.teacherName,
    required this.subjectName,
    required this.fileType,
    required this.rating,
    required this.pageCount,
    required this.date,
    required this.isFavorite,
    required this.isDownloaded,
    required this.description,
    required this.fileUrl,
  });
  @override
  List<Object?> get props => [id, title, fileType, isFavorite, isDownloaded];
}
