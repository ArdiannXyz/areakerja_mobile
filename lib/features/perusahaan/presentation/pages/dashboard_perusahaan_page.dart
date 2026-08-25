import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/role_constants.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../../shared/widgets/status_chip.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class DashboardPerusahaanPage extends StatelessWidget {
  const DashboardPerusahaanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              'Panel Perusahaan',
              style: AppTextStyles.heading3,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout_rounded, color: AppColors.danger),
                tooltip: 'Keluar',
                onPressed: () => _showLogoutDialog(context),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppDimensions.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company Profile Welcome Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: AppDimensions.borderRadiusXL,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(
                                Icons.apartment_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: AppDimensions.spaceL),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user?.companyName ?? user?.name ?? 'Perusahaan Mitra',
                                    style: AppTextStyles.heading3.copyWith(color: Colors.white),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user?.email ?? '-',
                                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spaceL),
                        const RoleChip(role: UserRole.perusahaan),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space2XL),

                  // Quick Stats
                  Text('Ringkasan Rekrutmen', style: AppTextStyles.heading3),
                  const SizedBox(height: AppDimensions.spaceM),
                  Row(
                    children: [
                      _StatCard(title: 'Lowongan Aktif', count: '12', color: AppColors.primary),
                      const SizedBox(width: 12),
                      _StatCard(title: 'Pelamar Masuk', count: '48', color: AppColors.accent),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.space2XL),

                  // Logout Button
                  PrimaryButton(
                    text: 'Keluar dari Akun',
                    backgroundColor: AppColors.danger,
                    icon: const Icon(Icons.logout_rounded, color: Colors.white, size: 18),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 44),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Red Logout Icon (Left pointing arrow)
              Transform.flip(
                flipX: true,
                child: const Icon(
                  Icons.logout_rounded,
                  size: 50,
                  color: Color(0xFFFF0000),
                ),
              ),
              const SizedBox(height: 16),

              // Confirmation Text
              const Text(
                'Apakah Anda yakin ingin keluar dari\nAreaKerja.com?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons Row (Ya - Green, Tidak - Red)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Button "Ya"
                  SizedBox(
                    width: 88,
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00C05B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.read<AuthBloc>().add(const AuthLogoutRequested());
                      },
                      child: const Text(
                        'Ya',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Button "Tidak"
                  SizedBox(
                    width: 88,
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF0000),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text(
                        'Tidak',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodySmall),
            const SizedBox(height: 6),
            Text(
              count,
              style: AppTextStyles.heading2.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
