import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/perusahaan_repository_impl.dart';
import 'perusahaan_event.dart';

export 'perusahaan_event.dart';

class PerusahaanBloc extends Bloc<PerusahaanEvent, PerusahaanState> {
  final PerusahaanRepository _repository;

  PerusahaanBloc({required PerusahaanRepository repository})
      : _repository = repository,
        super(const PerusahaanInitial()) {
    on<FetchDashboardEvent>(_onFetchDashboard);
    on<FetchMyJobsEvent>(_onFetchMyJobs);
    on<FetchJobDetailEvent>(_onFetchJobDetail);
    on<CreateJobEvent>(_onCreateJob);
    on<UpdateJobEvent>(_onUpdateJob);
    on<ToggleJobStatusEvent>(_onToggleJobStatus);
    on<FetchJobApplicantsEvent>(_onFetchJobApplicants);
    on<UpdateApplicantStatusEvent>(_onUpdateApplicantStatus);
    on<FetchProfileEvent>(_onFetchProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onFetchDashboard(
    FetchDashboardEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.getDashboardSummary();
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (dashboard) => emit(DashboardLoaded(dashboard)),
    );
  }

  Future<void> _onFetchMyJobs(
    FetchMyJobsEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.getMyJobs();
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (jobs) => emit(MyJobsLoaded(jobs)),
    );
  }

  Future<void> _onFetchJobDetail(
    FetchJobDetailEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.getJobDetail(event.jobId);
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (job) => emit(JobDetailLoaded(job)),
    );
  }

  Future<void> _onCreateJob(
    CreateJobEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.storeJob(event.jobData);
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (job) => emit(JobCreated(job)),
    );
  }

  Future<void> _onUpdateJob(
    UpdateJobEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.updateJob(event.jobId, event.jobData);
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (job) => emit(JobUpdated(job)),
    );
  }

  Future<void> _onToggleJobStatus(
    ToggleJobStatusEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    final result = await _repository.toggleJobStatus(event.jobId);
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (_) => emit(JobStatusToggled(event.jobId)),
    );
  }

  Future<void> _onFetchJobApplicants(
    FetchJobApplicantsEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.getJobApplicants(event.jobId);
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (applicants) => emit(
        JobApplicantsLoaded(jobId: event.jobId, applicants: applicants),
      ),
    );
  }

  Future<void> _onUpdateApplicantStatus(
    UpdateApplicantStatusEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    final result = await _repository.updateApplicantStatus(
      applicationId: event.applicationId,
      status: event.status,
      catatan: event.catatan,
    );
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (_) => emit(ApplicantStatusUpdated(event.applicationId)),
    );
  }

  Future<void> _onFetchProfile(
    FetchProfileEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.getProfile();
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<PerusahaanState> emit,
  ) async {
    emit(const PerusahaanLoading());
    final result = await _repository.updateProfile(event.profileData);
    result.fold(
      (failure) => emit(PerusahaanError(failure.message)),
      (profile) => emit(ProfileUpdated(profile)),
    );
  }
}
