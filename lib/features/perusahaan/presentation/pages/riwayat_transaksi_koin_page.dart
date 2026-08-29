import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/koin_model.dart';
import '../bloc/koin_bloc.dart';

class RiwayatTransaksiKoinPage extends StatefulWidget {
  const RiwayatTransaksiKoinPage({super.key});

  @override
  State<RiwayatTransaksiKoinPage> createState() =>
      _RiwayatTransaksiKoinPageState();
}

class _RiwayatTransaksiKoinPageState extends State<RiwayatTransaksiKoinPage> {
  @override
  void initState() {
    super.initState();
    context.read<KoinBloc>().add(const FetchTransactionHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Riwayat Transaksi',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocBuilder<KoinBloc, KoinState>(
        builder: (context, state) {
          if (state is KoinLoading || state is KoinInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is KoinError) {
            return Center(child: Text(state.message));
          }

          List<KoinTransactionModel> history = [];
          if (state is TransactionHistoryLoaded) {
            history = state.transactions;
          }

          if (history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 48,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada riwayat transaksi.',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<KoinBloc>().add(const FetchTransactionHistoryEvent());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final trx = history[index];
                return _TransactionCard(transaction: trx);
              },
            ),
          );
        },
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final KoinTransactionModel transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = transaction.status.toLowerCase() == 'berhasil';
    final bool isPending = transaction.status.toLowerCase() == 'pending' ||
        transaction.status.toLowerCase() == 'menunggu pembayaran';
        
    final Color statusColor = isSuccess
        ? AppColors.success
        : isPending
            ? AppColors.warning
            : AppColors.danger;

    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaction.noTransaksi,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  transaction.status,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            transaction.packageName ?? 'Pembelian Koin',
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${transaction.jumlahKoin} Koin',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formatCurrency.format(transaction.totalHarga),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (transaction.createdAt != null) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            Text(
              'Tanggal: ${transaction.createdAt}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
