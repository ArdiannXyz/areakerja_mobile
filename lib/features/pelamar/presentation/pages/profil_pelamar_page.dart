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

class ProfilPelamarPage extends StatelessWidget {
  const ProfilPelamarPage({super.key});

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
            title: Text('Profil Pengguna', style: AppTextStyles.heading3),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                onPressed: () => Navigator.of(context).pushNamed('/notifikasi'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Avatar & Info Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDimensions.borderRadiusXL,
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppDimensions.cardShadow,
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: AppColors.primarySurface,
                        child: Text(
                          (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        user?.name ?? 'Nama Pengguna',
                        style: AppTextStyles.heading2.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? 'email@example.com',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 10),
                      const RoleChip(role: UserRole.pelamar),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Menu Options
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppDimensions.borderRadiusXL,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _ProfileMenuItem(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'Lowongan Tersimpan',
                        onTap: () {
                          Navigator.of(context).pushNamed('/lowongan/daftar');
                        },
                      ),
                      const Divider(height: 1),
                      _ProfileMenuItem(
                        icon: Icons.notifications_outlined,
                        title: 'Pusat Notifikasi',
                        onTap: () {
                          Navigator.of(context).pushNamed('/notifikasi');
                        },
                      ),
                      const Divider(height: 1),
                      _ProfileMenuItem(
                        icon: Icons.help_outline_rounded,
                        title: 'Bantuan & FAQ',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Pusat Bantuan AreaKerja')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

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
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title, style: AppTextStyles.labelLarge),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}
