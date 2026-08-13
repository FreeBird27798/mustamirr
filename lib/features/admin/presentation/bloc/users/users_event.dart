import 'package:equatable/equatable.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class LoadUsersEvent extends UsersEvent {}

class ToggleUserActiveEvent extends UsersEvent {
  final int userId;
  const ToggleUserActiveEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class DeleteUserEvent extends UsersEvent {
  final int userId;
  const DeleteUserEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
