import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/koin_model.dart';
import '../bloc/koin_bloc.dart';
// Note: assuming image picker is available. If not, we will just use a mock or placeholder for now.
// Karena kita belum tahu apakah image_picker ditambahkan.
import '../../../../shared/widgets/primary_button.dart';
import 'package:intl/intl.dart';

class KonfirmasiKoinPage extends StatefulWidget {
  final KoinTransactionModel transaction;

  const KonfirmasiKoinPage({super.key, required this.transaction});

  @override
  State<KonfirmasiKoinPage> createState() => _KonfirmasiKoinPageState();
}

class _KonfirmasiKoinPageState extends State<KonfirmasiKoinPage> {
  String? _selectedFilePath;

  void _uploadBukti() {
    if (_selectedFilePath != null) {
      context.read<KoinBloc>().add(
            UploadBuktiBayarEvent(
              transactionId: widget.transaction.id,
              filePath: _selectedFilePath!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Konfirmasi Pembayaran',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocConsumer<KoinBloc, KoinState>(
        listener: (context, state) {
          if (state is UploadBuktiSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Bukti pembayaran berhasil diunggah!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pop();
            // Refresh koin page
            context.read<KoinBloc>().add(const FetchKoinPageDataEvent());
          } else if (state is KoinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is KoinLoading;
          
          final formatCurrency = NumberFormat.currency(
            locale: 'id_ID',
            symbol: 'Rp ',
            decimalDigits: 0,
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatCurrency.format(widget.transaction.totalHarga),
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'No. Transaksi', value: widget.transaction.noTransaksi),
                      const SizedBox(height: 12),
                      _DetailRow(label: 'Paket Koin', value: widget.transaction.packageName ?? '${widget.transaction.jumlahKoin} Koin'),
                      const SizedBox(height: 12),
                      _DetailRow(label: 'Metode Pembayaran', value: widget.transaction.metodePembayaran ?? 'Transfer'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Upload Bukti Pembayaran',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Silakan lakukan pembayaran dan unggah bukti transfer/pembayaran di sini.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),

                GestureDetector(
                  onTap: () {
                    // TODO: Implement ImagePicker
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Simulasi pilih file: image.jpg terpilih.')),
                    );
                    setState(() {
                      _selectedFilePath = '/mock/path/image.jpg';
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.secondarySurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedFilePath != null
                            ? AppColors.primary
                            : AppColors.border,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedFilePath != null
                              ? Icons.check_circle_outline
                              : Icons.cloud_upload_outlined,
                          size: 40,
                          color: _selectedFilePath != null
                              ? AppColors.primary
                              : AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedFilePath != null
                              ? 'Bukti terpilih. Klik untuk mengubah.'
                              : 'Klik untuk mengunggah bukti',
                          style: GoogleFonts.inter(
                            color: _selectedFilePath != null
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                PrimaryButton(
                  text: 'Konfirmasi Pembayaran',
                  onPressed: _selectedFilePath == null || isLoading
                      ? null
                      : _uploadBukti,
                  isLoading: isLoading,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
