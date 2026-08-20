import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/models/lowongan_model.dart';
import '../bloc/lowongan_bloc.dart';

class DetailLowonganPage extends StatefulWidget {
  final LowonganModel lowongan;

  const DetailLowonganPage({super.key, required this.lowongan});

  @override
  State<DetailLowonganPage> createState() => _DetailLowonganPageState();
}

class _DetailLowonganPageState extends State<DetailLowonganPage> {
  late LowonganModel _job;

  @override
  void initState() {
    super.initState();
    _job = widget.lowongan;
  }

  void _toggleBookmark() {
    context.read<LowonganBloc>().add(ToggleFavoriteJobEvent(_job.id));
    setState(() {
      _job = _job.copyWith(isFavorit: !_job.isFavorit);
    });
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
        title: Text(
          'Detail Lowongan',
          style: AppTextStyles.heading3,
        ),
        actions: [
          IconButton(
            icon: Icon(
              _job.isFavorit ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: _job.isFavorit ? AppColors.primary : AppColors.textSecondary,
            ),
            onPressed: _toggleBookmark,
          ),
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textSecondary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tautan lowongan telah disalin')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company & Position Header Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppDimensions.borderRadiusXL,
                border: Border.all(color: AppColors.border),
                boxShadow: AppDimensions.cardShadow,
              ),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                    ),
                    child: Center(
                      child: Text(
                        _job.namaPerusahaan.isNotEmpty ? _job.namaPerusahaan[0].toUpperCase() : 'A',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  Text(
                    _job.judul,
                    style: AppTextStyles.heading2.copyWith(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _job.namaPerusahaan,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(_job.lokasi, style: AppTextStyles.bodySmall),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),

                  // Info grid (Gaji, Tipe, Pelamar)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _JobInfoItem(
                        icon: Icons.payments_outlined,
                        title: 'Gaji Bulanan',
                        value: _job.rentangGaji,
                        color: AppColors.primary,
                      ),
                      Container(width: 1, height: 36, color: AppColors.border),
                      _JobInfoItem(
                        icon: Icons.work_outline_rounded,
                        title: 'Tipe Kerja',
                        value: _job.tipePekerjaan,
                        color: AppColors.accent,
                      ),
                      Container(width: 1, height: 36, color: AppColors.border),
                      _JobInfoItem(
                        icon: Icons.people_outline_rounded,
                        title: 'Pelamar',
                        value: '${_job.jumlahPelamar} Orang',
                        color: AppColors.teal,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.space2XL),

            // Deskripsi Pekerjaan
            _DetailSection(
              title: 'Deskripsi Pekerjaan',
              child: Text(
                _job.deskripsi,
                style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
              ),
            ),
            const SizedBox(height: AppDimensions.spaceXL),

            // Kualifikasi & Persyaratan
            if (_job.persyaratan.isNotEmpty) ...[
              _DetailSection(
                title: 'Persyaratan & Kualifikasi',
                child: Column(
                  children: _job.persyaratan.map((req) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              req,
                              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXL),
            ],

            // Benefit & Fasilitas
            if (_job.benefit.isNotEmpty) ...[
              _DetailSection(
                title: 'Benefit & Fasilitas',
                child: Column(
                  children: _job.benefit.map((ben) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              ben,
                              style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXL),
            ],

            // Batas Lamaran
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: AppDimensions.borderRadiusM,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Dipublikasikan: ${DateFormatter.formatDate(_job.createdAt)}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80), // Space for sticky bottom bar
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              OutlinedButton(
                onPressed: _toggleBookmark,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(50, AppDimensions.buttonHeight),
                  padding: EdgeInsets.zero,
                  side: BorderSide(
                    color: _job.isFavorit ? AppColors.primary : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppDimensions.borderRadiusM,
                  ),
                ),
                child: Icon(
                  _job.isFavorit ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
                  color: _job.isFavorit ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Lamar Sekarang',
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/lowongan/lamar',
                      arguments: {'lowongan': _job},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JobInfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _JobInfoItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(title, style: AppTextStyles.caption.copyWith(fontSize: 11)),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTextStyles.labelLarge.copyWith(fontSize: 12.5),
        ),
      ],
    );
  }
}

class _DetailSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _DetailSection({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppDimensions.borderRadiusL,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.heading3.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
