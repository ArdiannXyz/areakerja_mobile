import 'package:equatable/equatable.dart';

class CompanyDashboardModel extends Equatable {
  final int totalJobs;
  final int activeJobs;
  final int totalApplicants;
  final int pendingApplicants;
  final int interviewedApplicants;
  final int hiredApplicants;

  const CompanyDashboardModel({
    this.totalJobs = 0,
    this.activeJobs = 0,
    this.totalApplicants = 0,
    this.pendingApplicants = 0,
    this.interviewedApplicants = 0,
    this.hiredApplicants = 0,
  });

  factory CompanyDashboardModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val) {
      if (val is int) return val;
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return CompanyDashboardModel(
      totalJobs: parseInt(json['total_jobs'] ?? json['jobs_count']),
      activeJobs: parseInt(json['active_jobs'] ?? json['active_jobs_count']),
      totalApplicants: parseInt(json['total_applicants'] ?? json['applicants_count']),
      pendingApplicants: parseInt(json['pending_applicants']),
      interviewedApplicants: parseInt(json['interviewed_applicants'] ?? json['interview_count']),
      hiredApplicants: parseInt(json['hired_applicants'] ?? json['hired_count']),
    );
  }

  @override
  List<Object?> get props => [
        totalJobs,
        activeJobs,
        totalApplicants,
        pendingApplicants,
        interviewedApplicants,
        hiredApplicants,
      ];
}
