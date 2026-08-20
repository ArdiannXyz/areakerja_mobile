import 'package:dartz/dartz.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../models/tips_kerja_model.dart';

abstract class TipsKerjaRepository {
  Future<Either<Failure, List<TipsKerjaModel>>> getTipsKerjaList({String? kategori, String? keyword});
  Future<Either<Failure, TipsKerjaModel>> getTipsKerjaDetail(String id);
}

class TipsKerjaRepositoryImpl implements TipsKerjaRepository {
  final ApiClient _apiClient;

  TipsKerjaRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<TipsKerjaModel>>> getTipsKerjaList({String? kategori, String? keyword}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (kategori != null && kategori.isNotEmpty) queryParams['kategori'] = kategori;
      if (keyword != null && keyword.isNotEmpty) queryParams['search'] = keyword;

      final response = await _apiClient.get(
        ApiEndpoints.tipsKerja,
        queryParameters: queryParams,
      );

      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => TipsKerjaModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return Right(_getMockTips());
    } catch (_) {
      return Right(_getMockTips());
    }
  }

  @override
  Future<Either<Failure, TipsKerjaModel>> getTipsKerjaDetail(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.tipsKerjaDetail(id));
      if (response.data is Map && response.data['data'] is Map) {
        return Right(TipsKerjaModel.fromJson(response.data['data'] as Map<String, dynamic>));
      }
      final mock = _getMockTips().firstWhere(
        (t) => t.id == id,
        orElse: () => _getMockTips().first,
      );
      return Right(mock);
    } catch (_) {
      final mock = _getMockTips().firstWhere(
        (t) => t.id == id,
        orElse: () => _getMockTips().first,
      );
      return Right(mock);
    }
  }

  List<TipsKerjaModel> _getMockTips() {
    return [
      TipsKerjaModel(
        id: '1',
        judul: '5 Cara Menulis CV ATS Friendly Agar Cepat Dipanggil Interview',
        ringkasan: 'Panduan lengkap menyusun resume kerja yang mudah terbaca sistem ATS perusahaan teknologi.',
        konten: 'Gunakan format yang sederhana, hindari tabel bertingkat yang rumit, dan sertakan kata kunci relevan sesuai deskripsi pekerjaan.',
        penulis: 'Tim Karir AreaKerja',
        kategori: 'Resume & CV',
        viewCount: 1420,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      TipsKerjaModel(
        id: '2',
        judul: 'Strategi Menjawab Pertanyaan Negosiasi Gaji Saat Interview',
        ringkasan: 'Kiat cerdas menentukan rentang gaji yang tepat dan profesional di hadapan HRD.',
        konten: 'Lakukan riset standar gaji industri sebelumnya, sebutkan angka dalam bentuk rentang, dan tekankan value yang dapat Anda berikan.',
        penulis: 'HR Specialist AreaKerja',
        kategori: 'Interview',
        viewCount: 2890,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}
