import 'package:equatable/equatable.dart';

// Status program yang mengikuti business flow
enum StatusProgram {
  belumDaftar,
  menungguVerifikasiData,
  menungguPembayaran,
  menungguVerifikasiBayar,
  pembayaranTerverifikasi,
  terdaftarProgram,
  menungguPelatihan,
  sedangPelatihan,
  pelatihanSelesai,
  menungguEvaluasi,
  lulus,
  tidakLulus,
  kandidatSiapKerja,
  depositMenungguPengembalian,
  depositTelahDikembalikan;

  static StatusProgram fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'belum_daftar':
      case 'belum daftar':
        return StatusProgram.belumDaftar;
      case 'menunggu_verifikasi_data':
        return StatusProgram.menungguVerifikasiData;
      case 'menunggu_pembayaran':
      case 'pending_payment':
        return StatusProgram.menungguPembayaran;
      case 'menunggu_verifikasi_bayar':
      case 'pending_verification':
        return StatusProgram.menungguVerifikasiBayar;
      case 'pembayaran_terverifikasi':
      case 'payment_verified':
        return StatusProgram.pembayaranTerverifikasi;
      case 'terdaftar_program':
      case 'registered':
        return StatusProgram.terdaftarProgram;
      case 'menunggu_pelatihan':
      case 'waiting_training':
        return StatusProgram.menungguPelatihan;
      case 'sedang_pelatihan':
      case 'training':
        return StatusProgram.sedangPelatihan;
      case 'pelatihan_selesai':
      case 'training_completed':
        return StatusProgram.pelatihanSelesai;
      case 'menunggu_evaluasi':
      case 'pending_evaluation':
        return StatusProgram.menungguEvaluasi;
      case 'lulus':
      case 'passed':
        return StatusProgram.lulus;
      case 'tidak_lulus':
      case 'failed':
        return StatusProgram.tidakLulus;
      case 'kandidat_siap_kerja':
      case 'kandidat':
      case 'ready':
        return StatusProgram.kandidatSiapKerja;
      case 'deposit_menunggu_pengembalian':
      case 'deposit_pending_refund':
        return StatusProgram.depositMenungguPengembalian;
      case 'deposit_telah_dikembalikan':
      case 'deposit_refunded':
        return StatusProgram.depositTelahDikembalikan;
      default:
        return StatusProgram.belumDaftar;
    }
  }

  String get displayLabel {
    switch (this) {
      case StatusProgram.belumDaftar:
        return 'Belum Mendaftar';
      case StatusProgram.menungguVerifikasiData:
        return 'Menunggu Verifikasi Data';
      case StatusProgram.menungguPembayaran:
        return 'Menunggu Pembayaran';
      case StatusProgram.menungguVerifikasiBayar:
        return 'Menunggu Verifikasi Pembayaran';
      case StatusProgram.pembayaranTerverifikasi:
        return 'Pembayaran Terverifikasi';
      case StatusProgram.terdaftarProgram:
        return 'Terdaftar Program';
      case StatusProgram.menungguPelatihan:
        return 'Menunggu Jadwal Pelatihan';
      case StatusProgram.sedangPelatihan:
        return 'Sedang Mengikuti Pelatihan Offline';
      case StatusProgram.pelatihanSelesai:
        return 'Pelatihan Selesai';
      case StatusProgram.menungguEvaluasi:
        return 'Menunggu Hasil Evaluasi';
      case StatusProgram.lulus:
        return 'Lulus';
      case StatusProgram.tidakLulus:
        return 'Tidak Lulus';
      case StatusProgram.kandidatSiapKerja:
        return 'Kandidat Siap Kerja';
      case StatusProgram.depositMenungguPengembalian:
        return 'Menunggu Pengembalian Deposit';
      case StatusProgram.depositTelahDikembalikan:
        return 'Deposit Telah Dikembalikan';
    }
  }

  bool get isCompleted {
    return index >= StatusProgram.kandidatSiapKerja.index;
  }

  bool get isActive {
    return this != StatusProgram.belumDaftar &&
        this != StatusProgram.kandidatSiapKerja &&
        this != StatusProgram.depositTelahDikembalikan;
  }

  bool get isLulus {
    return this == StatusProgram.lulus ||
        this == StatusProgram.kandidatSiapKerja ||
        this == StatusProgram.depositMenungguPengembalian ||
        this == StatusProgram.depositTelahDikembalikan;
  }
}

