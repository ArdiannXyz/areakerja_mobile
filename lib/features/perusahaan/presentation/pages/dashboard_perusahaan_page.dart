import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../pages/kelola_lowongan_page.dart';
import '../pages/koin_page.dart';
import '../pages/lamaran_masuk_page.dart';
import '../pages/profil_perusahaan_page.dart';
import '../widgets/company_home_tab.dart';

class DashboardPerusahaanPage extends StatefulWidget {
  const DashboardPerusahaanPage({super.key});

  @override
  State<DashboardPerusahaanPage> createState() =>
      _DashboardPerusahaanPageState();
}

class _DashboardPerusahaanPageState extends State<DashboardPerusahaanPage> {
  int _currentIndex = 0;

  /// Navigasi ke tab tertentu (dipanggil dari child widget)
  void _navigateToTab(int index) {
    if (index >= 0 && index < 5) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/login',
            (route) => false,
          );
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          // IndexedStack mempertahankan state tiap tab
          body: IndexedStack(
            index: _currentIndex,
            children: [
              // Tab 0: Home
              CompanyHomeTab(onNavigateTab: _navigateToTab),

              // Tab 1: Lowongan
              const KelolaLowonganPage(),

              // Tab 2: Pelamar
              const LamaranMasukPage(),

              // Tab 3: Koin
              const KoinPage(),

              // Tab 4: Profil
              const ProfilPerusahaanPage(),
            ],
          ),
          bottomNavigationBar: _CompanyBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ),
      ),
    );
  }
}

// ─── Bottom Navigation Bar ────────────────────────────────────────────────────

class _CompanyBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CompanyBottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const int itemCount = 5;
    const activeColor = Color(0xFFFF5E14);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.05), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 66,
          child: Stack(
            children: [
              // 1. Sliding Active Capsule Highlight Background (Exact Grid Alignment)
              AnimatedAlign(
                duration: const Duration(milliseconds: 320),
                curve: Curves.fastOutSlowIn,
                alignment: Alignment(-1.0 + (currentIndex * (2.0 / (itemCount - 1))), 0.0),
                child: FractionallySizedBox(
                  widthFactor: 1.0 / itemCount,
                  heightFactor: 1.0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            activeColor.withValues(alpha: 0.15),
                            activeColor.withValues(alpha: 0.07),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: activeColor.withValues(alpha: 0.18),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 2. Navigation Items Row
              Row(
                children: [
                  _buildNavItem(
                    index: 0,
                    label: 'Beranda',
                    activeIcon: Icons.home_rounded,
                    inactiveIcon: Icons.home_outlined,
                  ),
                  _buildNavItem(
                    index: 1,
                    label: 'Lowongan',
                    activeIcon: Icons.work_rounded,
                    inactiveIcon: Icons.work_outline_rounded,
                  ),
                  _buildNavItem(
                    index: 2,
                    label: 'Pelamar',
                    activeIcon: Icons.people_rounded,
                    inactiveIcon: Icons.people_outline_rounded,
                  ),
                  _buildNavItem(
                    index: 3,
                    label: 'Koin',
                    activeIcon: Icons.monetization_on_rounded,
                    inactiveIcon: Icons.monetization_on_outlined,
                  ),
                  _buildNavItem(
                    index: 4,
                    label: 'Profil',
                    activeIcon: Icons.person_rounded,
                    inactiveIcon: Icons.person_outline_rounded,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData activeIcon,
    required IconData inactiveIcon,
  }) {
    final isSelected = currentIndex == index;
    const activeColor = Color(0xFFFF5E14);
    const inactiveColor = Color(0xFF64748B);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(index),
          splashColor: activeColor.withValues(alpha: 0.12),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: isSelected ? 1.10 : 1.0,
                  duration: const Duration(milliseconds: 280),
                  curve: Curves.easeOutBack,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    transitionBuilder: (child, anim) => ScaleTransition(
                      scale: anim,
                      child: FadeTransition(
                        opacity: anim,
                        child: child,
                      ),
                    ),
                    child: Icon(
                      isSelected ? activeIcon : inactiveIcon,
                      key: ValueKey(isSelected),
                      color: isSelected ? activeColor : inactiveColor,
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 240),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10.5,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? activeColor : inactiveColor,
                        letterSpacing: isSelected ? -0.15 : -0.1,
                      ),
                      maxLines: 1,
                      child: Text(label),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
