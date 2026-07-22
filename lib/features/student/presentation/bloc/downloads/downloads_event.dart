import 'package:equatable/equatable.dart';

abstract class DownloadsEvent extends Equatable {
  const DownloadsEvent();
}

class LoadDownloadsEvent extends DownloadsEvent {
  @override
  List<Object?> get props => [];
}

class DeleteDownloadEvent extends DownloadsEvent {
  final int lessonId;

  const DeleteDownloadEvent({required this.lessonId});

  @override
  List<Object?> get props => [lessonId];
}
