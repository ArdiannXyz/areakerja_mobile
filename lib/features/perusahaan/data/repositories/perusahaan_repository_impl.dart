import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../models/company_applicant_model.dart';
import '../models/company_dashboard_model.dart';
import '../models/koin_model.dart';
import '../models/profil_perusahaan_model.dart';

// ─── Repository Contract ─────────────────────────────────────────────────────

abstract class PerusahaanRepository {
  // Dashboard
  Future<Either<Failure, CompanyDashboardModel>> getDashboardSummary();

  // Profil
  Future<Either<Failure, ProfilPerusahaanModel>> getProfile();
  Future<Either<Failure, ProfilPerusahaanModel>> updateProfile(
      Map<String, dynamic> data);
  Future<Either<Failure, String>> uploadLogo(String filePath);

  // Lowongan
  Future<Either<Failure, List<LowonganModel>>> getMyJobs();
  Future<Either<Failure, LowonganModel>> getJobDetail(String jobId);
  Future<Either<Failure, LowonganModel>> storeJob(Map<String, dynamic> jobData);
  Future<Either<Failure, LowonganModel>> updateJob(
      String jobId, Map<String, dynamic> jobData);
  Future<Either<Failure, void>> toggleJobStatus(String jobId);

  // Kandidat
  Future<Either<Failure, List<CompanyApplicantModel>>> getJobApplicants(
      String jobId);
  Future<Either<Failure, void>> updateApplicantStatus({
    required String applicationId,
    required String status,
    String? catatan,
  });

  // Koin & Transaksi
  Future<Either<Failure, int>> getKoinBalance();
  Future<Either<Failure, List<KoinPackageModel>>> getKoinPackages();
  Future<Either<Failure, List<KoinTransactionModel>>> getTransactionHistory();
  Future<Either<Failure, KoinTransactionModel>> getTransactionDetail(
      String transactionId);
  Future<Either<Failure, KoinTransactionModel>> checkoutKoin({
    required String packageId,
    required String paymentChannelId,
  });
  Future<Either<Failure, void>> uploadBuktiBayar({
    required String transactionId,
    required String filePath,
  });
}

// ─── Repository Implementation ───────────────────────────────────────────────

class PerusahaanRepositoryImpl implements PerusahaanRepository {
  final ApiClient _apiClient;

  PerusahaanRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  // ── Helper: extract data map ──────────────────────────────────────────────

