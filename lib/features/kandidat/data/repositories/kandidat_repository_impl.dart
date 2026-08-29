import 'package:dartz/dartz.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../models/divisi_model.dart';
import '../models/profil_kandidat_model.dart';

abstract class KandidatRepository {
  Future<Either<Failure, List<DivisiModel>>> getDivisiList();
  Future<Either<Failure, KandidatProgramModel>> getStatusProgram();
  Future<Either<Failure, Map<String, dynamic>>> daftarKandidat({
    required String divisiId,
    required String paymentChannelId,
  });
}

class KandidatRepositoryImpl implements KandidatRepository {
  final ApiClient _apiClient;

  KandidatRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<DivisiModel>>> getDivisiList() async {
    // TODO: Ganti dengan API endpoint saat tersedia: GET /pelamar/divisi
    // Saat ini menggunakan mock data
    try {
      // Coba hit API dulu
      final response = await _apiClient.get(ApiEndpoints.divisiList);
      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => DivisiModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
    } catch (_) {
      // Fallback ke mock jika endpoint belum tersedia
    }

    // Mock data — hapus saat API tersedia
    return Right(_getMockDivisiList());
  }

  @override
  Future<Either<Failure, KandidatProgramModel>> getStatusProgram() async {
    // TODO: Ganti dengan API endpoint saat tersedia: GET /pelamar/kandidat-status
    try {
      final response = await _apiClient.get(ApiEndpoints.kandidatStatus);
      if (response.data is Map) {
        final data = response.data['data'] is Map
            ? response.data['data'] as Map<String, dynamic>
            : response.data as Map<String, dynamic>;
        return Right(KandidatProgramModel.fromJson(data));
      }
    } catch (_) {
      // Fallback ke mock jika endpoint belum tersedia
    }

    // Mock data — menunjukkan user belum mendaftar
    // TODO: Ganti dengan data dari API saat endpoint tersedia
    return const Right(
      KandidatProgramModel(
        statusProgram: StatusProgram.belumDaftar,
      ),
    );
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> daftarKandidat({
    required String divisiId,
    required String paymentChannelId,
  }) async {
    try {
      // POST /pelamar/upgrade-kandidat
      // TODO: Konfirmasi format request body dengan backend
      final response = await _apiClient.post(
        ApiEndpoints.upgradeKandidat,
        data: {
          'divisi_id': divisiId,
          'payment_channel_id': paymentChannelId,
          // Alternatif field name jika backend berbeda:
          // 'division_id': divisiId,
          // 'payment_method_id': paymentChannelId,
        },
      );

      if (response.data is Map<String, dynamic>) {
        return Right(response.data as Map<String, dynamic>);
      }
      return const Left(ServerFailure(message: 'Format respons tidak valid.'));
    } catch (e) {
      return Left(ServerFailure(message: 'Gagal mendaftar kandidat: $e'));
    }
  }

  // =========================================================================
  // MOCK DATA — Hapus atau komentari saat API tersedia
  // =========================================================================
  List<DivisiModel> _getMockDivisiList() {
    return [
      const DivisiModel(
        id: 'div_1',
        nama: 'Programmer',
        deskripsi: 'Pengembangan aplikasi web dan mobile',
        jumlahDeposit: 200000,
        biayaAdmin: 2000,
      ),
      const DivisiModel(
        id: 'div_2',
        nama: 'Videographer',
        deskripsi: 'Produksi konten video profesional',
        jumlahDeposit: 200000,
        biayaAdmin: 2000,
      ),
      const DivisiModel(
        id: 'div_3',
        nama: 'Human Resource',
        deskripsi: 'Manajemen sumber daya manusia',
        jumlahDeposit: 200000,
        biayaAdmin: 2000,
      ),
      const DivisiModel(
        id: 'div_4',
        nama: 'UI/UX Design',
        deskripsi: 'Desain antarmuka dan pengalaman pengguna',
        jumlahDeposit: 200000,
        biayaAdmin: 2000,
      ),
      const DivisiModel(
        id: 'div_5',
        nama: 'Desain Grafis',
        deskripsi: 'Desain visual dan branding',
        jumlahDeposit: 200000,
        biayaAdmin: 2000,
      ),
      const DivisiModel(
        id: 'div_6',
        nama: 'Digital Marketing',
        deskripsi: 'Pemasaran digital dan media sosial',
        jumlahDeposit: 200000,
        biayaAdmin: 2000,
      ),
      const DivisiModel(
        id: 'div_7',
        nama: 'Admin',
        deskripsi: 'Administrasi dan tata kelola kantor',
        jumlahDeposit: 200000,
        biayaAdmin: 2000,
      ),
    ];
  }
}
