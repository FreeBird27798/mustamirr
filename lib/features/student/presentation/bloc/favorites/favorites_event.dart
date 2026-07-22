import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {}

class LoadFavoritesEvent extends FavoritesEvent {
  @override
  List<Object> get props => [];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int lessonId;

  RemoveFavoriteEvent({required this.lessonId});

  @override
  List<Object> get props => [lessonId];
}
