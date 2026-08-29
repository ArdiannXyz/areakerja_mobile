import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/divisi_model.dart';
import '../../data/models/profil_kandidat_model.dart';
import '../../data/repositories/kandidat_repository_impl.dart';

// =========================================================================
// EVENTS
// =========================================================================

abstract class KandidatEvent extends Equatable {
  const KandidatEvent();

  @override
  List<Object?> get props => [];
}

class FetchStatusProgramEvent extends KandidatEvent {
  const FetchStatusProgramEvent();
}

class FetchDivisiListEvent extends KandidatEvent {
  const FetchDivisiListEvent();
}

class DaftarKandidatEvent extends KandidatEvent {
  final String divisiId;
  final String paymentChannelId;

  const DaftarKandidatEvent({
    required this.divisiId,
    required this.paymentChannelId,
  });

  @override
  List<Object?> get props => [divisiId, paymentChannelId];
}

// =========================================================================
// STATES
// =========================================================================

abstract class KandidatState extends Equatable {
  const KandidatState();

  @override
  List<Object?> get props => [];
}

class KandidatInitial extends KandidatState {
  const KandidatInitial();
}

class KandidatLoading extends KandidatState {
  const KandidatLoading();
}

class KandidatStatusLoaded extends KandidatState {
  final KandidatProgramModel programModel;
  final List<DivisiModel> divisiList;

  const KandidatStatusLoaded({
    required this.programModel,
    this.divisiList = const [],
  });

  @override
  List<Object?> get props => [programModel, divisiList];
}

class KandidatDivisiLoaded extends KandidatState {
  final List<DivisiModel> divisiList;

  const KandidatDivisiLoaded(this.divisiList);

  @override
  List<Object?> get props => [divisiList];
}

class KandidatDaftarSuccess extends KandidatState {
  final Map<String, dynamic> responseData;

  const KandidatDaftarSuccess(this.responseData);

  @override
  List<Object?> get props => [responseData];
}

class KandidatError extends KandidatState {
  final String message;

  const KandidatError(this.message);

  @override
  List<Object?> get props => [message];
}

// =========================================================================
// BLOC
// =========================================================================

class KandidatBloc extends Bloc<KandidatEvent, KandidatState> {
  final KandidatRepository _repository;

  KandidatBloc({required KandidatRepository repository})
      : _repository = repository,
        super(const KandidatInitial()) {
    on<FetchStatusProgramEvent>(_onFetchStatusProgram);
    on<FetchDivisiListEvent>(_onFetchDivisiList);
    on<DaftarKandidatEvent>(_onDaftarKandidat);
  }

  Future<void> _onFetchStatusProgram(
    FetchStatusProgramEvent event,
    Emitter<KandidatState> emit,
  ) async {
    emit(const KandidatLoading());
    final result = await _repository.getStatusProgram();
    result.fold(
      (failure) => emit(KandidatError(failure.message)),
      (programModel) => emit(KandidatStatusLoaded(programModel: programModel)),
    );
  }

  Future<void> _onFetchDivisiList(
    FetchDivisiListEvent event,
    Emitter<KandidatState> emit,
  ) async {
    emit(const KandidatLoading());
    final result = await _repository.getDivisiList();
    result.fold(
      (failure) => emit(KandidatError(failure.message)),
      (divisiList) => emit(KandidatDivisiLoaded(divisiList)),
    );
  }

  Future<void> _onDaftarKandidat(
    DaftarKandidatEvent event,
    Emitter<KandidatState> emit,
  ) async {
    emit(const KandidatLoading());
    final result = await _repository.daftarKandidat(
      divisiId: event.divisiId,
      paymentChannelId: event.paymentChannelId,
    );
    result.fold(
      (failure) => emit(KandidatError(failure.message)),
      (responseData) => emit(KandidatDaftarSuccess(responseData)),
    );
  }
}
