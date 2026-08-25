import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/role_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class ProfilPelamarPage extends StatefulWidget {
  final VoidCallback? onNavigateToKandidatTab;

  const ProfilPelamarPage({
    super.key,
    this.onNavigateToKandidatTab,
  });

  @override
  State<ProfilPelamarPage> createState() => _ProfilPelamarPageState();
}

class _ProfilPelamarPageState extends State<ProfilPelamarPage> {
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
        final userName = user?.name.isNotEmpty == true ? user!.name : 'edzam17';
        final isKandidat = user?.role == UserRole.kandidat;

        return Scaffold(
          backgroundColor: const Color(0xFFF1F3F5),
          body: Column(
            children: [
              // 1. TOP ORANGE HEADER SECTION
              _buildOrangeHeader(context, userName, isKandidat, user?.avatar),

              // 2. PROFILE MENU LIST ITEMS
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  children: [
                    // Data Diri
                    _buildProfileCard(
                      icon: Icons.person_outline_rounded,
                      title: 'Data Diri',
                      onTap: () => Navigator.of(context).pushNamed('/pelamar/data-diri'),
                    ),
                    const SizedBox(height: 10),

                    // Alamat
                    _buildProfileCard(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat',
                      onTap: () => Navigator.of(context).pushNamed('/pelamar/alamat'),
                    ),
                    const SizedBox(height: 10),

                    // Unduh CV
                    _buildProfileCard(
                      icon: Icons.file_download_outlined,
                      title: 'Unduh CV',
                      onTap: () => _showUnduhCvBottomSheet(context, userName),
                    ),
                    const SizedBox(height: 10),

                    // Kandidat (Disabled / Locked until registered & trained)
                    _buildProfileCard(
                      icon: Icons.military_tech_outlined,
                      title: 'Kandidat',
                      isLocked: !isKandidat,
                      trailingBadge: !isKandidat
                          ? Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.lock_rounded, size: 11, color: Color(0xFF64748B)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Terkunci',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFA7F3D0)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified_rounded, size: 12, color: Color(0xFF10B981)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Aktif',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF059669),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      onTap: () {
                        if (isKandidat) {
                          Navigator.of(context).pushNamed('/dashboard-kandidat');
                        } else {
                          _showKandidatLockedBottomSheet(context);
                        }
                      },
                    ),
                    const SizedBox(height: 10),

                    // FAQ
                    _buildProfileCard(
                      icon: Icons.chat_bubble_outline_rounded,
                      title: 'FAQ',
                      onTap: () => Navigator.of(context).pushNamed('/faq'),
                    ),
                    const SizedBox(height: 10),

                    // Ubah Kata Sandi
                    _buildProfileCard(
                      icon: Icons.key_outlined,
                      title: 'Ubah Kata Sandi',
                      onTap: () => Navigator.of(context).pushNamed('/pelamar/ubah-kata-sandi'),
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
  }

  // =========================================================================
  // 1. TOP ORANGE HEADER
  // =========================================================================
  Widget _buildOrangeHeader(BuildContext context, String userName, bool isKandidat, String? avatarUrl) {
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
                      errorBuilder: (context, error, stackTrace) => _buildDefaultAvatar(userName),
                    )
                  : _buildDefaultAvatar(userName),
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
                        userName,
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
                  isKandidat ? 'Kandidat Aktif' : 'Pelamar Aktif',
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

  Widget _buildDefaultAvatar(String name) {
    return Container(
      color: const Color(0xFF334155),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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
    bool isLocked = false,
    Widget? trailingBadge,
  }) {
    final iconColor = isDanger
        ? const Color(0xFFEF4444)
        : (isLocked ? const Color(0xFF94A3B8) : const Color(0xFF475569));
    final textColor = isDanger
        ? const Color(0xFFEF4444)
        : (isLocked ? const Color(0xFF64748B) : const Color(0xFF1E293B));
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
                  color: isDanger
                      ? const Color(0xFFFEF2F2)
                      : (isLocked ? const Color(0xFFF1F5F9) : const Color(0xFFF8FAFC)),
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
              if (trailingBadge != null) ...[
                trailingBadge,
                const SizedBox(width: 8),
              ],
              if (hasChevron)
                Icon(
                  isLocked ? Icons.lock_outline_rounded : Icons.chevron_right_rounded,
                  color: const Color(0xFF94A3B8),
                  size: isLocked ? 18 : 22,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 3. KANDIDAT LOCKED BOTTOM SHEET MODAL (Matching 2nd Screenshot)
  // =========================================================================
  void _showKandidatLockedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Big stylish Lock Icon
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 68,
                  color: Color(0xFF64748B),
                ),
                const SizedBox(height: 18),

                // Explanation text
                const Text(
                  'Anda harus menyelesaikan pelatihan agar bisa mengakses halaman ini',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: Color(0xFF64748B),
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),

                // Orange CTA Button: Buka Menu Daftar Kandidat
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5E14),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.diversity_3_rounded, size: 20),
                    label: const Text(
                      'Buka Menu Daftar Kandidat',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      if (widget.onNavigateToKandidatTab != null) {
                        widget.onNavigateToKandidatTab!();
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/dashboard-pelamar',
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Secondary Close Button
                SizedBox(
                  width: double.infinity,
                  height: 42,
                  child: TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text(
                      'Nanti Saja',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // 4. UNDUH CV POP-UP DIALOG (Interactive & Attractive)
  // =========================================================================
  void _showUnduhCvBottomSheet(BuildContext context, String userName) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _UnduhCvDialog(userName: userName),
    );
  }

  // =========================================================================
  // 5. LOGOUT DIALOG (Matching Screenshot)
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

// ===========================================================================
// UNDUH CV INTERACTIVE POP-UP DIALOG
// ===========================================================================
class _UnduhCvDialog extends StatefulWidget {
  final String userName;

  const _UnduhCvDialog({required this.userName});

  @override
  State<_UnduhCvDialog> createState() => _UnduhCvDialogState();
}

class _UnduhCvDialogState extends State<_UnduhCvDialog> {
  String _selectedFormat = 'ats'; // 'ats' or 'modern'
  bool _isDownloading = false;
  bool _isDownloaded = false;

  void _startDownload() {
    setState(() {
      _isDownloading = true;
    });

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (!mounted) return;
      setState(() {
        _isDownloading = false;
        _isDownloaded = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text('CV_${widget.userName.replaceAll(' ', '_')}.pdf berhasil disimpan di folder Unduhan!'),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final fileName = 'CV_${widget.userName.replaceAll(' ', '_')}.pdf';

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Title & Close Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF5E14).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.picture_as_pdf_rounded,
                          color: Color(0xFFFF5E14),
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Unduh CV Digital',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Format Resmi AreaKerja',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(Icons.close_rounded, color: Color(0xFF94A3B8), size: 22),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // Document Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF7ED), Color(0xFFFFFBEB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFFD8B4), width: 1.2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF5E14),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.description_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fileName,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'PDF • 245 KB • Format ATS',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFFFE3C7)),
                  const SizedBox(height: 10),
                  // Included info tags
                  const Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _DocBadge(label: '✓ Data Diri Lengkap'),
                      _DocBadge(label: '✓ Riwayat Pendidikan'),
                      _DocBadge(label: '✓ Keahlian & Bio'),
                      _DocBadge(label: '✓ Standar HRD'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Format Selection Section
            const Text(
              'Pilih Desain Template:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _buildTemplateCard(
                    id: 'ats',
                    title: 'Standar ATS',
                    subtitle: 'Direkomendasikan HRD',
                    icon: Icons.check_circle_outline_rounded,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildTemplateCard(
                    id: 'modern',
                    title: 'Modern Visual',
                    subtitle: 'Aksen Oranye Kreatif',
                    icon: Icons.palette_outlined,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // Download Button & Progress State
            if (_isDownloading) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Column(
                  children: [
                    SizedBox(
                      height: 4,
                      child: LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5E14)),
                        backgroundColor: Color(0xFFFFEDD5),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Menyiapkan & merender dokumen PDF...',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (_isDownloaded) ...[
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF334155),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text('Buka File', style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Membuka pratinjau dokumen PDF...'),
                            backgroundColor: Color(0xFF10B981),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E14),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.file_download_rounded, size: 20),
                  label: const Text(
                    'Unduh Sekarang (PDF)',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: _startDownload,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard({
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _selectedFormat == id;

    return InkWell(
      onTap: () => setState(() => _selectedFormat = id),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF5E14).withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF5E14) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.6 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: isSelected ? const Color(0xFFFF5E14) : const Color(0xFF64748B),
                ),
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                  size: 16,
                  color: isSelected ? const Color(0xFFFF5E14) : const Color(0xFFCBD5E1),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color(0xFFFF5E14) : const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF64748B),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _DocBadge extends StatelessWidget {
  final String label;

  const _DocBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFFFFD8B4)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF9A3412),
        ),
      ),
    );
  }
}