  Map<String, dynamic> _extractData(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      if (responseData['data'] is Map<String, dynamic>) {
        return responseData['data'] as Map<String, dynamic>;
      }
      return responseData;
    }
    return {};
  }

  List<dynamic> _extractList(dynamic responseData) {
    if (responseData is Map && responseData['data'] is List) {
      return responseData['data'] as List;
    }
    if (responseData is List) return responseData;
    return [];
  }

  // ── Dashboard ─────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, CompanyDashboardModel>> getDashboardSummary() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companyDashboard);
      final data = _extractData(response.data);
      return Right(CompanyDashboardModel.fromJson(data));
    } catch (_) {
      return const Right(CompanyDashboardModel());
    }
  }

  // ── Profil ────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, ProfilPerusahaanModel>> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companyProfile);
      final data = _extractData(response.data);
      return Right(ProfilPerusahaanModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memuat profil: $e'));
    }
  }

  @override
  Future<Either<Failure, ProfilPerusahaanModel>> updateProfile(
      Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.companyProfile,
        data: data,
      );
      final resData = _extractData(response.data);
      return Right(ProfilPerusahaanModel.fromJson(resData));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memperbarui profil: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadLogo(String filePath) async {
    try {
      final formData = FormData.fromMap({
        'logo': await MultipartFile.fromFile(filePath),
      });
      final response = await _apiClient.post(
        ApiEndpoints.companyUploadLogo,
        data: formData,
      );
      final data = _extractData(response.data);
      final logoUrl = data['logo_url']?.toString() ?? data['url']?.toString() ?? '';
      return Right(logoUrl);
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal upload logo: $e'));
    }
  }

  // ── Lowongan ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<LowonganModel>>> getMyJobs() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companyJobs);
      final list = _extractList(response.data);
      return Right(
        list.map((e) => LowonganModel.fromJson(e as Map<String, dynamic>)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memuat lowongan: $e'));
    }
  }

  @override
  Future<Either<Failure, LowonganModel>> getJobDetail(String jobId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.companyJobDetail(jobId));
      final data = _extractData(response.data);
      return Right(LowonganModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memuat detail lowongan: $e'));
    }
  }

  @override
  Future<Either<Failure, LowonganModel>> storeJob(
      Map<String, dynamic> jobData) async {
    try {
      final response =
          await _apiClient.post(ApiEndpoints.companyStoreJob, data: jobData);
      final data = _extractData(response.data);
      return Right(LowonganModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal membuat lowongan: $e'));
    }
  }

  @override
  Future<Either<Failure, LowonganModel>> updateJob(
      String jobId, Map<String, dynamic> jobData) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.companyUpdateJob(jobId),
        data: jobData,
      );
      final data = _extractData(response.data);
      return Right(LowonganModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memperbarui lowongan: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> toggleJobStatus(String jobId) async {
    try {
      await _apiClient.post(ApiEndpoints.companyToggleJobStatus(jobId));
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal mengubah status lowongan: $e'));
    }
  }

  // ── Kandidat ──────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<CompanyApplicantModel>>> getJobApplicants(
      String jobId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.companyJobApplicants(jobId));
      final list = _extractList(response.data);
      return Right(
        list
            .map((e) =>
                CompanyApplicantModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memuat pelamar: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateApplicantStatus({
    required String applicationId,
    required String status,
    String? catatan,
  }) async {
    try {
      final payload = <String, dynamic>{
        'status': status,
      };
      if (catatan != null) {
        payload['catatan'] = catatan;
      }
      await _apiClient.put(
        ApiEndpoints.companyUpdateApplicantStatus(applicationId),
        data: payload,
      );
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Gagal memperbarui status pelamar: $e'));
    }
  }

  // ── Koin & Transaksi ──────────────────────────────────────────────────────

  @override
  Future<Either<Failure, int>> getKoinBalance() async {
    try {
      // Coba dari profile dulu, jika gagal coba dashboard
      // TODO: Konfirmasi endpoint koin balance dengan backend
      final response = await _apiClient.get(ApiEndpoints.companyProfile);
      final data = _extractData(response.data);
      final balance = data['saldo_koin'] ??
          data['koin_balance'] ??
          data['coin_balance'] ??
          0;
      if (balance is int) return Right(balance);
      return Right(int.tryParse(balance.toString()) ?? 0);
    } catch (_) {
      // Fallback ke dashboard
      try {
        final response =
            await _apiClient.get(ApiEndpoints.companyDashboard);
        final data = _extractData(response.data);
        final balance = data['saldo_koin'] ??
            data['koin_balance'] ??
            data['coin_balance'] ??
            0;
        if (balance is int) return Right(balance);
        return Right(int.tryParse(balance.toString()) ?? 0);
      } catch (e) {
        return const Right(0);
      }
    }
  }

  @override
  Future<Either<Failure, List<KoinPackageModel>>> getKoinPackages() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.koinPackages);
      final list = _extractList(response.data);
      return Right(
        list
            .map((e) =>
                KoinPackageModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memuat paket koin: $e'));
    }
  }

  @override
  Future<Either<Failure, List<KoinTransactionModel>>>
      getTransactionHistory() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.paymentsHistory);
      final list = _extractList(response.data);
      return Right(
        list
            .map((e) =>
                KoinTransactionModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    } catch (e) {
      return Left(
          ServerFailure(message: 'Gagal memuat riwayat transaksi: $e'));
    }
  }

  @override
  Future<Either<Failure, KoinTransactionModel>> getTransactionDetail(
      String transactionId) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.paymentDetail(transactionId));
      final data = _extractData(response.data);
      return Right(KoinTransactionModel.fromJson(data));
    } catch (e) {
      return Left(
          ServerFailure(message: 'Gagal memuat detail transaksi: $e'));
    }
  }

  @override
  Future<Either<Failure, KoinTransactionModel>> checkoutKoin({
    required String packageId,
    required String paymentChannelId,
  }) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.paymentsCheckout,
        data: {
          'package_id': packageId,
          'payment_channel_id': paymentChannelId,
          'type': 'koin',
        },
      );
      final data = _extractData(response.data);
      return Right(KoinTransactionModel.fromJson(data));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal membuat transaksi: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadBuktiBayar({
    required String transactionId,
    required String filePath,
  }) async {
    try {
      final formData = FormData.fromMap({
        'bukti_bayar': await MultipartFile.fromFile(filePath),
      });
      await _apiClient.post(
        ApiEndpoints.uploadBuktiBayar(transactionId),
        data: formData,
      );
      return const Right(null);
    } catch (e) {
      return Left(
          ServerFailure(message: 'Gagal upload bukti pembayaran: $e'));
    }
  }
}
