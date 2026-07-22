import 'package:equatable/equatable.dart';

abstract class SubjectsEvent extends Equatable {
  const SubjectsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSubjectsEvent extends SubjectsEvent {}
