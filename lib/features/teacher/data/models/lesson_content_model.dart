import '../../domain/entities/lesson_content_entity.dart';

class LessonContentModel extends LessonContentEntity {
  const LessonContentModel({required super.title, required super.body});

  factory LessonContentModel.fromJson(Map<String, dynamic> json) {
    return LessonContentModel(
      title: (json['title'] ?? '') as String,
      body: (json['body'] ?? json['content'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'body': body};
  }

  factory LessonContentModel.fromEntity(LessonContentEntity entity) {
    return LessonContentModel(title: entity.title, body: entity.body);
  }
}
