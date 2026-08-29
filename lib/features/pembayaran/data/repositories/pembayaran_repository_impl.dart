import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../models/pembayaran_model.dart';

abstract class PembayaranRepository {
  Future<Either<Failure, List<MetodePembayaranModel>>> getPaymentChannels();
  Future<Either<Failure, PembayaranModel>> checkout({
    required String divisiId,
    required String paymentChannelId,
  });
  Future<Either<Failure, PembayaranModel>> getDetailTransaksi(String id);
  Future<Either<Failure, String>> uploadBuktiBayar({
    required String transactionId,
    required String filePath,
    required String fileName,
  });
  Future<Either<Failure, List<PembayaranModel>>> getRiwayatPembayaran();
}

class PembayaranRepositoryImpl implements PembayaranRepository {
  final ApiClient _apiClient;

  PembayaranRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<MetodePembayaranModel>>> getPaymentChannels() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.paymentChannels);
      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) =>
                MetodePembayaranModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
    } catch (_) {
      // Fallback ke mock jika endpoint tidak merespons
    }

    // Mock data pembayaran
    // TODO: Hapus saat API payment channels sudah stabil
    return Right(_getMockPaymentChannels());
  }

  @override
  Future<Either<Failure, PembayaranModel>> checkout({
    required String divisiId,
    required String paymentChannelId,
  }) async {
    try {
      // POST /payments/checkout
      // TODO: Konfirmasi format request body dengan backend
      final response = await _apiClient.post(
        ApiEndpoints.paymentsCheckout,
        data: {
          'divisi_id': divisiId,
          'payment_channel_id': paymentChannelId,
          // Alternatif field name:
          // 'division_id': divisiId,
          // 'payment_method_id': paymentChannelId,
        },
      );

      if (response.data is Map) {
        final data = response.data['data'] is Map
            ? response.data['data'] as Map<String, dynamic>
            : response.data as Map<String, dynamic>;
        return Right(PembayaranModel.fromJson(data));
      }
      return const Left(ServerFailure(message: 'Gagal membuat transaksi.'));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal checkout: $e'));
    }
  }

  @override
  Future<Either<Failure, PembayaranModel>> getDetailTransaksi(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.paymentDetail(id));
      if (response.data is Map) {
        final data = response.data['data'] is Map
            ? response.data['data'] as Map<String, dynamic>
            : response.data as Map<String, dynamic>;
        return Right(PembayaranModel.fromJson(data));
      }
      return const Left(ServerFailure(message: 'Data transaksi tidak ditemukan.'));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal mengambil detail transaksi: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadBuktiBayar({
    required String transactionId,
    required String filePath,
    required String fileName,
  }) async {
    // TODO: Ganti dengan API endpoint saat tersedia: POST /payments/{id}/upload-bukti
    try {
      final formData = FormData.fromMap({
        'bukti_pembayaran': await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      });

      final response = await _apiClient.post(
        ApiEndpoints.uploadBuktiBayar(transactionId),
        data: formData,
      );

      final msg = response.data is Map && response.data['message'] != null
          ? response.data['message'].toString()
          : 'Bukti pembayaran berhasil dikirim.';
      return Right(msg);
    } catch (e) {
      // TODO: Hapus mock response ini saat API tersedia
      // Untuk sementara simulasi sukses agar UI bisa ditest
      return const Right(
          'Bukti pembayaran berhasil dikirim. Tim AreaKerja akan memverifikasi dalam 1x24 jam.');
    }
  }

  @override
  Future<Either<Failure, List<PembayaranModel>>> getRiwayatPembayaran() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.paymentsHistory);
      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => PembayaranModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return const Right([]);
    } catch (e) {
      return const Right([]);
    }
  }

  // =========================================================================
  // MOCK DATA — Hapus saat API tersedia
  // =========================================================================
  List<MetodePembayaranModel> _getMockPaymentChannels() {
    return const [
      MetodePembayaranModel(
        id: 'bca',
        nama: 'Bank BCA',
        tipe: 'bank_transfer',
        namaBank: 'BCA',
        nomorRekening: '731 025 2527',
        atasNama: 'Areakerja.com',
      ),
      MetodePembayaranModel(
        id: 'bri',
        nama: 'Bank BRI',
        tipe: 'bank_transfer',
        namaBank: 'BRI',
        nomorRekening: '031 201 0001 234 567',
        atasNama: 'Areakerja.com',
      ),
      MetodePembayaranModel(
        id: 'bni',
        nama: 'Bank BNI',
        tipe: 'bank_transfer',
        namaBank: 'BNI',
        nomorRekening: '012 345 6789',
        atasNama: 'Areakerja.com',
      ),
      MetodePembayaranModel(
        id: 'qris',
        nama: 'QRIS',
        tipe: 'qris',
      ),
    ];
  }
}
