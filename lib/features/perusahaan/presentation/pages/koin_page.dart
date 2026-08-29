import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../data/models/koin_model.dart';
import '../bloc/koin_bloc.dart';
import 'beli_koin_page.dart';
import 'riwayat_transaksi_koin_page.dart';

class KoinPage extends StatefulWidget {
  const KoinPage({super.key});

  @override
  State<KoinPage> createState() => _KoinPageState();
}

class _KoinPageState extends State<KoinPage> {
  @override
  void initState() {
    super.initState();
    context.read<KoinBloc>().add(const FetchKoinPageDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocConsumer<KoinBloc, KoinState>(
        listener: (context, state) {
          if (state is KoinError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          int saldo = 0;
          List<KoinPackageModel> packages = [];
          bool isLoading = state is KoinLoading || state is KoinInitial;

          if (state is KoinPageLoaded) {
            saldo = state.saldoKoin;
            packages = state.packages;
          }

          return CustomScrollView(
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

              if (isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.spaceXL),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Coin balance hero card
                      _buildBalanceCard(context, saldo),
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
                      _buildCoinPackages(context, packages),
                      const SizedBox(height: AppDimensions.space2XL),

                      // Riwayat (Tombol navigasi ke halaman terpisah)
                      Text(
                        'Riwayat Transaksi',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spaceM),
                      _buildHistoryButton(context),
                    ]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context, int saldo) {
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
                '$saldo Koin',
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

  Widget _buildCoinPackages(BuildContext context, List<KoinPackageModel> packages) {
    if (packages.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(
            'Paket koin belum tersedia',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Column(
      children: packages.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: _CoinPackageCard(package: p),
        );
      }).toList(),
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<KoinBloc>(),
              child: const RiwayatTransaksiKoinPage(),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 28,
              color: AppColors.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lihat Semua Riwayat',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Riwayat pembelian dan penggunaan koin',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _CoinPackageCard extends StatelessWidget {
  final KoinPackageModel package;

  const _CoinPackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: package.isPopular ? AppColors.primary : AppColors.border,
          width: package.isPopular ? 1.5 : 1,
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
              color: package.isPopular
                  ? AppColors.primarySurface
                  : AppColors.secondarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.monetization_on_rounded,
              color: package.isPopular ? AppColors.primary : AppColors.textSecondary,
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
                      '${package.jumlahKoin} Koin',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (package.isPopular) ...[
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
                  package.deskripsi ?? package.nama,
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
                package.hargaFormatted,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: package.isPopular ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: context.read<KoinBloc>()),
                        ],
                        child: BeliKoinPage(package: package),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: package.isPopular
                      ? AppColors.primary
                      : AppColors.secondarySurface,
                  foregroundColor: package.isPopular
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

