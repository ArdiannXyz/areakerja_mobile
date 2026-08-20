import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../data/models/notifikasi_model.dart';
import '../bloc/notifikasi_bloc.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotifikasiBloc>().add(const FetchNotifikasiEvent());
  }

  void _onNotificationTap(NotifikasiModel notif) {
    if (!notif.isRead) {
      context.read<NotifikasiBloc>().add(MarkNotifikasiReadEvent(notif.id));
    }

    if (notif.targetRoute != null && notif.targetRoute!.isNotEmpty) {
      Navigator.of(context).pushNamed(notif.targetRoute!);
    } else {
      _showNotificationDetail(notif);
    }
  }

  void _showNotificationDetail(NotifikasiModel notif) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notif.judul,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatDate(notif.createdAt),
              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              notif.pesan,
              style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF334155)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5E14),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Notifikasi'),
        content: const Text('Tandai dan bersihkan semua notifikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<NotifikasiBloc>().add(const MarkAllNotifikasiReadEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua notifikasi telah dibersihkan')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotifikasiBloc, NotifikasiState>(
      builder: (context, state) {
        int unreadCount = 0;
        List<NotifikasiModel> list = [];

        if (state is NotifikasiLoaded) {
          list = state.notifications;
          unreadCount = state.unreadCount;
        }

        final countDisplay = unreadCount > 0 ? unreadCount : list.length;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left_rounded,
                color: Color(0xFF0F172A),
                size: 30,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            centerTitle: true,
            title: Text(
              'NOTIFIKASI($countDisplay)',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: 0.5,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  color: Color(0xFF0F172A),
                  size: 24,
                ),
                tooltip: 'Bersihkan Notifikasi',
                onPressed: _showClearConfirmDialog,
              ),
            ],
          ),
          body: Column(
            children: [
              // Notifications list
              Expanded(
                child: _buildBody(state, list),
              ),

              // Bottom Button "Tandai Baca"
              _buildBottomButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(NotifikasiState state, List<NotifikasiModel> list) {
    if (state is NotifikasiLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5E14)),
        ),
      );
    }

    if (state is NotifikasiErrorState) {
      return EmptyStateWidget(
        icon: Icons.error_outline_rounded,
        title: 'Gagal Memuat Notifikasi',
        message: state.message,
        actionButtonText: 'Muat Ulang',
        onActionPressed: () {
          context.read<NotifikasiBloc>().add(const FetchNotifikasiEvent());
        },
      );
    }

    if (list.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.notifications_off_outlined,
        title: 'Kotak Masuk Bersih',
        message: 'Belum ada notifikasi saat ini.',
      );
    }

    return RefreshIndicator(
      color: const Color(0xFFFF5E14),
      onRefresh: () async {
        context.read<NotifikasiBloc>().add(const FetchNotifikasiEvent());
      },
      child: ListView.separated(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          thickness: 1,
          color: Color(0xFFE2E8F0),
        ),
        itemBuilder: (context, index) {
          final notif = list[index];
          return _NotificationTile(
            notif: notif,
            onTap: () => _onNotificationTap(notif),
          );
        },
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E14),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                context.read<NotifikasiBloc>().add(const MarkAllNotifikasiReadEvent());
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua notifikasi ditandai sudah dibaca'),
                    backgroundColor: Color(0xFFFF5E14),
                  ),
                );
              },
              child: const Text(
                'Tandai Baca',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// NOTIFICATION ITEM TILE (Matching Screenshot)
// ---------------------------------------------------------------------------
class _NotificationTile extends StatelessWidget {
  final NotifikasiModel notif;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notif,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: Company Logo Box
            _buildCompanyLogo(),

            const SizedBox(width: 14),

            // Middle: Rich Message & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRichMessage(notif.pesan),
                  const SizedBox(height: 8),
                  Text(
                    _formatNotificationDate(notif.createdAt),
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Right: Orange Unread Indicator Dot
            if (!notif.isRead) ...[
              const SizedBox(width: 10),
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF5E14),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyLogo() {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Stylized red/black chevron icon matching Seven Inc logo
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(2),
                      bottomLeft: Radius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: Color(0xFF1E293B),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              'SEVEN INC.',
              style: TextStyle(
                fontSize: 6,
                fontWeight: FontWeight.w900,
                color: Color(0xFF0F172A),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRichMessage(String message) {
    // Rich highlight parser for keywords: "Diterima", "Ditolak", "Seven Inc", "Apple Corp", "Live Seminar"
    final spans = <TextSpan>[];

    // Helper regex pattern
    final regex = RegExp(
      r'(Seven Inc divisi UI/UX Designer|Apple Corp divisi UI/UX Designer|Live Seminar|Apple Corp|Seven Inc|Diterima|Ditolak)',
      caseSensitive: false,
    );

    int lastIndex = 0;
    for (final match in regex.allMatches(message)) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: message.substring(lastIndex, match.start),
          style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.normal),
        ));
      }

      final matchedText = match.group(0)!;
      final lower = matchedText.toLowerCase();

      Color matchColor = const Color(0xFF0F172A);
      FontWeight matchWeight = FontWeight.bold;

      if (lower == 'diterima') {
        matchColor = const Color(0xFF10B981); // Green
      } else if (lower == 'ditolak') {
        matchColor = const Color(0xFFEF4444); // Red
      }

      spans.add(TextSpan(
        text: matchedText,
        style: TextStyle(
          color: matchColor,
          fontWeight: matchWeight,
        ),
      ));

      lastIndex = match.end;
    }

    if (lastIndex < message.length) {
      spans.add(TextSpan(
        text: message.substring(lastIndex),
        style: const TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.normal),
      ));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(
        text: message,
        style: const TextStyle(color: Color(0xFF1E293B)),
      ));
    }

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 13.5,
          color: Color(0xFF1E293B),
          fontFamily: 'Inter',
          height: 1.38,
        ),
        children: spans,
      ),
    );
  }

  String _formatNotificationDate(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }
}
