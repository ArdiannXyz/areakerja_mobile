import 'package:dartz/dartz.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/errors/failures.dart';
import '../models/notifikasi_model.dart';

abstract class NotifikasiRepository {
  Future<Either<Failure, List<NotifikasiModel>>> getNotifikasiList();
  Future<Either<Failure, void>> markAsRead(String id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, int>> getUnreadCount();
}

class NotifikasiRepositoryImpl implements NotifikasiRepository {
  final ApiClient _apiClient;
  List<NotifikasiModel> _notifications = [];

  NotifikasiRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient {
    _initMockNotifications();
  }

  void _initMockNotifications() {
    _notifications = [
      NotifikasiModel(
        id: 'notif_1',
        judul: 'Lamaran Diterima',
        pesan: 'Selamat! Lamaran yang Anda ajukan ke Seven Inc divisi UI/UX Designer Diterima',
        tipe: TipeNotifikasi.interview,
        isRead: false,
        createdAt: DateTime(2024, 7, 28),
        targetRoute: '/lowongan/detail',
      ),
      NotifikasiModel(
        id: 'notif_2',
        judul: 'Lamaran Diterima',
        pesan: 'Selamat! Lamaran yang Anda ajukan ke Seven Inc divisi UI/UX Designer Diterima',
        tipe: TipeNotifikasi.interview,
        isRead: false,
        createdAt: DateTime(2024, 7, 28),
        targetRoute: '/lowongan/detail',
      ),
      NotifikasiModel(
        id: 'notif_3',
        judul: 'Undangan Live Seminar',
        pesan: 'Anda diundang untuk mengikuti Live Seminar',
        tipe: TipeNotifikasi.sistem,
        isRead: false,
        createdAt: DateTime(2024, 7, 28),
      ),
      NotifikasiModel(
        id: 'notif_4',
        judul: 'Lamaran Terkirim',
        pesan: 'Anda mengajukan lamaran ke Apple Corp',
        tipe: TipeNotifikasi.lamaran,
        isRead: false,
        createdAt: DateTime(2024, 7, 28),
      ),
      NotifikasiModel(
        id: 'notif_5',
        judul: 'Status Lamaran',
        pesan: 'Lamaran yang Anda ajukan ke Apple Corp divisi UI/UX Designer Ditolak',
        tipe: TipeNotifikasi.lamaran,
        isRead: false,
        createdAt: DateTime(2024, 7, 28),
      ),
    ];
  }

  @override
  Future<Either<Failure, List<NotifikasiModel>>> getNotifikasiList() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.notifications);
      if (response.data is Map && response.data['data'] is List) {
        final list = (response.data['data'] as List)
            .map((e) => NotifikasiModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Right(list);
      }
      return Right(List.from(_notifications));
    } catch (_) {
      return Right(List.from(_notifications));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String id) async {
    try {
      await _apiClient.put(ApiEndpoints.markNotificationRead(id));
    } catch (_) {}

    _notifications = _notifications.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _apiClient.put(ApiEndpoints.markAllNotificationsRead);
    } catch (_) {}

    _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    return const Right(null);
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.notificationUnreadCount);
      if (response.data is Map && response.data['count'] != null) {
        final count = int.tryParse(response.data['count'].toString());
        if (count != null) return Right(count);
      } else if (response.data is Map && response.data['data'] is Map && response.data['data']['count'] != null) {
        final count = int.tryParse(response.data['data']['count'].toString());
        if (count != null) return Right(count);
      }
    } catch (_) {}

    final unread = _notifications.where((n) => !n.isRead).length;
    return Right(unread);
  }
}
