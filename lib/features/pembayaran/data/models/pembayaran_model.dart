import 'package:equatable/equatable.dart';

enum StatusTagihan {
  menungguPembayaran,
  menungguVerifikasi,
  terverifikasi,
  ditolak,
  expired;

  static StatusTagihan fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'menunggu_pembayaran':
      case 'pending':
      case 'waiting_payment':
        return StatusTagihan.menungguPembayaran;
      case 'menunggu_verifikasi':
      case 'waiting_verification':
      case 'uploaded':
        return StatusTagihan.menungguVerifikasi;
      case 'terverifikasi':
      case 'verified':
      case 'approved':
        return StatusTagihan.terverifikasi;
      case 'ditolak':
      case 'rejected':
      case 'failed':
        return StatusTagihan.ditolak;
      case 'expired':
      case 'kadaluarsa':
        return StatusTagihan.expired;
      default:
        return StatusTagihan.menungguPembayaran;
    }
  }

  String get displayLabel {
    switch (this) {
      case StatusTagihan.menungguPembayaran:
        return 'Menunggu Pembayaran';
      case StatusTagihan.menungguVerifikasi:
        return 'Menunggu Verifikasi';
      case StatusTagihan.terverifikasi:
        return 'Pembayaran Terverifikasi';
      case StatusTagihan.ditolak:
        return 'Pembayaran Ditolak';
      case StatusTagihan.expired:
        return 'Expired';
    }
  }
}

class MetodePembayaranModel extends Equatable {
  final String id;
  final String nama;
  final String tipe; // 'bank_transfer' | 'qris'
  final String? namaBank;
  final String? nomorRekening;
  final String? atasNama;
  final String? qrisImageUrl;

  const MetodePembayaranModel({
    required this.id,
    required this.nama,
    required this.tipe,
    this.namaBank,
    this.nomorRekening,
    this.atasNama,
    this.qrisImageUrl,
  });

  bool get isTransferBank => tipe == 'bank_transfer';
  bool get isQris => tipe == 'qris';

  factory MetodePembayaranModel.fromJson(Map<String, dynamic> json) {
    return MetodePembayaranModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ??
          json['name']?.toString() ??
          json['channel_name']?.toString() ??
          '',
      tipe: json['tipe']?.toString() ??
          json['type']?.toString() ??
          'bank_transfer',
      namaBank: json['nama_bank']?.toString() ?? json['bank_name']?.toString(),
      nomorRekening:
          json['nomor_rekening']?.toString() ?? json['account_number']?.toString(),
      atasNama: json['atas_nama']?.toString() ?? json['account_name']?.toString(),
      qrisImageUrl:
          json['qris_image_url']?.toString() ?? json['qris_url']?.toString(),
    );
  }

  @override
  List<Object?> get props =>
      [id, nama, tipe, namaBank, nomorRekening, atasNama, qrisImageUrl];
}

class PembayaranModel extends Equatable {
  final String id;
  final String noTransaksi;
  final StatusTagihan statusTagihan;
  final DateTime? batasPembayaran;
  final int totalPembayaran;
  final int jumlahDeposit;
  final int biayaAdmin;
  final MetodePembayaranModel? metodePembayaran;
  final String? buktiPembayaranUrl;
  final String? alasanDitolak;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PembayaranModel({
    required this.id,
    required this.noTransaksi,
    required this.statusTagihan,
    this.batasPembayaran,
    required this.totalPembayaran,
    this.jumlahDeposit = 200000,
    this.biayaAdmin = 2000,
    this.metodePembayaran,
    this.buktiPembayaranUrl,
    this.alasanDitolak,
    this.createdAt,
    this.updatedAt,
  });

  bool get sudahUploadBukti => buktiPembayaranUrl != null;

  bool get isExpired {
    if (batasPembayaran == null) return false;
    return DateTime.now().isAfter(batasPembayaran!);
  }

  Duration? get sisaWaktu {
    if (batasPembayaran == null) return null;
    final now = DateTime.now();
    if (now.isAfter(batasPembayaran!)) return Duration.zero;
    return batasPembayaran!.difference(now);
  }

  factory PembayaranModel.fromJson(Map<String, dynamic> json) {
    return PembayaranModel(
      id: json['id']?.toString() ?? '',
      noTransaksi: json['no_transaksi']?.toString() ??
          json['transaction_code']?.toString() ??
          json['code']?.toString() ??
          '',
      statusTagihan: StatusTagihan.fromString(
          json['status']?.toString() ?? json['status_tagihan']?.toString()),
      batasPembayaran: json['batas_pembayaran'] != null
          ? DateTime.tryParse(json['batas_pembayaran'].toString())
          : json['expired_at'] != null
              ? DateTime.tryParse(json['expired_at'].toString())
              : null,
      totalPembayaran:
          _parseAmount(json['total_pembayaran'] ?? json['amount'] ?? 0),
      jumlahDeposit:
          _parseAmount(json['jumlah_deposit'] ?? json['deposit_amount'] ?? 200000),
      biayaAdmin:
          _parseAmount(json['biaya_admin'] ?? json['admin_fee'] ?? 2000),
      metodePembayaran: json['metode_pembayaran'] != null
          ? MetodePembayaranModel.fromJson(
              json['metode_pembayaran'] as Map<String, dynamic>)
          : json['payment_channel'] != null
              ? MetodePembayaranModel.fromJson(
                  json['payment_channel'] as Map<String, dynamic>)
              : null,
      buktiPembayaranUrl: json['bukti_pembayaran_url']?.toString() ??
          json['proof_url']?.toString(),
      alasanDitolak:
          json['alasan_ditolak']?.toString() ?? json['rejection_reason']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  static int _parseAmount(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  @override
  List<Object?> get props => [
        id,
        noTransaksi,
        statusTagihan,
        batasPembayaran,
        totalPembayaran,
        jumlahDeposit,
        biayaAdmin,
        metodePembayaran,
        buktiPembayaranUrl,
        alasanDitolak,
        createdAt,
        updatedAt,
      ];
}
