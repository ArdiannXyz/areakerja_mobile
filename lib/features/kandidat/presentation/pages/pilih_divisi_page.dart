import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/divisi_model.dart';
import '../bloc/kandidat_bloc.dart';

class PilihDivisiPage extends StatefulWidget {
  const PilihDivisiPage({super.key});

  @override
  State<PilihDivisiPage> createState() => _PilihDivisiPageState();
}

class _PilihDivisiPageState extends State<PilihDivisiPage> {
  static const _orange = Color(0xFFFF5E14);
  DivisiModel? _selectedDivisi;

  @override
  void initState() {
    super.initState();
    context.read<KandidatBloc>().add(const FetchDivisiListEvent());
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
          'Pilih Divisi',
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
                        .read<KandidatBloc>()
                        .add(const FetchDivisiListEvent()),
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

          List<DivisiModel> divisiList = [];
          if (state is KandidatDivisiLoaded) {
            divisiList = state.divisiList;
          }

          if (divisiList.isEmpty) {
            return const Center(
              child: Text(
                'Tidak ada divisi yang tersedia saat ini.',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Program Pelatihan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pilih divisi yang sesuai dengan minat dan bakat kamu.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 20),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: divisiList.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final divisi = divisiList[index];
                    return _buildDivisiCard(divisi);
                  },
                ),
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
              onPressed: _selectedDivisi == null
                  ? null
                  : () {
                      Navigator.of(context).pushNamed(
                        '/kandidat/lengkapi-data',
                        arguments: {'divisi': _selectedDivisi},
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

  Widget _buildDivisiCard(DivisiModel divisi) {
    final isSelected = _selectedDivisi?.id == divisi.id;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return InkWell(
      onTap: () {
        setState(() {
          _selectedDivisi = divisi;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? _orange.withValues(alpha: 0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _orange : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    divisi.nama,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color:
                          isSelected ? _orange : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    divisi.deskripsi ?? '',
                    style: const TextStyle(
                      fontSize: 12.5,
                      color: Color(0xFF64748B),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Deposit: ${currencyFormatter.format(divisi.jumlahDeposit)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 24,
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
