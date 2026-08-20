import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../models/lamaran_model.dart';
import '../models/profil_pelamar_model.dart';

abstract class PelamarRepository {
  Future<Either<Failure, ProfilPelamarModel>> updateProfile(Map<String, dynamic> data);
  Future<Either<Failure, String>> uploadCv({required String filePath, required String fileName});
  Future<Either<Failure, List<LamaranModel>>> getMyApplications();
  Future<Either<Failure, List<LowonganModel>>> getSavedJobs();
}

class PelamarRepositoryImpl implements PelamarRepository {
  final ApiClient _apiClient;

  PelamarRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, ProfilPelamarModel>> updateProfile(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.updatePelamarProfile,
        data: data,
      );

      if (response.data is Map<String, dynamic>) {
        final res = response.data as Map<String, dynamic>;
        final profileData = res['data'] is Map<String, dynamic>
            ? res['data'] as Map<String, dynamic>
            : (res['profile'] is Map<String, dynamic> ? res['profile'] as Map<String, dynamic> : res);
        return Right(ProfilPelamarModel.fromJson(profileData));
      }
      return const Left(ServerFailure(message: 'Format data tidak valid.'));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal memperbarui profil: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadCv({required String filePath, required String fileName}) async {
    try {
      final formData = FormData.fromMap({
        'cv': await MultipartFile.fromFile(filePath, filename: fileName),
      });

      final response = await _apiClient.post(
        ApiEndpoints.uploadPelamarCv,
        data: formData,
      );

      final msg = response.data is Map && response.data['message'] != null
          ? response.data['message'].toString()
          : 'CV berhasil diunggah.';
      return Right(msg);
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal mengunggah CV: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LamaranModel>>> getMyApplications() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.myApplications);
      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => LamaranModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return const Right([]);
    } catch (e) {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, List<LowonganModel>>> getSavedJobs() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.savedJobs);
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
}
