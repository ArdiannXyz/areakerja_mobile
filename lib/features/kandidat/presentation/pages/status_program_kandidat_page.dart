import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/profil_kandidat_model.dart';
import '../bloc/kandidat_bloc.dart';

class StatusProgramKandidatPage extends StatefulWidget {
  const StatusProgramKandidatPage({super.key});

  @override
  State<StatusProgramKandidatPage> createState() =>
      _StatusProgramKandidatPageState();
}

class _StatusProgramKandidatPageState
    extends State<StatusProgramKandidatPage> {
  static const _orange = Color(0xFFFF5E14);

  @override
  void initState() {
    super.initState();
    context.read<KandidatBloc>().add(const FetchStatusProgramEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              color: Color(0xFF0F172A), size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Status Program',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: BlocBuilder<KandidatBloc, KandidatState>(
        builder: (context, state) {
          if (state is KandidatLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_orange),
              ),
            );
          }

          if (state is KandidatError) {
            return _buildErrorView(state.message);
          }

          KandidatProgramModel? programModel;
          if (state is KandidatStatusLoaded) {
            programModel = state.programModel;
          }

          if (programModel == null) {
            return _buildErrorView('Data program tidak tersedia.');
          }

          return RefreshIndicator(
            color: _orange,
            onRefresh: () async {
              context
                  .read<KandidatBloc>()
                  .add(const FetchStatusProgramEvent());
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Status Card Utama
                  _buildStatusCard(programModel),
                  const SizedBox(height: 20),

                  // 2. Stepper Progress
                  _buildStepper(programModel),
                  const SizedBox(height: 20),

                  // 3. Info Pelatihan Offline (jika sedang atau menunggu pelatihan)
                  if (_shouldShowInfoPelatihan(programModel.statusProgram))
                    _buildInfoPelatihanCard(programModel),

                  // 4. Informasi Deposit
                  if (_shouldShowDeposit(programModel.statusProgram))
                    _buildDepositCard(programModel),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _shouldShowInfoPelatihan(StatusProgram status) {
    return status == StatusProgram.terdaftarProgram ||
        status == StatusProgram.menungguPelatihan ||
        status == StatusProgram.sedangPelatihan ||
        status == StatusProgram.pelatihanSelesai ||
        status == StatusProgram.menungguEvaluasi;
  }

  bool _shouldShowDeposit(StatusProgram status) {
    return status == StatusProgram.lulus ||
        status == StatusProgram.kandidatSiapKerja ||
        status == StatusProgram.depositMenungguPengembalian ||
        status == StatusProgram.depositTelahDikembalikan;
  }

  // =========================================================================
  // 1. STATUS CARD UTAMA
  // =========================================================================
  Widget _buildStatusCard(KandidatProgramModel model) {
    final isLulus = model.isLulus;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLulus
              ? [const Color(0xFF10B981), const Color(0xFF059669)]
              : [_orange, const Color(0xFFE04A05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: (isLulus ? const Color(0xFF10B981) : _orange)
                .withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isLulus ? Icons.verified_rounded : Icons.timeline_rounded,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  model.divisiNama ?? 'Program Kandidat',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              model.statusProgram.displayLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (model.tanggalDaftar != null) ...[
            const SizedBox(height: 12),
            Text(
              'Terdaftar: ${DateFormat('dd MMM yyyy', 'id_ID').format(model.tanggalDaftar!)}',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 12.5,
              ),
            ),
          ],
        ],
      ),
    );
  }



  // =========================================================================
  // 2. STEPPER PROGRESS
  // =========================================================================
  Widget _buildStepper(KandidatProgramModel model) {
    final steps = _buildStepData(model.statusProgram);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Progress Program',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isLast = i == steps.length - 1;
            return _buildStepItem(step, isLast: isLast);
          }),
        ],
      ),
    );
  }

  List<_StepData> _buildStepData(StatusProgram current) {
    final allSteps = [
      _StepData(
        label: 'Pendaftaran Kandidat',
        icon: Icons.how_to_reg_rounded,
        refStatus: StatusProgram.menungguPembayaran,
      ),
      _StepData(
        label: 'Pembayaran Deposit',
        icon: Icons.payment_rounded,
        refStatus: StatusProgram.menungguVerifikasiBayar,
      ),
      _StepData(
        label: 'Verifikasi Pembayaran',
        icon: Icons.verified_outlined,
        refStatus: StatusProgram.pembayaranTerverifikasi,
      ),
      _StepData(
        label: 'Pelatihan Offline',
        icon: Icons.school_rounded,
        refStatus: StatusProgram.sedangPelatihan,
        sublabel: 'Dilaksanakan secara offline',
      ),
      _StepData(
        label: 'Evaluasi',
        icon: Icons.assignment_rounded,
        refStatus: StatusProgram.menungguEvaluasi,
      ),
      _StepData(
        label: 'Kelulusan',
        icon: Icons.emoji_events_rounded,
        refStatus: StatusProgram.lulus,
      ),
      _StepData(
        label: 'Kandidat Siap Kerja',
        icon: Icons.work_rounded,
        refStatus: StatusProgram.kandidatSiapKerja,
      ),
    ];

    for (final step in allSteps) {
      if (current.index > step.refStatus.index) {
        step.state = _StepState.done;
      } else if (current.index == step.refStatus.index ||
          (current == StatusProgram.terdaftarProgram &&
              step.refStatus == StatusProgram.sedangPelatihan) ||
          (current == StatusProgram.pelatihanSelesai &&
              step.refStatus == StatusProgram.menungguEvaluasi) ||
          (current == StatusProgram.menungguPelatihan &&
              step.refStatus == StatusProgram.sedangPelatihan) ||
          (current == StatusProgram.pembayaranTerverifikasi &&
              step.refStatus == StatusProgram.pembayaranTerverifikasi) ||
          (current == StatusProgram.menungguVerifikasiBayar &&
              step.refStatus == StatusProgram.menungguVerifikasiBayar) ||
          (current == StatusProgram.depositMenungguPengembalian &&
              step.refStatus == StatusProgram.kandidatSiapKerja) ||
          (current == StatusProgram.depositTelahDikembalikan &&
              step.refStatus == StatusProgram.kandidatSiapKerja)) {
        step.state = _StepState.active;
      } else {
        step.state = _StepState.pending;
      }
    }

    return allSteps;
  }

  Widget _buildStepItem(_StepData step, {bool isLast = false}) {
    final isDone = step.state == _StepState.done;
    final isActive = step.state == _StepState.active;

    Color dotColor;
    Color iconColor;
    Widget dotContent;

    if (isDone) {
      dotColor = const Color(0xFF10B981);
      iconColor = Colors.white;
      dotContent = const Icon(Icons.check_rounded, color: Colors.white, size: 14);
    } else if (isActive) {
      dotColor = _orange;
      iconColor = Colors.white;
      dotContent = Icon(step.icon, color: Colors.white, size: 14);
    } else {
      dotColor = const Color(0xFFE2E8F0);
      iconColor = const Color(0xFF94A3B8);
      dotContent = Icon(step.icon, color: iconColor, size: 14);
    }

    return Stack(
      children: [
        // Line
        if (!isLast)
          Positioned(
            top: 36,
            bottom: 4,
            left: 17,
            child: Container(
              width: 2,
              color: isDone
                  ? const Color(0xFF10B981)
                  : const Color(0xFFE2E8F0),
            ),
          ),
        
        // Content
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dot
            SizedBox(
              width: 36,
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: _orange.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(child: dotContent),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Label
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      step.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isActive ? FontWeight.bold : FontWeight.w500,
                        color: isActive
                            ? const Color(0xFF0F172A)
                            : isDone
                                ? const Color(0xFF475569)
                                : const Color(0xFF94A3B8),
                      ),
                    ),
                    if (step.sublabel != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        step.sublabel!,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: isActive
                              ? _orange.withValues(alpha: 0.8)
                              : const Color(0xFFCBD5E1),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =========================================================================
  // 3. INFO PELATIHAN OFFLINE
  // =========================================================================
  Widget _buildInfoPelatihanCard(KandidatProgramModel model) {
    final isSedangPelatihan =
        model.statusProgram == StatusProgram.sedangPelatihan;
    final isMenunggu = model.statusProgram == StatusProgram.menungguPelatihan ||
        model.statusProgram == StatusProgram.terdaftarProgram ||
        model.statusProgram == StatusProgram.pembayaranTerverifikasi;

    String title;
    String desc;
    IconData icon;
    Color color;

    if (isSedangPelatihan) {
      title = 'Sedang Mengikuti Pelatihan Offline';
      desc =
          'Kamu saat ini sedang mengikuti program pelatihan secara offline. Hadir sesuai jadwal dan jadilah peserta terbaik!';
      icon = Icons.school_rounded;
      color = _orange;
    } else if (isMenunggu) {
      title = 'Menunggu Jadwal Pelatihan';
      desc =
          'Pembayaran telah diverifikasi. Tim AreaKerja akan menginformasikan jadwal pelatihan offline melalui notifikasi atau kontak yang terdaftar.';
      icon = Icons.access_time_rounded;
      color = const Color(0xFFF5A623);
    } else {
      title = 'Pelatihan Selesai';
      desc =
          'Kamu telah menyelesaikan program pelatihan offline. Menunggu hasil evaluasi dari tim AreaKerja.';
      icon = Icons.task_alt_rounded;
      color = const Color(0xFF10B981);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF475569),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 4. STATUS DEPOSIT
  // =========================================================================
  Widget _buildDepositCard(KandidatProgramModel model) {
    final isTelahDikembalikan =
        model.statusDeposit == StatusDeposit.telahDikembalikan ||
            model.statusProgram == StatusProgram.depositTelahDikembalikan;

    final isMenungguPengembalian =
        model.statusDeposit == StatusDeposit.menungguPengembalian ||
            model.statusProgram == StatusProgram.depositMenungguPengembalian ||
            model.isLulus;

    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return Column(
      children: [
        // Selamat Banner (jika lulus)
        if (model.isLulus) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              children: [
                Icon(Icons.emoji_events_rounded,
                    color: Colors.white, size: 40),
                SizedBox(height: 8),
                Text(
                  'Selamat!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Kamu telah menyelesaikan program\ndan menjadi Kandidat Siap Kerja ✓',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],

        // Deposit Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isTelahDikembalikan
                  ? const Color(0xFF10B981)
                  : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Deposit',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 16),
              _buildDepositRow(
                'Jumlah Deposit',
                currencyFormatter.format(model.jumlahDeposit),
              ),
              const SizedBox(height: 10),
              _buildDepositRow(
                'Status Deposit',
                isTelahDikembalikan
                    ? 'Telah Dikembalikan ✓'
                    : isMenungguPengembalian
                        ? 'Menunggu Pengembalian'
                        : 'Belum Diproses',
                valueColor: isTelahDikembalikan
                    ? const Color(0xFF10B981)
                    : isMenungguPengembalian
                        ? const Color(0xFFF5A623)
                        : const Color(0xFF64748B),
              ),
              if (isTelahDikembalikan && model.tanggalDikembalikan != null) ...[
                const SizedBox(height: 10),
                _buildDepositRow(
                  'Metode Pengembalian',
                  'Pengembalian Offline',
                ),
                const SizedBox(height: 10),
                _buildDepositRow(
                  'Tanggal Dikembalikan',
                  DateFormat('dd MMM yyyy', 'id_ID')
                      .format(model.tanggalDikembalikan!),
                ),
              ],
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isTelahDikembalikan
                      ? const Color(0xFFECFDF5)
                      : const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      isTelahDikembalikan
                          ? Icons.check_circle_outline_rounded
                          : Icons.info_outline_rounded,
                      color: isTelahDikembalikan
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF5A623),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isTelahDikembalikan
                            ? 'Deposit telah dikembalikan secara offline oleh tim AreaKerja.'
                            : 'Pengembalian deposit dilakukan secara offline sesuai prosedur AreaKerja. Bukan melalui aplikasi.',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isTelahDikembalikan
                              ? const Color(0xFF059669)
                              : const Color(0xFF92400E),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDepositRow(String label, String value,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline_rounded,
              color: Color(0xFFCBD5E1), size: 64),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => context
                .read<KandidatBloc>()
                .add(const FetchStatusProgramEvent()),
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// HELPER CLASSES
// =========================================================================

enum _StepState { done, active, pending }

class _StepData {
  final String label;
  final IconData icon;
  final StatusProgram refStatus;
  final String? sublabel;
  _StepState state = _StepState.pending;

  _StepData({
    required this.label,
    required this.icon,
    required this.refStatus,
    this.sublabel,
  });
}
