import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/search_repository.dart';

class SearchState extends Equatable {
  final String query;
  final List<LessonEntity> results;
  final List<String> recent;
  final bool loading;
  final bool searched; // a search has been run at least once
  final String? error;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.recent = const [],
    this.loading = false,
    this.searched = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<LessonEntity>? results,
    List<String>? recent,
    bool? loading,
    bool? searched,
    String? error,
    bool clearError = false,
  }) {
    return SearchState(
      query: query ?? this.query,
      results: results ?? this.results,
      recent: recent ?? this.recent,
      loading: loading ?? this.loading,
      searched: searched ?? this.searched,
      error: clearError ? null : (error ?? this.error),
    );
  }

  @override
  List<Object?> get props => [query, results, recent, loading, searched, error];
}

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;

  SearchCubit(this.repository) : super(const SearchState());

  Future<void> loadRecent() async {
    final result = await repository.getRecentSearches();
    result.fold((_) {}, (recent) => emit(state.copyWith(recent: recent)));
  }

  Future<void> search(String query) async {
    final q = query.trim();
    if (q.length < 2) return; // backend requires at least 2 characters
    emit(
      state.copyWith(query: q, loading: true, searched: true, clearError: true),
    );
    final result = await repository.search(q);
    result.fold(
      (f) => emit(
        state.copyWith(loading: false, error: f.message, results: const []),
      ),
      (results) => emit(state.copyWith(loading: false, results: results)),
    );
  }
}
