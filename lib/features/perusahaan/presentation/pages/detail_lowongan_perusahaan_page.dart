import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../bloc/perusahaan_bloc.dart';
import 'form_lowongan_page.dart';
import 'detail_lamaran_page.dart';

class DetailLowonganPerusahaanPage extends StatefulWidget {
  final LowonganModel job;

  const DetailLowonganPerusahaanPage({
    super.key,
    required this.job,
  });

  @override
  State<DetailLowonganPerusahaanPage> createState() =>
      _DetailLowonganPerusahaanPageState();
}

class _DetailLowonganPerusahaanPageState
    extends State<DetailLowonganPerusahaanPage> {
  late LowonganModel _currentJob;

  @override
  void initState() {
    super.initState();
    _currentJob = widget.job;
    // Panggil event untuk ambil data terbaru jika dibutuhkan, 
    // atau gunakan pelamar-pelamar di lowongan ini.
    context.read<PerusahaanBloc>().add(FetchJobApplicantsEvent(_currentJob.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Detail Lowongan',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: _onEditPressed,
            tooltip: 'Edit Lowongan',
          ),
          BlocConsumer<PerusahaanBloc, PerusahaanState>(
            listener: (context, state) {
              if (state is JobStatusToggled) {
                // Refresh local status
                setState(() {
                  final newStatus = _currentJob.status.toLowerCase() == 'buka'
                      ? 'tutup'
                      : 'buka';
                  _currentJob = _currentJob.copyWith(status: newStatus);
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Status lowongan diperbarui!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isAktif = _currentJob.status.toLowerCase() == 'buka';
              return IconButton(
                icon: Icon(
                  isAktif
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  color: isAktif ? AppColors.danger : AppColors.success,
                ),
                onPressed: () {
                  context
                      .read<PerusahaanBloc>()
                      .add(ToggleJobStatusEvent(_currentJob.id));
                },
                tooltip: isAktif ? 'Nonaktifkan' : 'Aktifkan',
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<PerusahaanBloc, PerusahaanState>(
        listener: (context, state) {
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
              SliverToBoxAdapter(
                child: _buildJobInfo(),
              ),
              const SliverToBoxAdapter(
                child: Divider(height: 1, thickness: 1),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.spaceXL),
                  child: Text(
                    'Daftar Pelamar (${_currentJob.jumlahPelamar})',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              _buildApplicantsList(state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildJobInfo() {
    final isAktif = _currentJob.status.toLowerCase() == 'buka';
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppDimensions.spaceXL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _currentJob.judul,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isAktif ? AppColors.successLight : AppColors.dangerLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isAktif ? 'Aktif' : 'Nonaktif',
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isAktif ? AppColors.success : AppColors.danger,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.location_on_outlined,
            label: _currentJob.lokasi,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.work_outline,
            label: _currentJob.tipePekerjaan,
          ),
          const SizedBox(height: 8),
          _InfoRow(
            icon: Icons.monetization_on_outlined,
            label: 'Gaji: ${_currentJob.gajiMin} - ${_currentJob.gajiMax}',
          ),
          const SizedBox(height: 24),
          Text(
            'Deskripsi',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _currentJob.deskripsi,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApplicantsList(PerusahaanState state) {
    if (state is PerusahaanLoading) {
      return const SliverFillRemaining(
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (state is JobApplicantsLoaded) {
      if (state.applicants.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Text(
              'Belum ada pelamar untuk lowongan ini.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final applicant = state.applicants[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceXL,
                vertical: 8,
              ),
              leading: const CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                applicant.candidateName,
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                'Status: ${applicant.status}',
                style: GoogleFonts.inter(fontSize: 12),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navigate to detail lamaran
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<PerusahaanBloc>(),
                      child: DetailLamaranPage(applicant: applicant),
                    ),
                  ),
                ).then((_) {
                  // Refresh applicants on return
                  if (context.mounted) {
                    context.read<PerusahaanBloc>().add(
                        FetchJobApplicantsEvent(_currentJob.id));
                  }
                });
              },
            );
          },
          childCount: state.applicants.length,
        ),
      );
    }
    return const SliverToBoxAdapter(child: SizedBox());
  }

  void _onEditPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<PerusahaanBloc>(),
          child: FormLowonganPage(existingJob: _currentJob),
        ),
      ),
    ).then((_) {
      // Idealnya fetch detail terbaru
      // Tapi kita minta re-fetch list saja di parent
    });
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textMuted),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}
