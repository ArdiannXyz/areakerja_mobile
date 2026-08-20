import 'package:equatable/equatable.dart';

enum TipeNotifikasi {
  lamaran,
  interview,
  lowonganBaru,
  koinPembayaran,
  sistem,
  tawaran;

  static TipeNotifikasi fromString(String? type) {
    switch (type?.toLowerCase().trim()) {
      case 'interview':
      case 'wawancara':
        return TipeNotifikasi.interview;
      case 'lowongan_baru':
      case 'job':
        return TipeNotifikasi.lowonganBaru;
      case 'pembayaran':
      case 'koin':
      case 'transaksi':
        return TipeNotifikasi.koinPembayaran;
      case 'tawaran':
        return TipeNotifikasi.tawaran;
      case 'sistem':
      case 'info':
        return TipeNotifikasi.sistem;
      case 'lamaran':
      default:
        return TipeNotifikasi.lamaran;
    }
  }
}

class NotifikasiModel extends Equatable {
  final String id;
  final String judul;
  final String pesan;
  final TipeNotifikasi tipe;
  final bool isRead;
  final DateTime createdAt;
  final String? targetId;
  final String? targetRoute;

  const NotifikasiModel({
    required this.id,
    required this.judul,
    required this.pesan,
    required this.tipe,
    this.isRead = false,
    required this.createdAt,
    this.targetId,
    this.targetRoute,
  });

  factory NotifikasiModel.fromJson(Map<String, dynamic> json) {
    return NotifikasiModel(
      id: json['id']?.toString() ?? '',
      judul: json['judul']?.toString() ?? json['title']?.toString() ?? '',
      pesan: json['pesan']?.toString() ?? json['message']?.toString() ?? '',
      tipe: TipeNotifikasi.fromString(json['tipe']?.toString() ?? json['type']?.toString()),
      isRead: json['is_read'] == true || json['read_at'] != null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString()) ?? DateTime.now()
          : DateTime.now(),
      targetId: json['target_id']?.toString(),
      targetRoute: json['target_route']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'pesan': pesan,
      'tipe': tipe.name,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'target_id': targetId,
      'target_route': targetRoute,
    };
  }

  NotifikasiModel copyWith({
    String? id,
    String? judul,
    String? pesan,
    TipeNotifikasi? tipe,
    bool? isRead,
    DateTime? createdAt,
    String? targetId,
    String? targetRoute,
  }) {
    return NotifikasiModel(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      pesan: pesan ?? this.pesan,
      tipe: tipe ?? this.tipe,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      targetId: targetId ?? this.targetId,
      targetRoute: targetRoute ?? this.targetRoute,
    );
  }

  @override
  List<Object?> get props => [id, judul, pesan, tipe, isRead, createdAt, targetId, targetRoute];
}
