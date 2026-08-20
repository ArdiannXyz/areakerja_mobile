import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lowongan_model.dart';
import '../../data/repositories/lowongan_repository_impl.dart';

// EVENTS
abstract class LowonganEvent extends Equatable {
  const LowonganEvent();
  @override
  List<Object?> get props => [];
}

class FetchLowonganListEvent extends LowonganEvent {
  final String? keyword;
  final String? kategori;
  final String? lokasi;
  final String? tipe;

  const FetchLowonganListEvent({
    this.keyword,
    this.kategori,
    this.lokasi,
    this.tipe,
  });

  @override
  List<Object?> get props => [keyword, kategori, lokasi, tipe];
}

class ToggleFavoriteJobEvent extends LowonganEvent {
  final String lowonganId;
  const ToggleFavoriteJobEvent(this.lowonganId);

  @override
  List<Object?> get props => [lowonganId];
}

class SubmitLamaranEvent extends LowonganEvent {
  final LamaranRequestModel request;
  const SubmitLamaranEvent(this.request);

  @override
  List<Object?> get props => [request];
}

// STATES
abstract class LowonganState extends Equatable {
  const LowonganState();
  @override
  List<Object?> get props => [];
}

class LowonganInitial extends LowonganState {}

class LowonganLoading extends LowonganState {}

class LowonganLoaded extends LowonganState {
  final List<LowonganModel> jobs;
  final List<KategoriLowonganModel> categories;
  final String selectedCategory;
  final String? searchKeyword;

  const LowonganLoaded({
    required this.jobs,
    required this.categories,
    this.selectedCategory = 'Semua',
    this.searchKeyword,
  });

  @override
  List<Object?> get props => [jobs, categories, selectedCategory, searchKeyword];

  LowonganLoaded copyWith({
    List<LowonganModel>? jobs,
    List<KategoriLowonganModel>? categories,
    String? selectedCategory,
    String? searchKeyword,
  }) {
    return LowonganLoaded(
      jobs: jobs ?? this.jobs,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchKeyword: searchKeyword ?? this.searchKeyword,
    );
  }
}

class LamaranSubmittingState extends LowonganState {}

class LamaranSuccessState extends LowonganState {
  final String message;
  const LamaranSuccessState(this.message);

  @override
  List<Object?> get props => [message];
}

class LowonganErrorState extends LowonganState {
  final String message;
  const LowonganErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

// BLOC
class LowonganBloc extends Bloc<LowonganEvent, LowonganState> {
  final LowonganRepository _repository;

  LowonganBloc({required LowonganRepository repository})
      : _repository = repository,
        super(LowonganInitial()) {
    on<FetchLowonganListEvent>(_onFetchLowonganList);
    on<ToggleFavoriteJobEvent>(_onToggleFavoriteJob);
    on<SubmitLamaranEvent>(_onSubmitLamaran);
  }

  Future<void> _onFetchLowonganList(
    FetchLowonganListEvent event,
    Emitter<LowonganState> emit,
  ) async {
    emit(LowonganLoading());

    final categoriesResult = await _repository.getKategoriList();
    final List<KategoriLowonganModel> categories = categoriesResult.getOrElse(() => []);

    final jobsResult = await _repository.getLowonganList(
      keyword: event.keyword,
      kategori: event.kategori,
      lokasi: event.lokasi,
      tipe: event.tipe,
    );

    jobsResult.fold(
      (failure) => emit(LowonganErrorState(failure.message)),
      (jobs) => emit(LowonganLoaded(
        jobs: jobs,
        categories: categories,
        selectedCategory: event.kategori ?? 'Semua',
        searchKeyword: event.keyword,
      )),
    );
  }

  Future<void> _onToggleFavoriteJob(
    ToggleFavoriteJobEvent event,
    Emitter<LowonganState> emit,
  ) async {
    if (state is LowonganLoaded) {
      final currentLoaded = state as LowonganLoaded;
      await _repository.toggleFavorite(event.lowonganId);

      final updatedJobs = currentLoaded.jobs.map((job) {
        if (job.id == event.lowonganId) {
          return job.copyWith(isFavorit: !job.isFavorit);
        }
        return job;
      }).toList();

      emit(currentLoaded.copyWith(jobs: updatedJobs));
    }
  }

  Future<void> _onSubmitLamaran(
    SubmitLamaranEvent event,
    Emitter<LowonganState> emit,
  ) async {
    emit(LamaranSubmittingState());
    final result = await _repository.submitLamaran(event.request);

    result.fold(
      (failure) => emit(LowonganErrorState(failure.message)),
      (successMsg) => emit(LamaranSuccessState(successMsg)),
    );
  }
}
