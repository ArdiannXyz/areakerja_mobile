import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../pembayaran/data/models/pembayaran_model.dart';
import '../../../pembayaran/presentation/bloc/pembayaran_bloc/pembayaran_bloc.dart';
import '../../data/models/koin_model.dart';
import '../bloc/koin_bloc.dart';
import 'konfirmasi_koin_page.dart';

class BeliKoinPage extends StatefulWidget {
  final KoinPackageModel package;

  const BeliKoinPage({super.key, required this.package});

  @override
  State<BeliKoinPage> createState() => _BeliKoinPageState();
}

class _BeliKoinPageState extends State<BeliKoinPage> {
  MetodePembayaranModel? _selectedMethod;

  @override
  void initState() {
    super.initState();
    context.read<PembayaranBloc>().add(const FetchPaymentChannelsEvent());
  }

  void _onCheckout() {
    if (_selectedMethod != null) {
      context.read<KoinBloc>().add(
            CheckoutKoinEvent(
              packageId: widget.package.id,
              paymentChannelId: _selectedMethod!.id,
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
          'Metode Pembayaran',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocListener<KoinBloc, KoinState>(
        listener: (context, state) {
          if (state is KoinCheckoutSuccess) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<KoinBloc>(),
                  child: KonfirmasiKoinPage(transaction: state.transaction),
                ),
              ),
            );
          } else if (state is KoinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        child: BlocBuilder<PembayaranBloc, PembayaranState>(
          builder: (context, state) {
            if (state is PembayaranLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PembayaranError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<PembayaranBloc>()
                          .add(const FetchPaymentChannelsEvent()),
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            }

            List<MetodePembayaranModel> channels = [];
            if (state is PaymentChannelsLoaded) {
              channels = state.channels;
            }

            if (channels.isEmpty) {
              return const Center(
                child: Text('Tidak ada metode pembayaran yang tersedia.'),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ringkasan Pembelian
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ringkasan',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.package.jumlahKoin} Koin',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          widget.package.hargaFormatted,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text(
                    'Pilih Metode Pembayaran',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ...channels.map((method) => _buildMethodCard(method)),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
          child: BlocBuilder<KoinBloc, KoinState>(
            builder: (context, state) {
              final isLoading = state is KoinLoading;
              return SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed:
                      _selectedMethod == null || isLoading ? null : _onCheckout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.textMuted,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          'Lanjutkan Pembayaran',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard(MetodePembayaranModel method) {
    final isSelected = _selectedMethod?.id == method.id;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedMethod = method;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primaryLight.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.secondarySurface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    method.isQris
                        ? Icons.qr_code_2_rounded
                        : Icons.account_balance_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  method.nama,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 6 : 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
