import 'package:equatable/equatable.dart';

import '../../../domain/entities/admin_content_entity.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<AdminContentEntity> content;
  const ContentLoaded({required this.content});

  @override
  List<Object?> get props => [content];
}

class ContentError extends ContentState {
  final String message;
  const ContentError({required this.message});

  @override
  List<Object?> get props => [message];
}
