import 'package:equatable/equatable.dart';

class LowonganModel extends Equatable {
  final String id;
  final String judul;
  final String namaPerusahaan;
  final String? logoPerusahaan;
  final String lokasi;
  final String tipePekerjaan; // Full Time, Part Time, Remote, Freelance, Magang
  final String kategori; // Teknologi, Desain, Keuangan, Pemasaran, HR, Operasional, dll.
  final num? gajiMin;
  final num? gajiMax;
  final String deskripsi;
  final List<String> persyaratan;
  final List<String> benefit;
  final bool isFavorit;
  final int jumlahPelamar;
  final int? kuota;
  final String status; // Buka, Tutup
  final DateTime? deadline;
  final DateTime? createdAt;

  const LowonganModel({
    required this.id,
    required this.judul,
    required this.namaPerusahaan,
    this.logoPerusahaan,
    required this.lokasi,
    required this.tipePekerjaan,
    required this.kategori,
    this.gajiMin,
    this.gajiMax,
    required this.deskripsi,
    this.persyaratan = const [],
    this.benefit = const [],
    this.isFavorit = false,
    this.jumlahPelamar = 0,
    this.kuota,
    this.status = 'Buka',
    this.deadline,
    this.createdAt,
  });

  String get rentangGaji {
    if (gajiMin != null && gajiMax != null) {
      return 'Rp ${(gajiMin! / 1000000).toStringAsFixed(0)} - ${(gajiMax! / 1000000).toStringAsFixed(0)} Jt/bln';
    } else if (gajiMin != null) {
      return 'Mulai Rp ${(gajiMin! / 1000000).toStringAsFixed(0)} Jt/bln';
    } else if (gajiMax != null) {
      return 'Hingga Rp ${(gajiMax! / 1000000).toStringAsFixed(0)} Jt/bln';
    }
    return 'Gaji Dirahasiakan';
  }

