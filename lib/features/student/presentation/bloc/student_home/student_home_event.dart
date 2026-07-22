import 'package:equatable/equatable.dart';

abstract class StudentHomeEvent extends Equatable {
  const StudentHomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeDataEvent extends StudentHomeEvent {}

class ToggleFavoriteEvent extends StudentHomeEvent {
  final int lessonId;
  const ToggleFavoriteEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}
