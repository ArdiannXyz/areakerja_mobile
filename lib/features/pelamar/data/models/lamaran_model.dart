import 'package:equatable/equatable.dart';

enum StatusLamaran {
  menunggu,
  direview,
  interview,
  diterima,
  ditolak;

  static StatusLamaran fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'direview':
      case 'in_review':
      case 'review':
        return StatusLamaran.direview;
      case 'interview':
      case 'wawancara':
        return StatusLamaran.interview;
      case 'diterima':
      case 'accepted':
      case 'hired':
        return StatusLamaran.diterima;
      case 'ditolak':
      case 'rejected':
        return StatusLamaran.ditolak;
      case 'menunggu':
      case 'pending':
      default:
        return StatusLamaran.menunggu;
    }
  }

  String get displayName {
    switch (this) {
      case StatusLamaran.menunggu:
        return 'Terkirim';
      case StatusLamaran.direview:
        return 'Sedang Direview';
      case StatusLamaran.interview:
        return 'Panggilan Interview';
      case StatusLamaran.diterima:
        return 'Diterima Bekerja';
      case StatusLamaran.ditolak:
        return 'Belum Sesuai';
    }
  }
}

class LamaranModel extends Equatable {
  final String id;
  final String lowonganId;
  final String judulLowongan;
  final String namaPerusahaan;
  final String? logoPerusahaan;
  final String lokasi;
  final StatusLamaran status;
  final String? resumeUrl;
  final String? catatanPerusahaan;
  final DateTime? tanggalLamar;
  final DateTime? updatedAt;

  const LamaranModel({
    required this.id,
    required this.lowonganId,
    required this.judulLowongan,
    required this.namaPerusahaan,
    this.logoPerusahaan,
    required this.lokasi,
    this.status = StatusLamaran.menunggu,
    this.resumeUrl,
    this.catatanPerusahaan,
    this.tanggalLamar,
    this.updatedAt,
  });

  factory LamaranModel.fromJson(Map<String, dynamic> json) {
    // Nested job information handling
    final jobMap = json['job'] is Map<String, dynamic>
        ? json['job'] as Map<String, dynamic>
        : (json['lowongan'] is Map<String, dynamic> ? json['lowongan'] as Map<String, dynamic> : json);

    return LamaranModel(
      id: json['id']?.toString() ?? '',
      lowonganId: json['job_id']?.toString() ?? json['lowongan_id']?.toString() ?? jobMap['id']?.toString() ?? '',
      judulLowongan: jobMap['judul']?.toString() ?? jobMap['title']?.toString() ?? json['judul_lowongan']?.toString() ?? 'Posisi Pekerjaan',
      namaPerusahaan: jobMap['nama_perusahaan']?.toString() ?? jobMap['company_name']?.toString() ?? json['nama_perusahaan']?.toString() ?? 'Perusahaan Mitra',
      logoPerusahaan: jobMap['logo_perusahaan']?.toString() ?? jobMap['company_logo']?.toString(),
      lokasi: jobMap['lokasi']?.toString() ?? jobMap['location']?.toString() ?? 'Indonesia',
      status: StatusLamaran.fromString(json['status']?.toString()),
      resumeUrl: json['resume_url']?.toString() ?? json['cv_url']?.toString(),
      catatanPerusahaan: json['feedback']?.toString() ?? json['catatan']?.toString(),
      tanggalLamar: json['applied_at'] != null
          ? DateTime.tryParse(json['applied_at'].toString())
          : (json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'job_id': lowonganId,
      'status': status.name,
      'created_at': tanggalLamar?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        lowonganId,
        judulLowongan,
        namaPerusahaan,
        logoPerusahaan,
        lokasi,
        status,
        resumeUrl,
        catatanPerusahaan,
        tanggalLamar,
        updatedAt,
      ];
}