class KandidatProgramModel extends Equatable {
  final String? id;
  final String? divisiId;
  final String? divisiNama;
  final StatusProgram statusProgram;
  final int jumlahDeposit;
  final int biayaAdmin;
  final StatusDeposit statusDeposit;
  final DateTime? tanggalDaftar;
  final DateTime? tanggalLulus;
  final DateTime? tanggalDikembalikan;
  final String? transactionId;
  final String? catatanAdmin;

  const KandidatProgramModel({
    this.id,
    this.divisiId,
    this.divisiNama,
    required this.statusProgram,
    this.jumlahDeposit = 200000,
    this.biayaAdmin = 2000,
    this.statusDeposit = StatusDeposit.belum,
    this.tanggalDaftar,
    this.tanggalLulus,
    this.tanggalDikembalikan,
    this.transactionId,
    this.catatanAdmin,
  });

  int get totalPembayaran => jumlahDeposit + biayaAdmin;

  bool get sudahDaftar => statusProgram != StatusProgram.belumDaftar;

  bool get isLulus =>
      statusProgram == StatusProgram.lulus ||
      statusProgram == StatusProgram.kandidatSiapKerja ||
      statusProgram == StatusProgram.depositMenungguPengembalian ||
      statusProgram == StatusProgram.depositTelahDikembalikan;

  factory KandidatProgramModel.fromJson(Map<String, dynamic> json) {
    return KandidatProgramModel(
      id: json['id']?.toString(),
      divisiId: json['divisi_id']?.toString() ?? json['division_id']?.toString(),
      divisiNama: json['divisi_nama']?.toString() ??
          json['division_name']?.toString() ??
          json['divisi']?.toString(),
      statusProgram: StatusProgram.fromString(
          json['status_program']?.toString() ?? json['status']?.toString()),
      jumlahDeposit: _parseAmount(
          json['jumlah_deposit'] ?? json['deposit_amount'] ?? 200000),
      biayaAdmin:
          _parseAmount(json['biaya_admin'] ?? json['admin_fee'] ?? 2000),
      statusDeposit: StatusDeposit.fromString(
          json['status_deposit']?.toString() ??
              json['deposit_status']?.toString()),
      tanggalDaftar: json['tanggal_daftar'] != null
          ? DateTime.tryParse(json['tanggal_daftar'].toString())
          : null,
      tanggalLulus: json['tanggal_lulus'] != null
          ? DateTime.tryParse(json['tanggal_lulus'].toString())
          : null,
      tanggalDikembalikan: json['tanggal_dikembalikan'] != null
          ? DateTime.tryParse(json['tanggal_dikembalikan'].toString())
          : null,
      transactionId:
          json['transaction_id']?.toString() ?? json['payment_id']?.toString(),
      catatanAdmin:
          json['catatan_admin']?.toString() ?? json['notes']?.toString(),
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
        divisiId,
        divisiNama,
        statusProgram,
        jumlahDeposit,
        biayaAdmin,
        statusDeposit,
        tanggalDaftar,
        tanggalLulus,
        tanggalDikembalikan,
        transactionId,
        catatanAdmin,
      ];
}

enum StatusDeposit {
  belum,
  menungguPengembalian,
  telahDikembalikan;

  static StatusDeposit fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'menunggu_pengembalian':
      case 'pending_refund':
      case 'waiting':
        return StatusDeposit.menungguPengembalian;
      case 'telah_dikembalikan':
      case 'refunded':
      case 'returned':
        return StatusDeposit.telahDikembalikan;
      default:
        return StatusDeposit.belum;
    }
  }

  String get displayLabel {
    switch (this) {
      case StatusDeposit.belum:
        return 'Belum Diproses';
      case StatusDeposit.menungguPengembalian:
        return 'Menunggu Pengembalian';
      case StatusDeposit.telahDikembalikan:
        return 'Telah Dikembalikan';
    }
  }
}
