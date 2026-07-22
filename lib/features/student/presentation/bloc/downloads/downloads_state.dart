import 'package:equatable/equatable.dart';

import '../../../domain/entities/lesson_entity.dart';

abstract class DownloadsState extends Equatable {
  const DownloadsState();

  @override
  List<Object?> get props => [];
}

class DownloadsInitial extends DownloadsState {}

class DownloadsLoading extends DownloadsState {}

class DownloadsLoaded extends DownloadsState {
  final List<LessonEntity> downloads;

  const DownloadsLoaded({required this.downloads});

  @override
  List<Object?> get props => [downloads];
}

class DownloadsError extends DownloadsState {
  final String message;

  const DownloadsError({required this.message});

  @override
  List<Object?> get props => [message];
}
