import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/divisi_model.dart';
import '../../../pembayaran/data/models/pembayaran_model.dart';
import '../../../pembayaran/presentation/bloc/pembayaran_bloc/pembayaran_bloc.dart';

class PilihMetodePembayaranPage extends StatefulWidget {
  final DivisiModel divisi;

  const PilihMetodePembayaranPage({
    super.key,
    required this.divisi,
  });

  @override
  State<PilihMetodePembayaranPage> createState() =>
      _PilihMetodePembayaranPageState();
}

class _PilihMetodePembayaranPageState extends State<PilihMetodePembayaranPage> {
  static const _orange = Color(0xFFFF5E14);
  MetodePembayaranModel? _selectedMethod;

  @override
  void initState() {
    super.initState();
    context.read<PembayaranBloc>().add(const FetchPaymentChannelsEvent());
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
          'Metode Pembayaran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: BlocBuilder<PembayaranBloc, PembayaranState>(
        builder: (context, state) {
          if (state is PembayaranLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_orange),
              ),
            );
          }

          if (state is PembayaranError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: Color(0xFFCBD5E1), size: 64),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => context
                        .read<PembayaranBloc>()
                        .add(const FetchPaymentChannelsEvent()),
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

          List<MetodePembayaranModel> channels = [];
          if (state is PaymentChannelsLoaded) {
            channels = state.channels;
          }

          if (channels.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada metode pembayaran yang tersedia saat ini.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            );
          }

          final transferBanks =
              channels.where((c) => c.isTransferBank).toList();
          final qris = channels.where((c) => c.isQris).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (transferBanks.isNotEmpty) ...[
                  const Text(
                    'Transfer Bank',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: transferBanks.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildMethodCard(transferBanks[index]);
                    },
                  ),
                  const SizedBox(height: 24),
                ],
                if (qris.isNotEmpty) ...[
                  const Text(
                    'E-Wallet / QRIS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: qris.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildMethodCard(qris[index]);
                    },
                  ),
                ],
                const SizedBox(height: 100),
              ],
            ),
          );
        },
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
            child: ElevatedButton(
              onPressed: _selectedMethod == null
                  ? null
                  : () {
                      Navigator.of(context).pushNamed(
                        '/kandidat/konfirmasi-transaksi',
                        arguments: {
                          'divisi': widget.divisi,
                          'payment_method': _selectedMethod,
                        },
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFFE2E8F0),
                disabledForegroundColor: const Color(0xFF94A3B8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Lanjutkan'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodCard(MetodePembayaranModel method) {
    final isSelected = _selectedMethod?.id == method.id;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? _orange.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _orange : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Icon(
                  method.isQris ? Icons.qr_code_2_rounded : Icons.account_balance_rounded,
                  color: const Color(0xFF94A3B8),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                method.nama,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? _orange : const Color(0xFF0F172A),
                ),
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _orange : const Color(0xFFCBD5E1),
                  width: isSelected ? 6 : 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
