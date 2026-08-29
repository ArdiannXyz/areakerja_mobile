import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../shared/widgets/notification_bell.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import 'coin_balance_card.dart';
import 'quick_action_grid.dart';
import 'recent_applicant_item.dart';
import 'recent_job_item.dart';
import 'recruitment_stats_section.dart';

// ─── Dummy/Mock Data ─────────────────────────────────────────────────────────
// Ganti dengan data dari API (BLoC/Repository) ketika tersedia.

const _mockSaldoKoin = 850;
const _mockLowonganAktif = 12;
const _mockTotalPelamar = 156;
const _mockSedangDiproses = 24;
const _mockDiterima = 8;

final _mockRecentJobs = [
  const RecentJobData(
    id: '1',
    posisi: 'Software Engineer',
    namaPerusahaan: 'PT Maju Jaya',
    jumlahPelamar: 24,
    isAktif: true,
    tanggalPosting: '25 Agu 2026',
  ),
  const RecentJobData(
    id: '2',
    posisi: 'UI/UX Designer',
    namaPerusahaan: 'PT Maju Jaya',
    jumlahPelamar: 12,
    isAktif: true,
    tanggalPosting: '22 Agu 2026',
  ),
  const RecentJobData(
    id: '3',
    posisi: 'Data Analyst',
    namaPerusahaan: 'PT Maju Jaya',
    jumlahPelamar: 7,
    isAktif: false,
    tanggalPosting: '10 Agu 2026',
  ),
];

final _mockRecentApplicants = [
  const RecentApplicantData(
    id: '1',
    namaKandidat: 'Andi Setiawan',
    posisiDilamar: 'Software Engineer',
    status: 'review',
  ),
  const RecentApplicantData(
    id: '2',
    namaKandidat: 'Budi Santoso',
    posisiDilamar: 'UI/UX Designer',
    status: 'interview',
  ),
  const RecentApplicantData(
    id: '3',
    namaKandidat: 'Siti Rahma',
    posisiDilamar: 'Software Engineer',
    status: 'lolos',
  ),
];
// ─────────────────────────────────────────────────────────────────────────────

class CompanyHomeTab extends StatelessWidget {
  /// Callback untuk navigasi tab — diberikan dari parent (DashboardPerusahaanPage)
  final void Function(int tabIndex) onNavigateTab;

  const CompanyHomeTab({
    super.key,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user = state is Authenticated ? state.user : null;
        final companyName = user?.companyName ?? user?.name ?? 'Perusahaan';

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
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
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Coin Balance Card
                  CoinBalanceCard(
                    saldoKoin: _mockSaldoKoin,
                    onTapCard: () => onNavigateTab(3),
                    onBeliKoin: () => onNavigateTab(3),
                  ),
                  const SizedBox(height: AppDimensions.space2XL),

                  // Recruitment Stats
                  _SectionHeader(title: 'Ringkasan Rekrutmen'),
                  const SizedBox(height: AppDimensions.spaceM),
                  RecruitmentStatsSection(
                    lowonganAktif: _mockLowonganAktif,
                    totalPelamar: _mockTotalPelamar,
                    sedangDiproses: _mockSedangDiproses,
                    diterima: _mockDiterima,
                  ),
                  const SizedBox(height: AppDimensions.space2XL),

                  // Quick Actions
                  _SectionHeader(title: 'Aksi Cepat'),
                  const SizedBox(height: AppDimensions.spaceM),
                  QuickActionGrid(
                    onBuatLowongan: () {
                      // TODO: Navigate to form lowongan
                    },
                    onBeliKoin: () => onNavigateTab(3),
                    onLihatPelamar: () => onNavigateTab(2),
                    onLowonganSaya: () => onNavigateTab(1),
                  ),
                  const SizedBox(height: AppDimensions.space2XL),

                  // Recent Jobs
                  _SectionHeader(
                    title: 'Lowongan Terbaru',
                    onLihatSemua: () => onNavigateTab(1),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  ..._mockRecentJobs.map(
                    (job) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spaceS,
                      ),
                      child: RecentJobItem(
                        job: job,
                        onTap: () {
                          // TODO: Navigate to detail lowongan perusahaan
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.space2XL),

                  // Recent Applicants
                  _SectionHeader(
                    title: 'Pelamar Terbaru',
                    onLihatSemua: () => onNavigateTab(2),
                  ),
                  const SizedBox(height: AppDimensions.spaceM),
                  ..._mockRecentApplicants.map(
                    (applicant) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimensions.spaceS,
                      ),
                      child: RecentApplicantItem(
                        applicant: applicant,
                        onTap: () {
                          // TODO: Navigate to detail lamaran
                        },
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, String companyName) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spaceXL,
        AppDimensions.spaceL,
        AppDimensions.spaceXL,
        AppDimensions.spaceL,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Company avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B00), Color(0xFFFF9140)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),

          // Greeting text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    children: [
                      const TextSpan(text: 'Halo, '),
                      TextSpan(
                        text: companyName,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const TextSpan(text: ' 👋'),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Kelola recruitment perusahaanmu.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Notification bell
          NotificationBell(unreadCount: 3),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onLihatSemua;

  const _SectionHeader({required this.title, this.onLihatSemua});

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
        if (onLihatSemua != null)
          GestureDetector(
            onTap: onLihatSemua,
            child: Text(
              'Lihat Semua',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}
