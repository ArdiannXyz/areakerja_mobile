import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/perusahaan_bloc.dart';
import 'edit_profil_perusahaan_page.dart';

class ProfilPerusahaanPage extends StatefulWidget {
  const ProfilPerusahaanPage({super.key});

  @override
  State<ProfilPerusahaanPage> createState() => _ProfilPerusahaanPageState();
}

class _ProfilPerusahaanPageState extends State<ProfilPerusahaanPage> {
  @override
  void initState() {
    super.initState();
    context.read<PerusahaanBloc>().add(const FetchProfileEvent());
  }

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
        final companyName = user?.companyName ?? user?.name ?? 'Perusahaan Mitra';
        
        return BlocConsumer<PerusahaanBloc, PerusahaanState>(
          listener: (context, perusahaanState) {
            if (perusahaanState is PerusahaanError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(perusahaanState.message),
                  backgroundColor: AppColors.danger,
                ),
              );
            }
          },
          builder: (context, perusahaanState) {
            return Scaffold(
              backgroundColor: const Color(0xFFF1F3F5),
              body: Column(
                children: [
                  // 1. TOP ORANGE HEADER SECTION
                  _buildOrangeHeader(context, companyName, null),

                  // 2. PROFILE MENU LIST ITEMS
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      children: [
                        // Data Perusahaan
                        _buildProfileCard(
                          icon: Icons.business_outlined,
                          title: 'Data Perusahaan',
                          onTap: () {
                            if (perusahaanState is ProfileLoaded) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: context.read<PerusahaanBloc>(),
                                    child: EditProfilPerusahaanPage(profile: perusahaanState.profile),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),

                        // Ubah Kata Sandi
                        _buildProfileCard(
                          icon: Icons.lock_outline_rounded,
                          title: 'Ubah Kata Sandi',
                          onTap: () {
                            // TODO: Navigate to ubah kata sandi
                          },
                        ),
                        const SizedBox(height: 10),

                        // Notifikasi
                        _buildProfileCard(
                          icon: Icons.notifications_outlined,
                          title: 'Notifikasi',
                          onTap: () {
                            Navigator.of(context).pushNamed('/notifikasi');
                          },
                        ),
                        const SizedBox(height: 10),
                        
                        // Bantuan & FAQ
                        _buildProfileCard(
                          icon: Icons.help_outline_rounded,
                          title: 'Bantuan & FAQ',
                          onTap: () {
                            // TODO: Navigate to FAQ
                          },
                        ),
                        const SizedBox(height: 10),

                        // Keluar
                        _buildProfileCard(
                          icon: Icons.logout_rounded,
                          title: 'Keluar',
                          isDanger: true,
                          hasChevron: false,
                          onTap: () => _showLogoutDialog(context),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // =========================================================================
  // 1. TOP ORANGE HEADER
  // =========================================================================
  Widget _buildOrangeHeader(BuildContext context, String companyName, String? avatarUrl) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFF5E14),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 24,
        right: 24,
        bottom: 26,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar Circle
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl.isNotEmpty
                  ? Image.network(
                      avatarUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(),
                    )
                  : _buildDefaultAvatar(),
            ),
          ),
          const SizedBox(width: 18),

          // User Name & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        companyName,
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Perusahaan Mitra',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: Icon(
          Icons.apartment_rounded,
          color: Color(0xFFFF5E14),
          size: 36,
        ),
      ),
    );
  }

  // =========================================================================
  // 2. PROFILE MENU CARD TILE
  // =========================================================================
  Widget _buildProfileCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
    bool hasChevron = true,
  }) {
    final iconColor = isDanger ? const Color(0xFFEF4444) : const Color(0xFF475569);
    final textColor = isDanger ? const Color(0xFFEF4444) : const Color(0xFF1E293B);
    final splashColor = isDanger
        ? const Color(0xFFEF4444).withValues(alpha: 0.1)
        : const Color(0xFFFF5E14).withValues(alpha: 0.08);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        splashColor: splashColor,
        highlightColor: splashColor.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDanger ? const Color(0xFFFEF2F2) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(icon, color: iconColor, size: 20),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: isDanger ? FontWeight.w600 : FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ),
              if (hasChevron)
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF94A3B8),
                  size: 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 3. LOGOUT DIALOG
  // =========================================================================
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