  factory LowonganModel.fromJson(Map<String, dynamic> json) {
    List<String> parseStringList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      } else if (value is String) {
        return value.split('\n').where((s) => s.trim().isNotEmpty).toList();
      }
      return [];
    }

    return LowonganModel(
      id: json['id']?.toString() ?? '',
      judul: json['judul']?.toString() ?? json['posisi']?.toString() ?? json['title']?.toString() ?? '',
      namaPerusahaan: json['nama_perusahaan']?.toString() ?? json['company_name']?.toString() ?? 'AreaKerja Partner',
      logoPerusahaan: json['logo_perusahaan']?.toString() ?? json['company_logo']?.toString(),
      lokasi: json['lokasi']?.toString() ?? json['location']?.toString() ?? 'Indonesia',
      tipePekerjaan: json['tipe_pekerjaan']?.toString() ?? json['type']?.toString() ?? 'Full Time',
      kategori: json['kategori']?.toString() ?? json['category']?.toString() ?? 'Umum',
      gajiMin: json['gaji_min'] != null ? num.tryParse(json['gaji_min'].toString()) : null,
      gajiMax: json['gaji_max'] != null ? num.tryParse(json['gaji_max'].toString()) : null,
      deskripsi: json['deskripsi']?.toString() ?? json['description']?.toString() ?? '',
      persyaratan: parseStringList(json['persyaratan'] ?? json['requirements']),
      benefit: parseStringList(json['benefit'] ?? json['benefits']),
      isFavorit: json['is_favorit'] == true || json['is_bookmarked'] == true,
      jumlahPelamar: json['jumlah_pelamar'] is int ? json['jumlah_pelamar'] : (json['applicants_count'] is int ? json['applicants_count'] : 0),
      kuota: json['kuota'] is int ? json['kuota'] : null,
      status: json['status']?.toString() ?? 'Buka',
      deadline: json['deadline'] != null ? DateTime.tryParse(json['deadline'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'nama_perusahaan': namaPerusahaan,
      'logo_perusahaan': logoPerusahaan,
      'lokasi': lokasi,
      'tipe_pekerjaan': tipePekerjaan,
      'kategori': kategori,
      'gaji_min': gajiMin,
      'gaji_max': gajiMax,
      'deskripsi': deskripsi,
      'persyaratan': persyaratan,
      'benefit': benefit,
      'is_favorit': isFavorit,
      'jumlah_pelamar': jumlahPelamar,
      'kuota': kuota,
      'status': status,
      'deadline': deadline?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  LowonganModel copyWith({
    String? id,
    String? judul,
    String? namaPerusahaan,
    String? logoPerusahaan,
    String? lokasi,
    String? tipePekerjaan,
    String? kategori,
    num? gajiMin,
    num? gajiMax,
    String? deskripsi,
    List<String>? persyaratan,
    List<String>? benefit,
    bool? isFavorit,
    int? jumlahPelamar,
    int? kuota,
    String? status,
    DateTime? deadline,
    DateTime? createdAt,
  }) {
    return LowonganModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      namaPerusahaan: namaPerusahaan ?? this.namaPerusahaan,
      logoPerusahaan: logoPerusahaan ?? this.logoPerusahaan,
      lokasi: lokasi ?? this.lokasi,
      tipePekerjaan: tipePekerjaan ?? this.tipePekerjaan,
      kategori: kategori ?? this.kategori,
      gajiMin: gajiMin ?? this.gajiMin,
      gajiMax: gajiMax ?? this.gajiMax,
      deskripsi: deskripsi ?? this.deskripsi,
      persyaratan: persyaratan ?? this.persyaratan,
      benefit: benefit ?? this.benefit,
      isFavorit: isFavorit ?? this.isFavorit,
      jumlahPelamar: jumlahPelamar ?? this.jumlahPelamar,
      kuota: kuota ?? this.kuota,
      status: status ?? this.status,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        judul,
        namaPerusahaan,
        logoPerusahaan,
        lokasi,
        tipePekerjaan,
        kategori,
        gajiMin,
        gajiMax,
        deskripsi,
        persyaratan,
        benefit,
        isFavorit,
        jumlahPelamar,
        kuota,
        status,
        deadline,
        createdAt,
      ];
}

class KategoriLowonganModel extends Equatable {
  final String id;
  final String nama;
  final String icon;
  final int jumlahLowongan;

  const KategoriLowonganModel({
    required this.id,
    required this.nama,
    required this.icon,
    this.jumlahLowongan = 0,
  });

  factory KategoriLowonganModel.fromJson(Map<String, dynamic> json) {
    return KategoriLowonganModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['name']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'work',
      jumlahLowongan: json['total'] is int ? json['total'] : 0,
    );
  }

  @override
  List<Object?> get props => [id, nama, icon, jumlahLowongan];
}

class LamaranRequestModel {
  final String lowonganId;
  final String namaLengkap;
  final String email;
  final String nomorHp;
  final String pendidikanTerakhir;
  final String pengalamanTahun;
  final String? ekspektasiGaji;
  final String? portofolioUrl;
  final String? coverLetter;
  final String? resumeFileName;

  const LamaranRequestModel({
    required this.lowonganId,
    required this.namaLengkap,
    required this.email,
    required this.nomorHp,
    required this.pendidikanTerakhir,
    required this.pengalamanTahun,
    this.ekspektasiGaji,
    this.portofolioUrl,
    this.coverLetter,
    this.resumeFileName,
  });

  Map<String, dynamic> toJson() {
    return {
      'lowongan_id': lowonganId,
      'nama_lengkap': namaLengkap,
      'email': email,
      'telepon': nomorHp,
      'pendidikan_terakhir': pendidikanTerakhir,
      'pengalaman_tahun': pengalamanTahun,
      'ekspektasi_gaji': ekspektasiGaji,
      'portofolio_url': portofolioUrl,
      'cover_letter': coverLetter,
      'resume_file_name': resumeFileName,
    };
  }
}
