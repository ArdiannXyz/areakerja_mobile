import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

/// Halaman Koin / Wallet — Tab Koin
/// TODO: Implementasi dengan saldo koin, riwayat transaksi, dan paket pembelian
class KoinPage extends StatelessWidget {
  const KoinPage({super.key});

  // Mock saldo — ganti dengan data dari BLoC/API
  static const int _mockSaldo = 850;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // AppBar
          SliverAppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            pinned: true,
            title: Text(
              'Koin & Wallet',
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Divider(height: 1, color: AppColors.border),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.spaceXL),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Coin balance hero card
                _buildBalanceCard(context),
                const SizedBox(height: AppDimensions.space2XL),

                // Paket koin
                Text(
                  'Paket Koin',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                _buildCoinPackages(context),
                const SizedBox(height: AppDimensions.space2XL),

                // Riwayat
                Text(
                  'Riwayat Transaksi',
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spaceM),
                _buildEmptyHistory(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B00), Color(0xFFFF9140)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.30),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo Koin',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.monetization_on_rounded,
                color: Colors.white,
                size: 36,
              ),
              const SizedBox(width: 10),
              Text(
                '$_mockSaldo Koin',
                style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Gunakan koin untuk mengakses fitur rekrutmen premium.',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackages(BuildContext context) {
    final packages = [
      _CoinPackage(
        koin: 100,
        harga: 'Rp 50.000',
        label: 'Starter',
        isBestValue: false,
      ),
      _CoinPackage(
        koin: 500,
        harga: 'Rp 200.000',
        label: 'Populer',
        isBestValue: true,
      ),
      _CoinPackage(
        koin: 1500,
        harga: 'Rp 500.000',
        label: 'Pro',
        isBestValue: false,
      ),
    ];

    return Column(
      children: packages.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _CoinPackageCard(package: p),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.receipt_long_outlined,
            size: 40,
            color: AppColors.textMuted,
          ),
          const SizedBox(height: 12),
          Text(
            'Belum ada riwayat transaksi',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPackage {
  final int koin;
  final String harga;
  final String label;
  final bool isBestValue;

  const _CoinPackage({
    required this.koin,
    required this.harga,
    required this.label,
    required this.isBestValue,
  });
}

class _CoinPackageCard extends StatelessWidget {
  final _CoinPackage package;

  const _CoinPackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: package.isBestValue ? AppColors.primary : AppColors.border,
          width: package.isBestValue ? 1.5 : 1,
        ),
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: package.isBestValue
                  ? AppColors.primarySurface
                  : AppColors.secondarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.monetization_on_rounded,
              color: package.isBestValue ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${package.koin} Koin',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (package.isBestValue) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Terlaris',
                          style: GoogleFonts.poppins(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  package.label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                package.harga,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: package.isBestValue ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {
                  // TODO: Trigger pembelian koin
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: package.isBestValue
                      ? AppColors.primary
                      : AppColors.secondarySurface,
                  foregroundColor: package.isBestValue
                      ? Colors.white
                      : AppColors.textPrimary,
                  elevation: 0,
                  minimumSize: const Size(70, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Beli',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
