import 'package:equatable/equatable.dart';

class ProfilPelamarModel extends Equatable {
  final String id;
  final String nama;
  final String email;
  final String? noTelepon;
  final String? alamat;
  final String? bio;
  final String? resumeUrl;
  final String? resumeFileName;
  final String? fotoUrl;
  final List<String> keahlian;
  final String? pendidikanTerakhir;
  final String? pengalamanTahun;
  final String? portofolioUrl;
  final DateTime? updatedAt;

  const ProfilPelamarModel({
    required this.id,
    required this.nama,
    required this.email,
    this.noTelepon,
    this.alamat,
    this.bio,
    this.resumeUrl,
    this.resumeFileName,
    this.fotoUrl,
    this.keahlian = const [],
    this.pendidikanTerakhir,
    this.pengalamanTahun,
    this.portofolioUrl,
    this.updatedAt,
  });

  factory ProfilPelamarModel.fromJson(Map<String, dynamic> json) {
    List<String> parseKeahlian(dynamic raw) {
      if (raw is List) return raw.map((e) => e.toString()).toList();
      if (raw is String && raw.isNotEmpty) {
        return raw.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
      }
      return [];
    }

    return ProfilPelamarModel(
      id: json['id']?.toString() ?? json['user_id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      noTelepon: json['no_telepon']?.toString() ?? json['phone']?.toString() ?? json['telepon']?.toString(),
      alamat: json['alamat']?.toString() ?? json['address']?.toString(),
      bio: json['bio']?.toString() ?? json['about']?.toString(),
      resumeUrl: json['resume_url']?.toString() ?? json['cv_url']?.toString(),
      resumeFileName: json['resume_file_name']?.toString() ?? json['cv_name']?.toString(),
      fotoUrl: json['foto_url']?.toString() ?? json['avatar']?.toString(),
      keahlian: parseKeahlian(json['keahlian'] ?? json['skills']),
      pendidikanTerakhir: json['pendidikan_terakhir']?.toString() ?? json['education']?.toString(),
      pengalamanTahun: json['pengalaman_tahun']?.toString() ?? json['experience_years']?.toString(),
      portofolioUrl: json['portofolio_url']?.toString() ?? json['portfolio_url']?.toString(),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'no_telepon': noTelepon,
      'alamat': alamat,
      'bio': bio,
      'keahlian': keahlian,
      'pendidikan_terakhir': pendidikanTerakhir,
      'pengalaman_tahun': pengalamanTahun,
      'portofolio_url': portofolioUrl,
    };
  }

  ProfilPelamarModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? noTelepon,
    String? alamat,
    String? bio,
    String? resumeUrl,
    String? resumeFileName,
    String? fotoUrl,
    List<String>? keahlian,
    String? pendidikanTerakhir,
    String? pengalamanTahun,
    String? portofolioUrl,
    DateTime? updatedAt,
  }) {
    return ProfilPelamarModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noTelepon: noTelepon ?? this.noTelepon,
      alamat: alamat ?? this.alamat,
      bio: bio ?? this.bio,
      resumeUrl: resumeUrl ?? this.resumeUrl,
      resumeFileName: resumeFileName ?? this.resumeFileName,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      keahlian: keahlian ?? this.keahlian,
      pendidikanTerakhir: pendidikanTerakhir ?? this.pendidikanTerakhir,
      pengalamanTahun: pengalamanTahun ?? this.pengalamanTahun,
      portofolioUrl: portofolioUrl ?? this.portofolioUrl,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        nama,
        email,
        noTelepon,
        alamat,
        bio,
        resumeUrl,
        resumeFileName,
        fotoUrl,
        keahlian,
        pendidikanTerakhir,
        pengalamanTahun,
        portofolioUrl,
        updatedAt,
      ];
}
