import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../../domain/usecases/mark_all_read_usecase.dart';

/// Holds the count of unread notifications so the header bell can show a red
/// dot only when there's something new. State is just the unread count.
class NotificationBadgeCubit extends Cubit<int> {
  final GetUnreadCountUseCase getUnreadCountUseCase;
  final MarkAllReadUseCase markAllReadUseCase;

  NotificationBadgeCubit({
    required this.getUnreadCountUseCase,
    required this.markAllReadUseCase,
  }) : super(0);

  Future<void> load() async {
    final result = await getUnreadCountUseCase(NoParams());
    result.fold((_) {}, emit); // keep previous count on failure
  }

  /// Called when the user opens the notifications screen: clears the dot
  /// immediately, then tells the backend everything has been read.
  Future<void> markAllRead() async {
    emit(0);
    await markAllReadUseCase(NoParams());
  }
}
