import 'package:equatable/equatable.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../../data/models/company_applicant_model.dart';
import '../../data/models/company_dashboard_model.dart';
import '../../data/models/profil_perusahaan_model.dart';

/// ─── Events ───────────────────────────────────────────────────────────────

abstract class PerusahaanEvent extends Equatable {
  const PerusahaanEvent();

  @override
  List<Object?> get props => [];
}

/// Muat dashboard summary (statistik rekrutmen)
class FetchDashboardEvent extends PerusahaanEvent {
  const FetchDashboardEvent();
}

/// Muat daftar lowongan milik perusahaan
class FetchMyJobsEvent extends PerusahaanEvent {
  const FetchMyJobsEvent();
}

/// Muat detail satu lowongan
class FetchJobDetailEvent extends PerusahaanEvent {
  final String jobId;
  const FetchJobDetailEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

/// Buat lowongan baru
class CreateJobEvent extends PerusahaanEvent {
  final Map<String, dynamic> jobData;
  const CreateJobEvent(this.jobData);

  @override
  List<Object?> get props => [jobData];
}

/// Edit lowongan existing
class UpdateJobEvent extends PerusahaanEvent {
  final String jobId;
  final Map<String, dynamic> jobData;
  const UpdateJobEvent({required this.jobId, required this.jobData});

  @override
  List<Object?> get props => [jobId, jobData];
}

/// Toggle aktif/nonaktif lowongan
class ToggleJobStatusEvent extends PerusahaanEvent {
  final String jobId;
  const ToggleJobStatusEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

/// Muat pelamar untuk satu lowongan
class FetchJobApplicantsEvent extends PerusahaanEvent {
  final String jobId;
  const FetchJobApplicantsEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

/// Update status pelamar (proses, interview, terima, tolak, dll)
class UpdateApplicantStatusEvent extends PerusahaanEvent {
  final String applicationId;
  final String status;
  final String? catatan;
  const UpdateApplicantStatusEvent({
    required this.applicationId,
    required this.status,
    this.catatan,
  });

  @override
  List<Object?> get props => [applicationId, status, catatan];
}

/// Muat profil perusahaan
class FetchProfileEvent extends PerusahaanEvent {
  const FetchProfileEvent();
}

/// Update profil perusahaan
class UpdateProfileEvent extends PerusahaanEvent {
  final Map<String, dynamic> profileData;
  const UpdateProfileEvent(this.profileData);

  @override
  List<Object?> get props => [profileData];
}

/// ─── States ───────────────────────────────────────────────────────────────

abstract class PerusahaanState extends Equatable {
  const PerusahaanState();

  @override
  List<Object?> get props => [];
}

class PerusahaanInitial extends PerusahaanState {
  const PerusahaanInitial();
}

class PerusahaanLoading extends PerusahaanState {
  const PerusahaanLoading();
}

class DashboardLoaded extends PerusahaanState {
  final CompanyDashboardModel dashboard;
  const DashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class MyJobsLoaded extends PerusahaanState {
  final List<LowonganModel> jobs;
  const MyJobsLoaded(this.jobs);

  @override
  List<Object?> get props => [jobs];
}

class JobDetailLoaded extends PerusahaanState {
  final LowonganModel job;
  const JobDetailLoaded(this.job);

  @override
  List<Object?> get props => [job];
}

class JobCreated extends PerusahaanState {
  final LowonganModel job;
  const JobCreated(this.job);

  @override
  List<Object?> get props => [job];
}

class JobUpdated extends PerusahaanState {
  final LowonganModel job;
  const JobUpdated(this.job);

  @override
  List<Object?> get props => [job];
}

class JobStatusToggled extends PerusahaanState {
  final String jobId;
  const JobStatusToggled(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class JobApplicantsLoaded extends PerusahaanState {
  final String jobId;
  final List<CompanyApplicantModel> applicants;
  const JobApplicantsLoaded({required this.jobId, required this.applicants});

  @override
  List<Object?> get props => [jobId, applicants];
}

class ApplicantStatusUpdated extends PerusahaanState {
  final String applicationId;
  const ApplicantStatusUpdated(this.applicationId);

  @override
  List<Object?> get props => [applicationId];
}

class ProfileLoaded extends PerusahaanState {
  final ProfilPerusahaanModel profile;
  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdated extends PerusahaanState {
  final ProfilPerusahaanModel profile;
  const ProfileUpdated(this.profile);

  @override
  List<Object?> get props => [profile];
}

class PerusahaanError extends PerusahaanState {
  final String message;
  const PerusahaanError(this.message);

  @override
  List<Object?> get props => [message];
}
