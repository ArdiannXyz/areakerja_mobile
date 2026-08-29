import 'package:equatable/equatable.dart';

class DivisiModel extends Equatable {
  final String id;
  final String nama;
  final String? deskripsi;
  final int jumlahDeposit;
  final int biayaAdmin;

  const DivisiModel({
    required this.id,
    required this.nama,
    this.deskripsi,
    required this.jumlahDeposit,
    required this.biayaAdmin,
  });

  int get totalPembayaran => jumlahDeposit + biayaAdmin;

  factory DivisiModel.fromJson(Map<String, dynamic> json) {
    return DivisiModel(
      id: json['id']?.toString() ?? '',
      nama: json['nama']?.toString() ?? json['name']?.toString() ?? '',
      deskripsi:
          json['deskripsi']?.toString() ?? json['description']?.toString(),
      jumlahDeposit:
          _parseAmount(json['jumlah_deposit'] ?? json['deposit_amount'] ?? 200000),
      biayaAdmin: _parseAmount(json['biaya_admin'] ?? json['admin_fee'] ?? 2000),
    );
  }

  static int _parseAmount(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nama': nama,
        'deskripsi': deskripsi,
        'jumlah_deposit': jumlahDeposit,
        'biaya_admin': biayaAdmin,
      };

  @override
  List<Object?> get props => [id, nama, deskripsi, jumlahDeposit, biayaAdmin];
}
