import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class LoadContentEvent extends ContentEvent {}

class DeleteContentEvent extends ContentEvent {
  final int contentId;
  const DeleteContentEvent({required this.contentId});

  @override
  List<Object?> get props => [contentId];
}
