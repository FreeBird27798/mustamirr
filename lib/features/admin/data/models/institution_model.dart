import '../../domain/entities/institution_entity.dart';

class InstitutionModel extends InstitutionEntity {
  const InstitutionModel({
    required super.id,
    required super.type,
    required super.name,
    required super.subtitle,
  });

  factory InstitutionModel.fromJson(Map<String, dynamic> json) {
    return InstitutionModel(
      id: json['id'] as int,
      type: json['type'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'name': name, 'subtitle': subtitle};
  }
}
