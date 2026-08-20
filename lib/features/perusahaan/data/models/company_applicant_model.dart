import 'package:equatable/equatable.dart';

class CompanyApplicantModel extends Equatable {
  final String id;
  final String candidateName;
  final String email;
  final String? phone;
  final String? resumeUrl;
  final String? portofolioUrl;
  final String? coverLetter;
  final String status;
  final DateTime? appliedAt;

  const CompanyApplicantModel({
    required this.id,
    required this.candidateName,
    required this.email,
    this.phone,
    this.resumeUrl,
    this.portofolioUrl,
    this.coverLetter,
    required this.status,
    this.appliedAt,
  });

  factory CompanyApplicantModel.fromJson(Map<String, dynamic> json) {
    final userMap = json['user'] is Map<String, dynamic>
        ? json['user'] as Map<String, dynamic>
        : (json['pelamar'] is Map<String, dynamic> ? json['pelamar'] as Map<String, dynamic> : json);

    return CompanyApplicantModel(
      id: json['id']?.toString() ?? '',
      candidateName: userMap['name']?.toString() ?? userMap['nama']?.toString() ?? json['candidate_name']?.toString() ?? 'Pelamar',
      email: userMap['email']?.toString() ?? json['email']?.toString() ?? '',
      phone: userMap['phone']?.toString() ?? userMap['telepon']?.toString() ?? json['phone']?.toString(),
      resumeUrl: json['resume_url']?.toString() ?? json['cv_url']?.toString(),
      portofolioUrl: json['portofolio_url']?.toString() ?? json['portfolio_url']?.toString(),
      coverLetter: json['cover_letter']?.toString() ?? json['catatan']?.toString(),
      status: json['status']?.toString() ?? 'menunggu',
      appliedAt: json['applied_at'] != null
          ? DateTime.tryParse(json['applied_at'].toString())
          : (json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null),
    );
  }

  @override
  List<Object?> get props => [
        id,
        candidateName,
        email,
        phone,
        resumeUrl,
        portofolioUrl,
        coverLetter,
        status,
        appliedAt,
      ];
}
