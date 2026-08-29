import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        final companyName =
            user?.companyName ?? user?.name ?? 'Perusahaan Mitra';
        final email = user?.email ?? '-';

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
              backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                title: Text(
                  'Profil Perusahaan',
                  style: GoogleFonts.poppins(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Divider(height: 1, color: AppColors.border),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(AppDimensions.spaceXL),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Profile Hero Card
                    _buildProfileCard(companyName, email),
                    const SizedBox(height: AppDimensions.space2XL),

                        // Menu Items
                        _buildMenuSection(context, perusahaanState),
                        const SizedBox(height: AppDimensions.space2XL),

                        // Logout
                        _buildLogoutButton(context),
                        const SizedBox(height: AppDimensions.spaceXL),
                      ]),
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

  Widget _buildProfileCard(String companyName, String email) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B00), Color(0xFFFF9140)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  companyName,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  email,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primarySurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Perusahaan',
                    style: GoogleFonts.poppins(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context, PerusahaanState state) {
    final menuItems = [
      _MenuItem(
        icon: Icons.business_outlined,
        label: 'Data Perusahaan',
        onTap: () {
          if (state is ProfileLoaded) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<PerusahaanBloc>(),
                  child: EditProfilPerusahaanPage(profile: state.profile),
                ),
              ),
            );
          }
        },
      ),
      _MenuItem(
        icon: Icons.lock_outline_rounded,
        label: 'Ubah Kata Sandi',
        onTap: () {
          // TODO: Navigate to ubah kata sandi
        },
      ),
      _MenuItem(
        icon: Icons.notifications_outlined,
        label: 'Notifikasi',
        onTap: () {
          Navigator.of(context).pushNamed('/notifikasi');
        },
      ),
      _MenuItem(
        icon: Icons.help_outline_rounded,
        label: 'Bantuan & FAQ',
        onTap: () {
          // TODO: Navigate to FAQ
        },
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: menuItems.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == menuItems.length - 1;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.vertical(
                  top: index == 0 ? const Radius.circular(16) : Radius.zero,
                  bottom: isLast ? const Radius.circular(16) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Icon(item.icon, size: 20, color: AppColors.textSecondary),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.label,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: AppColors.textMuted,
                      ),
                    ],
                  ),
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  color: AppColors.border,
                  indent: 50,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showLogoutDialog(context),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.danger,
          side: const BorderSide(color: AppColors.danger),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.logout_rounded, size: 18),
        label: Text(
          'Keluar dari Akun',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
              Transform.flip(
                flipX: true,
                child: const Icon(
                  Icons.logout_rounded,
                  size: 50,
                  color: Color(0xFFFF0000),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Apakah Anda yakin ingin keluar dari\nAreaKerja.com?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        context.read<AuthBloc>().add(const AuthLogoutRequested());
                      },
                      child: Text(
                        'Ya',
                        style: GoogleFonts.poppins(
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
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
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text(
                        'Tidak',
                        style: GoogleFonts.poppins(
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

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    this.onTap,
  });
}
