import 'package:equatable/equatable.dart';

/// Model paket koin yang dijual — dari endpoint GET /packages/koin
class KoinPackageModel extends Equatable {
  final String id;
  final String nama;
  final int jumlahKoin;
  final num harga;
  final String? label;
  final String? deskripsi;
  final bool isPopular;

  const KoinPackageModel({
    required this.id,
    required this.nama,
    required this.jumlahKoin,
    required this.harga,
    this.label,
    this.deskripsi,
    this.isPopular = false,
  });

  String get hargaFormatted {
    final val = harga.toInt();
    if (val >= 1000000) {
      return 'Rp ${(val / 1000000).toStringAsFixed(val % 1000000 == 0 ? 0 : 1)} Jt';
    } else if (val >= 1000) {
      final ribu = val ~/ 1000;
      final sisa = val % 1000;
      if (sisa == 0) return 'Rp $ribu.000';
      return 'Rp ${val.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
    }
    return 'Rp $val';
  }

  factory KoinPackageModel.fromJson(Map<String, dynamic> json) {
    return KoinPackageModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['name']?.toString() ?? '',
      jumlahKoin: json['jumlah_koin'] is int
          ? json['jumlah_koin'] as int
          : int.tryParse(json['jumlah_koin']?.toString() ?? '0') ?? 0,
      harga: json['harga'] != null
          ? num.tryParse(json['harga'].toString()) ?? 0
          : (json['price'] != null ? num.tryParse(json['price'].toString()) ?? 0 : 0),
      label: json['label']?.toString(),
      deskripsi: json['deskripsi']?.toString() ?? json['description']?.toString(),
      isPopular: json['is_popular'] == true ||
          json['popular'] == true ||
          json['label']?.toString().toLowerCase() == 'populer' ||
          json['label']?.toString().toLowerCase() == 'popular',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jumlah_koin': jumlahKoin,
      'harga': harga,
      'label': label,
      'deskripsi': deskripsi,
      'is_popular': isPopular,
    };
  }

  @override
  List<Object?> get props => [id, nama, jumlahKoin, harga, label, isPopular];
}

/// Model transaksi/riwayat pembelian koin — dari endpoint GET /payments/history
class KoinTransactionModel extends Equatable {
  final String id;
  final String noTransaksi;
  final String? packageId;
  final String? packageName;
  final int jumlahKoin;
  final num totalHarga;
  final String status;
  final String? metodePembayaran;
  final String? buktiBayarUrl;
  final DateTime? createdAt;
  final DateTime? expiredAt;

  const KoinTransactionModel({
    required this.id,
    required this.noTransaksi,
    this.packageId,
    this.packageName,
    required this.jumlahKoin,
    required this.totalHarga,
    required this.status,
    this.metodePembayaran,
    this.buktiBayarUrl,
    this.createdAt,
    this.expiredAt,
  });

  /// Status yang ditampilkan ke user dalam Bahasa Indonesia
  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'menunggu_pembayaran':
      case 'waiting':
        return 'Menunggu Pembayaran';
      case 'uploaded':
      case 'menunggu_verifikasi':
      case 'review':
        return 'Menunggu Verifikasi';
      case 'paid':
      case 'success':
      case 'berhasil':
      case 'approved':
        return 'Pembayaran Berhasil';
      case 'rejected':
      case 'ditolak':
      case 'failed':
      case 'gagal':
        return 'Pembayaran Ditolak';
      case 'expired':
      case 'kadaluarsa':
        return 'Transaksi Expired';
      default:
        return status;
    }
  }

  /// Apakah status mengizinkan upload ulang bukti
  bool get canReuploadBukti {
    return status.toLowerCase() == 'rejected' ||
        status.toLowerCase() == 'ditolak';
  }

  /// Apakah status masih menunggu pembayaran (belum upload bukti)
  bool get isPendingPayment {
    return status.toLowerCase() == 'pending' ||
        status.toLowerCase() == 'menunggu_pembayaran' ||
        status.toLowerCase() == 'waiting';
  }

  factory KoinTransactionModel.fromJson(Map<String, dynamic> json) {
    // Handle nested package info
    final packageMap = json['package'] is Map<String, dynamic>
        ? json['package'] as Map<String, dynamic>
        : null;

    return KoinTransactionModel(
      id: json['id']?.toString() ?? '',
      noTransaksi: json['no_transaksi']?.toString() ??
          json['transaction_number']?.toString() ??
          json['id']?.toString() ??
          '',
      packageId: packageMap?['id']?.toString() ?? json['package_id']?.toString(),
      packageName: packageMap?['nama']?.toString() ??
          packageMap?['name']?.toString() ??
          json['package_name']?.toString(),
      jumlahKoin: json['jumlah_koin'] is int
          ? json['jumlah_koin'] as int
          : int.tryParse(json['jumlah_koin']?.toString() ?? '0') ?? 0,
      totalHarga: json['total_harga'] != null
          ? num.tryParse(json['total_harga'].toString()) ?? 0
          : (json['amount'] != null
              ? num.tryParse(json['amount'].toString()) ?? 0
              : 0),
      status: json['status']?.toString() ?? 'pending',
      metodePembayaran: json['metode_pembayaran']?.toString() ??
          json['payment_method']?.toString(),
      buktiBayarUrl: json['bukti_bayar_url']?.toString() ??
          json['proof_url']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      expiredAt: json['expired_at'] != null
          ? DateTime.tryParse(json['expired_at'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        noTransaksi,
        jumlahKoin,
        totalHarga,
        status,
        createdAt,
      ];
}
