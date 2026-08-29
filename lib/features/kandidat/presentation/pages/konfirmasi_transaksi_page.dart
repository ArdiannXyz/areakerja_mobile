import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/divisi_model.dart';
import '../../../pembayaran/data/models/pembayaran_model.dart';
import '../bloc/kandidat_bloc.dart';

class KonfirmasiTransaksiPage extends StatelessWidget {
  final DivisiModel divisi;
  final MetodePembayaranModel paymentMethod;

  const KonfirmasiTransaksiPage({
    super.key,
    required this.divisi,
    required this.paymentMethod,
  });

  static const _orange = Color(0xFFFF5E14);

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    final totalPayment = divisi.jumlahDeposit + divisi.biayaAdmin;

    return BlocListener<KandidatBloc, KandidatState>(
      listener: (context, state) {
        if (state is KandidatDaftarSuccess) {
          // Navigasi ke detail transaksi setelah berhasil mendaftar
          final noTrx = state.responseData['data']?['no_transaksi']?.toString() ??
              state.responseData['data']?['transaction_code']?.toString() ?? '';
          
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/transaksi/detail',
            (route) => route.settings.name == '/kandidat/benefit' || route.isFirst,
            arguments: {
              'noTransaksi': noTrx,
              'namaKandidat': 'John Doe', // mock
              'divisi': divisi.nama,
              'bankName': paymentMethod.nama,
              'totalPayment': totalPayment.toString(),
            },
          );
        } else if (state is KandidatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: const Color(0xFFEF4444),
            ),
          );
        }
      },
      child: Scaffold(
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
            'Konfirmasi Transaksi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Rincian Program
              const Text(
                'Rincian Program',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Program', 'Kandidat AreaKerja'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),
                    _buildDetailRow('Divisi', divisi.nama),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 2. Metode Pembayaran
              const Text(
                'Metode Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
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
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          paymentMethod.isQris
                              ? Icons.qr_code_2_rounded
                              : Icons.account_balance_rounded,
                          color: const Color(0xFF94A3B8),
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        paymentMethod.nama,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. Rincian Pembayaran
              const Text(
                'Rincian Pembayaran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildDetailRow('Jumlah Deposit',
                        currencyFormatter.format(divisi.jumlahDeposit)),
                    const SizedBox(height: 12),
                    _buildDetailRow('Biaya Admin',
                        currencyFormatter.format(divisi.biayaAdmin)),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(color: Color(0xFFF1F5F9), height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          currencyFormatter.format(totalPayment),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 4. Informasi Tambahan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF), // blue-50
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)), // blue-200
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: Color(0xFF3B82F6), size: 20),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Deposit merupakan uang komitmen dan dapat dikembalikan sesuai ketentuan setelah peserta menyelesaikan program dan dinyatakan lulus.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF1E3A8A),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: BlocBuilder<KandidatBloc, KandidatState>(
                builder: (context, state) {
                  final isLoading = state is KandidatLoading;
                  return ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            context.read<KandidatBloc>().add(
                                  DaftarKandidatEvent(
                                    divisiId: divisi.id,
                                    paymentChannelId: paymentMethod.id,
                                  ),
                                );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _orange,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text('Bayar Sekarang'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
