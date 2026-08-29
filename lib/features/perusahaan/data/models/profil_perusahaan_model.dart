import 'package:equatable/equatable.dart';

/// Model profil perusahaan — dari endpoint GET /company/profile
class ProfilPerusahaanModel extends Equatable {
  final String id;
  final String namaPerusahaan;
  final String email;
  final String? telepon;
  final String? alamat;
  final String? website;
  final String? deskripsi;
  final String? industri;
  final String? logoUrl;
  final String? kota;
  final String? provinsi;
  final int? jumlahKaryawan;
  final String? tahunBerdiri;
  final int saldoKoin;

  const ProfilPerusahaanModel({
    required this.id,
    required this.namaPerusahaan,
    required this.email,
    this.telepon,
    this.alamat,
    this.website,
    this.deskripsi,
    this.industri,
    this.logoUrl,
    this.kota,
    this.provinsi,
    this.jumlahKaryawan,
    this.tahunBerdiri,
    this.saldoKoin = 0,
  });

  factory ProfilPerusahaanModel.fromJson(Map<String, dynamic> json) {
    // Profile data bisa nested di 'company' atau langsung di root
    final Map<String, dynamic> data;
    if (json['company'] is Map<String, dynamic>) {
      data = {
        ...json,
        ...(json['company'] as Map<String, dynamic>),
      };
    } else if (json['data'] is Map<String, dynamic>) {
      final inner = json['data'] as Map<String, dynamic>;
      if (inner['company'] is Map<String, dynamic>) {
        data = {
          ...inner,
          ...(inner['company'] as Map<String, dynamic>),
        };
      } else {
        data = inner;
      }
    } else {
      data = json;
    }

    int parseSaldo(dynamic val) {
      if (val is int) return val;
      if (val is double) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 0;
      return 0;
    }

    return ProfilPerusahaanModel(
      id: data['id']?.toString() ?? '',
      namaPerusahaan: data['nama_perusahaan']?.toString() ??
          data['company_name']?.toString() ??
          data['name']?.toString() ??
          '',
      email: data['email']?.toString() ?? '',
      telepon: data['telepon']?.toString() ??
          data['phone']?.toString() ??
          data['no_hp']?.toString(),
      alamat: data['alamat']?.toString() ?? data['address']?.toString(),
      website: data['website']?.toString(),
      deskripsi: data['deskripsi']?.toString() ?? data['description']?.toString(),
      industri: data['industri']?.toString() ?? data['industry']?.toString(),
      logoUrl: data['logo_url']?.toString() ??
          data['logo']?.toString() ??
          data['avatar']?.toString(),
      kota: data['kota']?.toString() ?? data['city']?.toString(),
      provinsi: data['provinsi']?.toString() ?? data['province']?.toString(),
      jumlahKaryawan: data['jumlah_karyawan'] is int
          ? data['jumlah_karyawan'] as int
          : int.tryParse(data['jumlah_karyawan']?.toString() ?? ''),
      tahunBerdiri: data['tahun_berdiri']?.toString() ??
          data['founded_year']?.toString(),
      saldoKoin: parseSaldo(
        data['saldo_koin'] ?? data['koin_balance'] ?? data['coin_balance'] ?? 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_perusahaan': namaPerusahaan,
      'email': email,
      'telepon': telepon,
      'alamat': alamat,
      'website': website,
      'deskripsi': deskripsi,
      'industri': industri,
      'logo_url': logoUrl,
      'kota': kota,
      'provinsi': provinsi,
      'jumlah_karyawan': jumlahKaryawan,
      'tahun_berdiri': tahunBerdiri,
      'saldo_koin': saldoKoin,
    };
  }

  ProfilPerusahaanModel copyWith({
    String? id,
    String? namaPerusahaan,
    String? email,
    String? telepon,
    String? alamat,
    String? website,
    String? deskripsi,
    String? industri,
    String? logoUrl,
    String? kota,
    String? provinsi,
    int? jumlahKaryawan,
    String? tahunBerdiri,
    int? saldoKoin,
  }) {
    return ProfilPerusahaanModel(
      id: id ?? this.id,
      namaPerusahaan: namaPerusahaan ?? this.namaPerusahaan,
      email: email ?? this.email,
      telepon: telepon ?? this.telepon,
      alamat: alamat ?? this.alamat,
      website: website ?? this.website,
      deskripsi: deskripsi ?? this.deskripsi,
      industri: industri ?? this.industri,
      logoUrl: logoUrl ?? this.logoUrl,
      kota: kota ?? this.kota,
      provinsi: provinsi ?? this.provinsi,
      jumlahKaryawan: jumlahKaryawan ?? this.jumlahKaryawan,
      tahunBerdiri: tahunBerdiri ?? this.tahunBerdiri,
      saldoKoin: saldoKoin ?? this.saldoKoin,
    );
  }

  @override
  List<Object?> get props => [
        id,
        namaPerusahaan,
        email,
        telepon,
        alamat,
        website,
        deskripsi,
        industri,
        logoUrl,
        kota,
        provinsi,
        jumlahKaryawan,
        tahunBerdiri,
        saldoKoin,
      ];
}
