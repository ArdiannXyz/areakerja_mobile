import 'package:flutter/material.dart';
import '../widgets/daftar_kandidat_flow_sheet.dart';

class DashboardKandidatPage extends StatelessWidget {
  const DashboardKandidatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. TOP HEADER TITLE & ACTION ICON
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              fontSize: 21,
                              color: Color(0xFF0F172A),
                              fontFamily: 'Inter',
                              height: 1.25,
                            ),
                            children: [
                              TextSpan(
                                text: 'Benefit ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: 'Menjadi kandidat',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Areakerja.com',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                    // Top Right Checklist Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFFF5E14),
                          width: 1.6,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.checklist_rtl_rounded,
                          color: Color(0xFFFF5E14),
                          size: 26,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. ORANGE BENEFIT CARD
              _buildBenefitCard(),

              const SizedBox(height: 24),

              // 3. CARA DAFTAR KANDIDAT SECTION
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Cara Daftar Kandidat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // 4. 2x2 QUADRANT STEPS GRID
              _buildQuadrantSteps(),

              const SizedBox(height: 20),

              // 5. PROMOTIONAL HEADLINE TEXT
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Ikuti pelatihan terakreditasi Areakerja.com dan dapatkan pekerjaan impian anda!',
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 6. DAFTAR SEKARANG CTA BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => DaftarKandidatFlowSheet.show(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF5E14),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Daftar Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- BENEFIT CARD ---
  Widget _buildBenefitCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFF5E14),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF5E14).withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Decorative subtle organic wave watermarks
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE04A05).withValues(alpha: 0.5),
                ),
              ),
            ),
            Positioned(
              bottom: -40,
              left: 40,
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFE04A05).withValues(alpha: 0.4),
                ),
              ),
            ),

            // Benefits content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Column(
                children: [
                  _buildBenefitRow(
                    iconWidget: const Icon(
                      Icons.leaderboard_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    text: 'Menjadi prioritas pilihan dari perusahaan mitra Areakerja',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitRow(
                    iconWidget: const Icon(
                      Icons.handshake_outlined,
                      color: Colors.white,
                      size: 22,
                    ),
                    text: 'Areakerja memiliki banyak mitra perusahaan yang sedang membuka lowongan',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitRow(
                    iconWidget: const Icon(
                      Icons.gavel_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    text: 'Areakerja merupakan perusahaan terpercaya dibadan hukum',
                  ),
                  const SizedBox(height: 16),
                  _buildBenefitRow(
                    iconWidget: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(
                          Icons.chat_bubble_outline_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: const Text(
                            '24',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    text: 'Areakerja memberikan fasilitas dan konsultasi secara lifetime',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow({
    required Widget iconWidget,
    required String text,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          child: Center(child: iconWidget),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // --- 2x2 QUADRANT STEPS ---
  Widget _buildQuadrantSteps() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Top Row: 01 (Orange) & 02 (Golden Yellow)
            Row(
              children: [
                Expanded(
                  child: _buildQuadrantTile(
                    number: '01',
                    text: 'Klik daftar untuk regristrasi kandidat',
                    backgroundColor: const Color(0xFFFF5E14),
                  ),
                ),
                Expanded(
                  child: _buildQuadrantTile(
                    number: '02',
                    text: 'Lengkapi data yang diperlukan pada proses registrasi',
                    backgroundColor: const Color(0xFFF5A623),
                  ),
                ),
              ],
            ),
            // Bottom Row: 03 (Golden Yellow) & 04 (Orange)
            Row(
              children: [
                Expanded(
                  child: _buildQuadrantTile(
                    number: '03',
                    text: 'Tunggu pemberitahuan setelah melakukan registrasi',
                    backgroundColor: const Color(0xFFF5A623),
                  ),
                ),
                Expanded(
                  child: _buildQuadrantTile(
                    number: '04',
                    text: 'Ikuti pelatihan sesuai prosedur Areakerja.com',
                    backgroundColor: const Color(0xFFFF5E14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuadrantTile({
    required String number,
    required String text,
    required Color backgroundColor,
  }) {
    return Container(
      height: 130,
      padding: const EdgeInsets.all(16),
      color: backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                height: 1.3,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
