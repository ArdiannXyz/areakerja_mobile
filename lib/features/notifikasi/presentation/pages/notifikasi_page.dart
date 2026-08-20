import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../data/models/notifikasi_model.dart';
import '../bloc/notifikasi_bloc.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() => _NotifikasiPageState();
}

class _NotifikasiPageState extends State<NotifikasiPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<NotifikasiBloc>().add(const FetchNotifikasiEvent());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            Row(
              children: [
                _buildNotificationIcon(notif.tipe),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notif.judul, style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                      Text(DateFormatter.timeAgo(notif.createdAt), style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              notif.pesan,
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(TipeNotifikasi tipe) {
    IconData icon;
    Color color;
    Color bg;

    switch (tipe) {
      case TipeNotifikasi.interview:
        icon = Icons.calendar_month_rounded;
        color = const Color(0xFFD97706);
        bg = const Color(0xFFFEF3C7);
        break;
      case TipeNotifikasi.lamaran:
        icon = Icons.send_rounded;
        color = AppColors.accent;
        bg = AppColors.infoLight;
        break;
      case TipeNotifikasi.koinPembayaran:
        icon = Icons.monetization_on_rounded;
        color = AppColors.primary;
        bg = AppColors.primarySurface;
        break;
      case TipeNotifikasi.lowonganBaru:
        icon = Icons.work_outline_rounded;
        color = AppColors.teal;
        bg = AppColors.tealLight;
        break;
      case TipeNotifikasi.tawaran:
        icon = Icons.stars_rounded;
        color = AppColors.roleKandidat;
        bg = const Color(0xFFF3E8FF);
        break;
      case TipeNotifikasi.sistem:
        icon = Icons.info_outline_rounded;
        color = AppColors.textSecondary;
        bg = AppColors.divider;
        break;
    }

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Notifikasi', style: AppTextStyles.heading3),
        actions: [
          IconButton(
            tooltip: 'Tandai semua dibaca',
            icon: const Icon(Icons.done_all_rounded, color: AppColors.primary),
            onPressed: () {
              context.read<NotifikasiBloc>().add(const MarkAllNotifikasiReadEvent());
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua notifikasi ditandai sudah dibaca')),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Belum Dibaca'),
          ],
        ),
      ),
      body: BlocBuilder<NotifikasiBloc, NotifikasiState>(
        builder: (context, state) {
          if (state is NotifikasiLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            );
          }

          if (state is NotifikasiLoaded) {
            final allNotifs = state.notifications;
            final unreadNotifs = state.notifications.where((n) => !n.isRead).toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildList(allNotifs, 'Belum ada notifikasi saat ini.'),
                _buildList(unreadNotifs, 'Tidak ada notifikasi yang belum dibaca.'),
              ],
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

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildList(List<NotifikasiModel> list, String emptyMsg) {
    if (list.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.notifications_off_outlined,
        title: 'Kotak Masuk Bersih',
        message: emptyMsg,
      );
    }

    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async {
        context.read<NotifikasiBloc>().add(const FetchNotifikasiEvent());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: list.length,
        separatorBuilder: (_, _) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final notif = list[index];

          return Container(
            decoration: BoxDecoration(
              color: notif.isRead ? Colors.white : const Color(0xFFFFF9F5),
              borderRadius: AppDimensions.borderRadiusL,
              border: Border.all(
                color: notif.isRead ? AppColors.border : AppColors.primary.withValues(alpha: 0.3),
                width: notif.isRead ? 1 : 1.2,
              ),
              boxShadow: AppDimensions.cardShadow,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: AppDimensions.borderRadiusL,
              child: InkWell(
                onTap: () => _onNotificationTap(notif),
                borderRadius: AppDimensions.borderRadiusL,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildNotificationIcon(notif.tipe),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    notif.judul,
                                    style: AppTextStyles.labelLarge.copyWith(
                                      fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (!notif.isRead) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              notif.pesan,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: notif.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormatter.timeAgo(notif.createdAt),
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
