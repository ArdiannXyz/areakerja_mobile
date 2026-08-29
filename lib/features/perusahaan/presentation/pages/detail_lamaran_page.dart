import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/company_applicant_model.dart';
import '../bloc/perusahaan_bloc.dart';

class DetailLamaranPage extends StatefulWidget {
  final CompanyApplicantModel applicant;

  const DetailLamaranPage({super.key, required this.applicant});

  @override
  State<DetailLamaranPage> createState() => _DetailLamaranPageState();
}

class _DetailLamaranPageState extends State<DetailLamaranPage> {
  late String _currentStatus;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.applicant.status;
  }

  void _updateStatus(String newStatus) {
    context.read<PerusahaanBloc>().add(
          UpdateApplicantStatusEvent(
            applicationId: widget.applicant.id,
            status: newStatus,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Kandidat',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: BlocListener<PerusahaanBloc, PerusahaanState>(
        listener: (context, state) {
          if (state is ApplicantStatusUpdated &&
              state.applicationId == widget.applicant.id) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Status kandidat diperbarui!'),
                backgroundColor: AppColors.success,
              ),
            );
          } else if (state is PerusahaanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Profil
              Row(
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryLight,
                    child: const Icon(Icons.person,
                            size: 36, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.applicant.candidateName,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.applicant.email,
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        if (widget.applicant.phone != null)
                          Text(
                            widget.applicant.phone!,
                            style: GoogleFonts.inter(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Status Dropdown
              Text(
                'Ubah Status Lamaran',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentStatus.toLowerCase(),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                          value: 'pending', child: Text('Menunggu Review')),
                      DropdownMenuItem(
                          value: 'review', child: Text('Sedang Direview')),
                      DropdownMenuItem(
                          value: 'interview', child: Text('Panggilan Interview')),
                      DropdownMenuItem(
                          value: 'lolos', child: Text('Diterima')),
                      DropdownMenuItem(
                          value: 'ditolak', child: Text('Ditolak')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _currentStatus = val);
                        _updateStatus(val);
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Data Tambahan (Resume, Deskripsi Diri, dll)
              if (widget.applicant.resumeUrl != null) ...[
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description,
                      color: AppColors.primary),
                  title: const Text('Lihat CV / Resume'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    // TODO: Buka link resume
                  },
                ),
                const Divider(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
