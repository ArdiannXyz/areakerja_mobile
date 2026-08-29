import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';

class RecentApplicantData {
  final String id;
  final String namaKandidat;
  final String posisiDilamar;
  final String status; // 'review', 'interview', 'lolos', 'ditolak', 'menunggu'
  final String? avatarUrl;
  final String? inisial;

  const RecentApplicantData({
    required this.id,
    required this.namaKandidat,
    required this.posisiDilamar,
    required this.status,
    this.avatarUrl,
    this.inisial,
  });

  String get displayInisial {
    if (inisial != null && inisial!.isNotEmpty) return inisial!;
    final parts = namaKandidat.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return namaKandidat.isNotEmpty ? namaKandidat[0].toUpperCase() : '?';
  }
}

class RecentApplicantItem extends StatelessWidget {
  final RecentApplicantData applicant;
  final VoidCallback? onTap;

  const RecentApplicantItem({
    super.key,
    required this.applicant,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusInfo = _getStatusInfo(applicant.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
        child: Row(
          children: [
            // Avatar
            _ApplicantAvatar(
              inisial: applicant.displayInisial,
              avatarUrl: applicant.avatarUrl,
              color: statusInfo.avatarColor,
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    applicant.namaKandidat,
                    style: GoogleFonts.poppins(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    applicant.posisiDilamar,
                    style: GoogleFonts.inter(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // Status chip
            _ApplicantStatusChip(
              label: statusInfo.label,
              color: statusInfo.color,
              bg: statusInfo.bg,
            ),
          ],
        ),
      ),
    );
  }

  _StatusInfo _getStatusInfo(String status) {
    switch (status.toLowerCase()) {
      case 'review':
      case 'ditinjau':
        return _StatusInfo(
          label: 'Review',
          color: const Color(0xFFD97706),
          bg: const Color(0xFFFEF3C7),
          avatarColor: const Color(0xFFF59E0B),
        );
      case 'interview':
        return _StatusInfo(
          label: 'Interview',
          color: AppColors.accent,
          bg: AppColors.accentLight,
          avatarColor: AppColors.accent,
        );
      case 'lolos':
      case 'diterima':
      case 'hired':
        return _StatusInfo(
          label: 'Diterima',
          color: AppColors.success,
          bg: AppColors.successLight,
          avatarColor: AppColors.success,
        );
      case 'ditolak':
      case 'rejected':
        return _StatusInfo(
          label: 'Ditolak',
          color: AppColors.danger,
          bg: AppColors.dangerLight,
          avatarColor: AppColors.danger,
        );
      default:
        return _StatusInfo(
          label: 'Menunggu',
          color: AppColors.textSecondary,
          bg: AppColors.secondarySurface,
          avatarColor: AppColors.secondary,
        );
    }
  }
}

class _ApplicantAvatar extends StatelessWidget {
  final String inisial;
  final String? avatarUrl;
  final Color color;

  const _ApplicantAvatar({
    required this.inisial,
    this.avatarUrl,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
      ),
      child: avatarUrl != null
          ? ClipOval(
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, _x) => _InitialText(
                  inisial: inisial,
                  color: color,
                ),
              ),
            )
          : Center(
              child: _InitialText(inisial: inisial, color: color),
            ),
    );
  }
}

class _InitialText extends StatelessWidget {
  final String inisial;
  final Color color;

  const _InitialText({required this.inisial, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      inisial,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _ApplicantStatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const _ApplicantStatusChip({
    required this.label,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _StatusInfo {
  final String label;
  final Color color;
  final Color bg;
  final Color avatarColor;

  const _StatusInfo({
    required this.label,
    required this.color,
    required this.bg,
    required this.avatarColor,
  });
}
