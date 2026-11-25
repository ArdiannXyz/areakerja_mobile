import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/notification_bell.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/perusahaan_bloc.dart';
import '../bloc/koin_bloc.dart';
import 'coin_balance_card.dart';
import 'quick_action_grid.dart';
import 'recruitment_stats_section.dart';

class CompanyHomeTab extends StatefulWidget {
  /// Callback untuk navigasi tab — diberikan dari parent (DashboardPerusahaanPage)
  final void Function(int tabIndex) onNavigateTab;

  const CompanyHomeTab({
    super.key,
    required this.onNavigateTab,
  });

  @override
  State<CompanyHomeTab> createState() => _CompanyHomeTabState();
}

class _CompanyHomeTabState extends State<CompanyHomeTab> {
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    context.read<PerusahaanBloc>().add(const FetchDashboardEvent());
    context.read<KoinBloc>().add(const FetchKoinBalanceEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is Authenticated ? authState.user : null;
        final companyName = user?.companyName ?? user?.name ?? 'Perusahaan';

        return RefreshIndicator(
          onRefresh: () async {
            _fetchData();
            // Optional: wait a moment or wait for states
            await Future.delayed(const Duration(milliseconds: 800));
          },
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            slivers: [
              // ── Sticky Header ────────────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildHeader(context, companyName),
              ),

              // ── Body Sections ────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.spaceXL,
                  0,
                  AppDimensions.spaceXL,
                  AppDimensions.space3XL,
                ),
                sliver: SliverToBoxAdapter(
                  child: BlocBuilder<PerusahaanBloc, PerusahaanState>(
                    builder: (context, perusahaanState) {
                      // Koin Bloc Builder untuk koin
                      return BlocBuilder<KoinBloc, KoinState>(
                        builder: (context, koinState) {
                          // Extract Saldo
                          int saldoKoin = 0;
                          if (koinState is KoinBalanceLoaded) {
                            saldoKoin = koinState.saldoKoin;
                          } else if (koinState is KoinPageLoaded) {
                            saldoKoin = koinState.saldoKoin;
                          }

                          // Default stats
                          int lowonganAktif = 0;
                          int totalPelamar = 0;
                          int sedangDiproses = 0;
                          int diterima = 0;
                          
                          // Mock for recent items since API might not return these yet or we need to map them
                          // TODO: ganti dengan data real dari DashboardLoaded jika tersedia

                          if (perusahaanState is DashboardLoaded) {
                            lowonganAktif = perusahaanState.dashboard.activeJobs;
                            totalPelamar = perusahaanState.dashboard.totalApplicants;
                            sedangDiproses = perusahaanState.dashboard.pendingApplicants + perusahaanState.dashboard.interviewedApplicants;
                            diterima = perusahaanState.dashboard.hiredApplicants;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Coin Balance Card
                              CoinBalanceCard(
                                saldoKoin: saldoKoin,
                                onTapCard: () => widget.onNavigateTab(3),
                                onBeliKoin: () => widget.onNavigateTab(3),
                              ),
                              const SizedBox(height: AppDimensions.space2XL),

                              // Recruitment Stats
                              const _SectionHeader(title: 'Ringkasan Rekrutmen'),
                              const SizedBox(height: AppDimensions.spaceM),
                              RecruitmentStatsSection(
                                lowonganAktif: lowonganAktif,
                                totalPelamar: totalPelamar,
                                sedangDiproses: sedangDiproses,
                                diterima: diterima,
                              ),
                              const SizedBox(height: AppDimensions.space2XL),

                              // Quick Actions
                              const _SectionHeader(title: 'Aksi Cepat'),
                              const SizedBox(height: AppDimensions.spaceM),
                              QuickActionGrid(
                                onBuatLowongan: () {
                                  // TODO: Navigasi ke Form Buat Lowongan via Navigator
                                },
                                onBeliKoin: () => widget.onNavigateTab(3),
                                onLihatPelamar: () => widget.onNavigateTab(2),
                                onLowonganSaya: () => widget.onNavigateTab(1),
                              ),
                              const SizedBox(height: AppDimensions.space2XL),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'Selamat Pagi,';
    if (hour >= 11 && hour < 15) return 'Selamat Siang,';
    if (hour >= 15 && hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  Widget _buildHeader(BuildContext context, String companyName) {
    return Container(
      color: const Color(0xFFFF5E14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background decorative circles
          Positioned(
            top: -30,
            right: -20,
            child: IgnorePointer(
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            left: -40,
            child: IgnorePointer(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.07),
                ),
              ),
            ),
          ),
          
          // Main Content
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Company Avatar
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.apartment_rounded,
                      color: Color(0xFFFF5E14),
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Greeting Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getGreeting(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        companyName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Kelola rekrutmen perusahaanmu',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Notification Bell (White tint)
                Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
                  child: const NotificationBell(unreadCount: 0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

