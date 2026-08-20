import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class DaftarKandidatFlowSheet extends StatefulWidget {
  const DaftarKandidatFlowSheet({super.key});

  static Future<void> show(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const DaftarKandidatFlowSheet(),
    );

    if (result != null && context.mounted) {
      await Navigator.of(context).pushNamed(
        '/transaksi/detail',
        arguments: result,
      );
    }
  }

  @override
  State<DaftarKandidatFlowSheet> createState() => _DaftarKandidatFlowSheetState();
}

class _DaftarKandidatFlowSheetState extends State<DaftarKandidatFlowSheet> {
  // 1 = Bidang yang diminati, 2 = Metode Pembayaran, 3 = Konfirmasi Pembayaran
  int _currentStep = 1;

  // Selections
  String? _selectedDivisi;
  bool _isDivisiDropdownOpen = true;

  String _selectedPaymentMethod = 'Bank BCA'; // 'Bank BCA', 'Bank BRI', 'Bank BNI', 'QRIS'

  final List<String> _divisiList = [
    'Admin',
    'Videographer',
    'Human Resource',
    'UI/UX Design',
    'Desain Grafis',
    'Digital Marketing',
    'Web Developer',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Drag Handle & Title Header
              _buildModalHeader(),

              // Content based on step
              if (_currentStep == 1)
                _buildStep1BidangMinat()
              else if (_currentStep == 2)
                _buildStep2MetodePembayaran()
              else if (_currentStep == 3)
                _buildStep3KonfirmasiPembayaran(),
            ],
          ),
        ),
      ),
    );
  }

  // --- TOP MODAL HEADER ---
  Widget _buildModalHeader() {
    return Column(
      children: [
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Daftar Kandidat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1, color: Color(0xFFE2E8F0)),
      ],
    );
  }

  // =========================================================================
  // STEP 1: BIDANG YANG DIMINATI (Image 1)
  // =========================================================================
  Widget _buildStep1BidangMinat() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Bidang yang diminati',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // Divisi Dropdown / Selection List Box
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            ),
            child: Column(
              children: [
                // Header of the dropdown
                InkWell(
                  onTap: () {
                    setState(() {
                      _isDivisiDropdownOpen = !_isDivisiDropdownOpen;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDivisi ?? 'Divisi',
                          style: TextStyle(
                            fontSize: 14.5,
                            color: _selectedDivisi != null ? const Color(0xFF0F172A) : const Color(0xFF94A3B8),
                            fontWeight: _selectedDivisi != null ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        Icon(
                          _isDivisiDropdownOpen
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: const Color(0xFF64748B),
                        ),
                      ],
                    ),
                  ),
                ),

                // Option List
                if (_isDivisiDropdownOpen) ...[
                  const Divider(height: 1, color: Color(0xFFE2E8F0)),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 220),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      itemCount: _divisiList.length,
                      itemBuilder: (context, index) {
                        final item = _divisiList[index];
                        final isSelected = _selectedDivisi == item;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedDivisi = item;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Text(
                                  item,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected ? const Color(0xFFFF5E14) : const Color(0xFF334155),
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Button "Selanjutnya"
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E14),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                if (_selectedDivisi == null) {
                  setState(() {
                    _selectedDivisi = 'UI/UX Design';
                  });
                }
                setState(() {
                  _currentStep = 2;
                });
              },
              child: const Text(
                'Selanjutnya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // STEP 2: METODE PEMBAYARAN (Image 2)
  // =========================================================================
  Widget _buildStep2MetodePembayaran() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),

          // Payment Options Container Card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            ),
            child: Column(
              children: [
                // Transfer Bank Header Row
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Row(
                    children: [
                      const Icon(Icons.sync_alt_rounded, color: Color(0xFFFF5E14), size: 22),
                      const SizedBox(width: 12),
                      const Text(
                        'Transfer Bank',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFFFF5E14), size: 24),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFCBD5E1)),

                // Bank BCA
                _buildBankOption(
                  title: 'Bank BCA',
                  logo: _buildBankLogoWidget('BCA', const Color(0xFF003D79)),
                  isSelected: _selectedPaymentMethod == 'Bank BCA',
                  onTap: () => setState(() => _selectedPaymentMethod = 'Bank BCA'),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0), indent: 16, endIndent: 16),

                // Bank BRI
                _buildBankOption(
                  title: 'Bank BRI',
                  logo: _buildBankLogoWidget('BRI', const Color(0xFF00529C)),
                  isSelected: _selectedPaymentMethod == 'Bank BRI',
                  onTap: () => setState(() => _selectedPaymentMethod = 'Bank BRI'),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0), indent: 16, endIndent: 16),

                // Bank BNI
                _buildBankOption(
                  title: 'Bank BNI',
                  logo: _buildBankLogoWidget('BNI', const Color(0xFFF15A24)),
                  isSelected: _selectedPaymentMethod == 'Bank BNI',
                  onTap: () => setState(() => _selectedPaymentMethod = 'Bank BNI'),
                ),
                const Divider(height: 1, color: Color(0xFFCBD5E1)),

                // QRIS
                _buildBankOption(
                  title: 'QRIS',
                  logo: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'QRIS',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  isSelected: _selectedPaymentMethod == 'QRIS',
                  onTap: () => setState(() => _selectedPaymentMethod = 'QRIS'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Button "Selanjutnya"
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E14),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _currentStep = 3;
                });
              },
              child: const Text(
                'Selanjutnya',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankOption({
    required String title,
    required Widget logo,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 38, height: 26, child: Center(child: logo)),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF0F172A),
              ),
            ),
            const Spacer(),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFFFF5E14) : const Color(0xFFFF5E14),
                  width: 1.6,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF5E14),
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBankLogoWidget(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // =========================================================================
  // STEP 3: KONFIRMASI PEMBAYARAN (Image 3)
  // =========================================================================
  Widget _buildStep3KonfirmasiPembayaran() {
    final authState = context.read<AuthBloc>().state;
    final userName = authState is Authenticated ? authState.user.name : '(Nama Kandidat)';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header with Back Button
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _currentStep = 2;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Icon(Icons.chevron_left_rounded, color: Color(0xFF0F172A), size: 28),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  'Metode Pembayaran',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Summary Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
            ),
            child: Column(
              children: [
                _buildSummaryRow('No Transaksi', '118292236282'),
                const SizedBox(height: 14),
                _buildSummaryRow('Dari', userName),
                const SizedBox(height: 14),
                _buildSummaryRow('Ke', 'Areakerja.com'),
                const SizedBox(height: 14),
                _buildSummaryRow('Metode Pembayaran', _selectedPaymentMethod.contains('Bank') ? 'Transfer Bank' : 'QRIS'),
                const SizedBox(height: 14),
                _buildSummaryRow('Nama Bank', _selectedPaymentMethod),
                const SizedBox(height: 14),
                _buildSummaryRow('Jumlah Deposit', 'Rp. 200.000,-', isOrange: true),
                const SizedBox(height: 14),
                _buildSummaryRow('Biaya Admin', 'Rp. 2000,-', isOrange: true),
                const SizedBox(height: 14),
                _buildSummaryRow('Total Pembayaran', 'Rp. 202.000,-', isOrange: true, isBold: true),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Button "Konfirmasi"
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E14),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop({
                  'noTransaksi': 'AK0078223327',
                  'namaKandidat': userName,
                  'divisi': _selectedDivisi ?? 'UI/UX Design',
                  'bankName': _selectedPaymentMethod,
                  'totalPayment': 'Rp. 202.000,-',
                });
              },
              child: const Text(
                'Konfirmasi',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    bool isOrange = false,
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: const Color(0xFF0F172A),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14.5 : 13,
            color: isOrange ? const Color(0xFFFF5E14) : const Color(0xFF0F172A),
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
