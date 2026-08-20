import 'package:dartz/dartz.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../models/company_applicant_model.dart';
import '../models/company_dashboard_model.dart';

abstract class PerusahaanRepository {
  Future<Either<Failure, CompanyDashboardModel>> getDashboardSummary();
  Future<Either<Failure, List<LowonganModel>>> getMyJobs();
  Future<Either<Failure, LowonganModel>> storeJob(Map<String, dynamic> jobData);
  Future<Either<Failure, List<CompanyApplicantModel>>> getJobApplicants(String jobId);
  Future<Either<Failure, void>> updateApplicantStatus({
    required String applicationId,
    required String status,
  });
}

class PerusahaanRepositoryImpl implements PerusahaanRepository {
  final ApiClient _apiClient;

  PerusahaanRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, CompanyDashboardModel>> getDashboardSummary() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companyDashboard);
      if (response.data is Map<String, dynamic>) {
        final res = response.data as Map<String, dynamic>;
        final data = res['data'] is Map<String, dynamic> ? res['data'] as Map<String, dynamic> : res;
        return Right(CompanyDashboardModel.fromJson(data));
      }
      return const Right(CompanyDashboardModel());
    } catch (e) {
      return const Right(CompanyDashboardModel());
    }
  }

  @override
  Future<Either<Failure, List<LowonganModel>>> getMyJobs() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companyJobs);
      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => LowonganModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return const Right([]);
    } catch (e) {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, LowonganModel>> storeJob(Map<String, dynamic> jobData) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.companyStoreJob,
        data: jobData,
      );

      if (response.data is Map<String, dynamic>) {
        final res = response.data as Map<String, dynamic>;
        final data = res['data'] is Map<String, dynamic> ? res['data'] as Map<String, dynamic> : res;
        return Right(LowonganModel.fromJson(data));
      }
      return const Left(ServerFailure(message: 'Gagal membuat lowongan pekerjaan.'));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal membuat lowongan: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CompanyApplicantModel>>> getJobApplicants(String jobId) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.companyJobApplicants(jobId));
      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => CompanyApplicantModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return const Right([]);
    } catch (e) {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, void>> updateApplicantStatus({
    required String applicationId,
    required String status,
  }) async {
    try {
      await _apiClient.put(
        ApiEndpoints.companyUpdateApplicantStatus(applicationId),
        data: {'status': status},
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memperbarui status pelamar: $e'));
    }
  }
}
