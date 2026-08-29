import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../bloc/perusahaan_bloc.dart';
import 'form_lowongan_page.dart';
import 'detail_lowongan_perusahaan_page.dart';

/// Halaman kelola lowongan — Tab Lowongan di Dashboard Perusahaan
class KelolaLowonganPage extends StatefulWidget {
  const KelolaLowonganPage({super.key});

  @override
  State<KelolaLowonganPage> createState() => _KelolaLowonganPageState();
}

class _KelolaLowonganPageState extends State<KelolaLowonganPage> {
  String _filterStatus = 'semua'; // semua | aktif | nonaktif

  @override
  void initState() {
    super.initState();
    context.read<PerusahaanBloc>().add(const FetchMyJobsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<PerusahaanBloc, PerusahaanState>(
        listener: (context, state) {
          if (state is JobCreated || state is JobUpdated) {
            // Refresh list setelah buat/edit lowongan
            context.read<PerusahaanBloc>().add(const FetchMyJobsEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state is JobCreated
                      ? 'Lowongan berhasil dibuat!'
                      : 'Lowongan berhasil diperbarui!',
                ),
                backgroundColor: AppColors.success,
              ),
            );
          }
          if (state is JobStatusToggled) {
            context.read<PerusahaanBloc>().add(const FetchMyJobsEvent());
          }
          if (state is PerusahaanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(child: _buildFilterChips()),
              if (state is PerusahaanLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state is MyJobsLoaded)
                _buildJobList(context, state.jobs)
              else if (state is PerusahaanError)
                SliverFillRemaining(
                  child: _buildErrorState(context, state.message),
                )
              else
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          );
        },
      ),
    );
  }

  // ── AppBar ─────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      floating: true,
      snap: true,
      title: Text(
        'Kelola Lowongan',
        style: GoogleFonts.poppins(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppDimensions.spaceL),
          child: GestureDetector(
            onTap: () => _navigateToForm(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.add, color: Colors.white, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    'Buat',
                    style: GoogleFonts.poppins(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppColors.border),
      ),
    );
  }

  // ── Filter Chips ───────────────────────────────────────────────────────────

  Widget _buildFilterChips() {
    final filters = [
      ('semua', 'Semua'),
      ('aktif', 'Aktif'),
      ('nonaktif', 'Nonaktif'),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceXL,
        vertical: 10,
      ),
      child: Row(
        children: filters.map((f) {
          final isSelected = _filterStatus == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _filterStatus = f.$1),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.secondarySurface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  f.$2,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Job List ───────────────────────────────────────────────────────────────

  Widget _buildJobList(BuildContext context, List<LowonganModel> allJobs) {
    final filtered = allJobs.where((job) {
      if (_filterStatus == 'aktif') return job.status.toLowerCase() == 'buka';
      if (_filterStatus == 'nonaktif') return job.status.toLowerCase() != 'buka';
      return true;
    }).toList();

    if (filtered.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState(context));
    }

    return SliverPadding(
      padding: const EdgeInsets.all(AppDimensions.spaceXL),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final job = filtered[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spaceM),
              child: _JobCard(
                job: job,
                onTap: () => _navigateToDetail(context, job),
                onToggleStatus: () => _toggleStatus(context, job),
                onEdit: () => _navigateToForm(context, job: job),
              ),
            );
          },
          childCount: filtered.length,
        ),
      ),
    );
  }

  // ── Empty / Error State ───────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space3XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: const BoxDecoration(
                color: AppColors.primarySurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.work_outline_rounded,
                color: AppColors.primary,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Belum ada lowongan',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai posting lowongan pekerjaan untuk menarik kandidat terbaik.',
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: () => _navigateToForm(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 13),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_rounded, size: 18),
              label: Text(
                'Buat Lowongan',
                style: GoogleFonts.poppins(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.space3XL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded,
                size: 60, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              message,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () =>
                  context.read<PerusahaanBloc>().add(const FetchMyJobsEvent()),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  // ── Navigation & Actions ──────────────────────────────────────────────────

  void _navigateToForm(BuildContext context, {LowonganModel? job}) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PerusahaanBloc>(),
          child: FormLowonganPage(existingJob: job),
        ),
      ),
    )
        .then((_) {
      if (context.mounted) {
        context.read<PerusahaanBloc>().add(const FetchMyJobsEvent());
      }
    });
  }

  void _navigateToDetail(BuildContext context, LowonganModel job) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<PerusahaanBloc>()),
          ],
          child: DetailLowonganPerusahaanPage(job: job),
        ),
      ),
    ).then((_) {
      if (context.mounted) {
        context.read<PerusahaanBloc>().add(const FetchMyJobsEvent());
      }
    });
  }

  void _toggleStatus(BuildContext context, LowonganModel job) {
    final isAktif = job.status.toLowerCase() == 'buka';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          isAktif ? 'Nonaktifkan Lowongan?' : 'Aktifkan Lowongan?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        content: Text(
          isAktif
              ? 'Lowongan "${job.judul}" akan dinonaktifkan dan tidak menerima pelamar baru.'
              : 'Lowongan "${job.judul}" akan diaktifkan kembali.',
          style: GoogleFonts.inter(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isAktif ? AppColors.danger : AppColors.success,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<PerusahaanBloc>()
                  .add(ToggleJobStatusEvent(job.id));
            },
            child: Text(isAktif ? 'Nonaktifkan' : 'Aktifkan'),
          ),
        ],
      ),
    );
  }
}

// ─── Job Card Widget ──────────────────────────────────────────────────────────

class _JobCard extends StatelessWidget {
  final LowonganModel job;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;

  const _JobCard({
    required this.job,
    required this.onTap,
    required this.onToggleStatus,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isAktif = job.status.toLowerCase() == 'buka';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Posisi + Status badge
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.judul,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                _StatusBadge(isAktif: isAktif),
              ],
            ),
            const SizedBox(height: 6),

            // Lokasi & Tipe
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  job.lokasi,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.work_outline_rounded,
                    size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  job.tipePekerjaan,
                  style: GoogleFonts.inter(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Footer: Pelamar + Actions
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.people_outline_rounded,
                          size: 13, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        '${job.jumlahPelamar} Pelamar',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Edit
                _ActionBtn(
                  icon: Icons.edit_outlined,
                  label: 'Edit',
                  onTap: onEdit,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                // Toggle status
                _ActionBtn(
                  icon: isAktif
                      ? Icons.pause_circle_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  label: isAktif ? 'Nonaktifkan' : 'Aktifkan',
                  onTap: onToggleStatus,
                  color: isAktif ? AppColors.danger : AppColors.success,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isAktif;
  const _StatusBadge({required this.isAktif});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isAktif ? AppColors.successLight : AppColors.secondarySurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isAktif ? 'Aktif' : 'Nonaktif',
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isAktif ? AppColors.success : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
