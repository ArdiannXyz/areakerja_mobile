import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/notifikasi_model.dart';
import '../../data/repositories/notifikasi_repository_impl.dart';

// EVENTS
abstract class NotifikasiEvent extends Equatable {
  const NotifikasiEvent();
  @override
  List<Object?> get props => [];
}

class FetchNotifikasiEvent extends NotifikasiEvent {
  const FetchNotifikasiEvent();
}

class MarkNotifikasiReadEvent extends NotifikasiEvent {
  final String id;
  const MarkNotifikasiReadEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class MarkAllNotifikasiReadEvent extends NotifikasiEvent {
  const MarkAllNotifikasiReadEvent();
}

// STATES
abstract class NotifikasiState extends Equatable {
  const NotifikasiState();
  @override
  List<Object?> get props => [];
}

class NotifikasiInitial extends NotifikasiState {}

class NotifikasiLoading extends NotifikasiState {}

class NotifikasiLoaded extends NotifikasiState {
  final List<NotifikasiModel> notifications;
  final int unreadCount;

  const NotifikasiLoaded({
    required this.notifications,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotifikasiErrorState extends NotifikasiState {
  final String message;
  const NotifikasiErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// BLOC
class NotifikasiBloc extends Bloc<NotifikasiEvent, NotifikasiState> {
  final NotifikasiRepository _repository;

  NotifikasiBloc({required NotifikasiRepository repository})
      : _repository = repository,
        super(NotifikasiInitial()) {
    on<FetchNotifikasiEvent>(_onFetchNotifikasi);
    on<MarkNotifikasiReadEvent>(_onMarkNotifikasiRead);
    on<MarkAllNotifikasiReadEvent>(_onMarkAllNotifikasiRead);
  }

  Future<void> _onFetchNotifikasi(
    FetchNotifikasiEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    emit(NotifikasiLoading());
    final result = await _repository.getNotifikasiList();

    result.fold(
      (failure) => emit(NotifikasiErrorState(failure.message)),
      (list) {
        final unread = list.where((n) => !n.isRead).length;
        emit(NotifikasiLoaded(notifications: list, unreadCount: unread));
      },
    );
  }

  Future<void> _onMarkNotifikasiRead(
    MarkNotifikasiReadEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    await _repository.markAsRead(event.id);
    add(const FetchNotifikasiEvent());
  }

  Future<void> _onMarkAllNotifikasiRead(
    MarkAllNotifikasiReadEvent event,
    Emitter<NotifikasiState> emit,
  ) async {
    await _repository.markAllAsRead();
    add(const FetchNotifikasiEvent());
  }
}
