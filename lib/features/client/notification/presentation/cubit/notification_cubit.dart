import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

part 'notification_state.dart';
part 'notification_cubit.freezed.dart';

@injectable
class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _repository;

  NotificationCubit(this._repository)
    : super(const NotificationState.initial());

  Future<void> loadNotifications() async {
    emit(const NotificationState.loading());
    final result = await _repository.getNotifications();
    result.fold(
      (err) => emit(NotificationState.error(err.message)),
      (notifications) => emit(NotificationState.loaded(notifications)),
    );
  }

  Future<void> markAsRead(String id) async {
    final currentState = state;
    if (currentState is _Loaded) {
      final updatedList = currentState.notifications.map((n) {
        if (n.id == id) {
          return NotificationModel(
            id: n.id,
            userId: n.userId,
            title: n.title,
            body: n.body,
            isRead: true,
            createdAt: n.createdAt,
            data: n.data,
          );
        }
        return n;
      }).toList();
      emit(NotificationState.loaded(updatedList));

      final result = await _repository.markAsRead(id);
      result.fold((err) {
        // Fallback en cas d'erreur de réseau (facultatif car l'optimistic UI est plus fluide)
      }, (_) {});
    }
  }

  Future<void> delete(String id) async {
    final currentState = state;
    if (currentState is _Loaded) {
      final updatedList = currentState.notifications
          .where((n) => n.id != id)
          .toList();
      emit(NotificationState.loaded(updatedList));

      final result = await _repository.deleteNotification(id);
      result.fold((err) {
        // Fallback en cas d'erreur
      }, (_) {});
    }
  }
}
