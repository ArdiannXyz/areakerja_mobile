import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lowongan_model.dart';
import '../bloc/lowongan_bloc.dart';
import 'detail_lowongan_page.dart';

class DaftarLowonganPage extends StatefulWidget {
  final String? initialCategory;

  const DaftarLowonganPage({super.key, this.initialCategory});

  @override
  State<DaftarLowonganPage> createState() => _DaftarLowonganPageState();
}

class _DaftarLowonganPageState extends State<DaftarLowonganPage> {
  final _searchController = TextEditingController();
  String? _selectedTipe;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() {
    context.read<LowonganBloc>().add(
          FetchLowonganListEvent(
            keyword: _searchController.text.trim(),
            tipe: _selectedTipe,
          ),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        String? tempTipe = _selectedTipe;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Filter Lowongan',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setModalState(() => tempTipe = null);
                            setState(() => _selectedTipe = null);
                            Navigator.pop(ctx);
                            _loadJobs();
                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Color(0xFFFF5E14),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Tipe Pekerjaan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF334155),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ['Semua', 'Full Time', 'Part Time', 'Remote', 'Freelance', 'Magang'].map((t) {
                        final isSel = (tempTipe == null && t == 'Semua') || tempTipe == t;
                        return ChoiceChip(
                          label: Text(t),
                          selected: isSel,
                          selectedColor: const Color(0xFFFF5E14).withValues(alpha: 0.12),
                          backgroundColor: const Color(0xFFF1F5F9),
                          labelStyle: TextStyle(
                            color: isSel ? const Color(0xFFFF5E14) : const Color(0xFF475569),
                            fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                            fontSize: 13,
                          ),
                          side: BorderSide(
                            color: isSel ? const Color(0xFFFF5E14) : const Color(0xFFE2E8F0),
                          ),
                          onSelected: (selected) {
                            setModalState(() {
                              tempTipe = (t == 'Semua' || !selected) ? null : t;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
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
                          setState(() => _selectedTipe = tempTipe);
                          Navigator.pop(ctx);
                          _loadJobs();
                        },
                        child: const Text('Terapkan Filter', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: const Color(0xFFFF5E14),
          onRefresh: () async => _loadJobs(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. TOP SEARCH & FILTER BAR (Matching Image 1)
                _buildSearchBar(),
                const SizedBox(height: 22),

                // 2. REKOMENDASI SECTION
                BlocBuilder<LowonganBloc, LowonganState>(
                  builder: (context, state) {
                    List<LowonganModel> jobs = [];
                    if (state is LowonganLoaded) {
                      jobs = state.jobs;
                    }
                    if (jobs.isEmpty) {
                      jobs = _getFallbackJobs();
                    }

                    final rekomendasiList = jobs;
                    final terbaruList = jobs.reversed.toList();
                    final tersimpanList = jobs.take(3).toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Section: Rekomendasi
                        _buildSectionHeader('Rekomendasi', onTap: () {}),
                        const SizedBox(height: 12),
                        _buildHorizontalJobList(rekomendasiList),
                        const SizedBox(height: 24),

                        // Section: Terbaru
                        _buildSectionHeader('Terbaru', onTap: () {}),
                        const SizedBox(height: 12),
                        _buildHorizontalJobList(terbaruList),
                        const SizedBox(height: 24),

                        // Section: Lowongan Tersimpan
                        _buildSectionHeader('Lowongan Tersimpan', onTap: () {}),
                        const SizedBox(height: 12),
                        _buildHorizontalJobList(tersimpanList),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Top Search & Filter Bar ---
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1.1),
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(
              Icons.search,
              color: Color(0xFF94A3B8),
              size: 22,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              onSubmitted: (_) => _loadJobs(),
              decoration: const InputDecoration(
                hintText: 'Cari...',
                hintStyle: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          InkWell(
            onTap: _openFilterDialog,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Icon(
                Icons.filter_alt_outlined,
                color: Color(0xFFFF5E14),
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Section Header with Chevron ---
  Widget _buildSectionHeader(String title, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF334155),
            size: 24,
          ),
        ],
      ),
    );
  }

  // --- Horizontal Job Carousel List ---
  Widget _buildHorizontalJobList(List<LowonganModel> jobs) {
    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: jobs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final job = jobs[index];
          return LowonganVerticalCard(job: job);
        },
      ),
    );
  }

  List<LowonganModel> _getFallbackJobs() {
    return [
      LowonganModel(
        id: 'job_1',
        judul: 'UI/UX Designer',
        namaPerusahaan: 'Seven Inc',
        lokasi: 'Sleman, Yogyakarta',
        tipePekerjaan: 'Full Time',
        kategori: 'Desain',
        gajiMin: 8000000,
        gajiMax: 10000000,
        deskripsi: 'Bertanggung jawab mendesain antarmuka aplikasi dan pengalaman pengguna.',
        persyaratan: const [
          'Menguasai Figma dan Adobe XD',
          'Memiliki portofolio desain UI/UX',
          'Pendidikan min D4/S1',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      LowonganModel(
        id: 'job_2',
        judul: 'UI/UX Designer',
        namaPerusahaan: 'Seven Inc',
        lokasi: 'Sleman, Yogyakarta',
        tipePekerjaan: 'Full Time',
        kategori: 'Desain',
        gajiMin: 8000000,
        gajiMax: 10000000,
        deskripsi: 'Mendesain layout dan prototype untuk aplikasi web dan mobile.',
        persyaratan: const [
          'Pengalaman 1-2 tahun di bidang UI/UX',
          'Mampu bekerja sama dalam tim',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      LowonganModel(
        id: 'job_3',
        judul: 'UI/UX Designer',
        namaPerusahaan: 'Seven Inc',
        lokasi: 'Sleman, Yogyakarta',
        tipePekerjaan: 'Full Time',
        kategori: 'Desain',
        gajiMin: 8000000,
        gajiMax: 10000000,
        deskripsi: 'Merancang wireframe, user flow, dan interaksi visual produk.',
        persyaratan: const [
          'Fasih menggunakan design system',
          'Memahami prinsip responsive design',
        ],
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}

// ===========================================================================
// LOWONGAN VERTICAL CARD (Matching Screenshot 1 & 3)
// ===========================================================================
class LowonganVerticalCard extends StatelessWidget {
  final LowonganModel job;
  final VoidCallback? onTap;

  const LowonganVerticalCard({
    super.key,
    required this.job,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DetailLowonganPage(lowongan: job),
                ),
              );
            },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 168,
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Centered Job Title
              Center(
                child: Text(
                  job.judul,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),

              // 2. Middle Centered Company Logo
              Center(
                child: SevenIncLogoWidget(size: 44),
              ),
              const Spacer(),

              // 3. Bottom Information Rows
              // Company name
              Row(
                children: [
                  const Icon(
                    Icons.domain_outlined,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      job.namaPerusahaan,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Work Type
              Row(
                children: [
                  const Icon(
                    Icons.hourglass_empty_rounded,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      job.tipePekerjaan,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Location
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Color(0xFF64748B),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      job.lokasi,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF334155),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// SEVEN INC LOGO WIDGET (Accurate Vector Mockup)
// ===========================================================================
class SevenIncLogoWidget extends StatelessWidget {
  final double size;

  const SevenIncLogoWidget({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stylized Chevrons
        SizedBox(
          width: size,
          height: size * 0.65,
          child: CustomPaint(
            painter: _SevenIncPainter(),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          'SEVEN',
          style: TextStyle(
            fontSize: size * 0.17,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
            color: const Color(0xFF0F172A),
            height: 1.0,
          ),
        ),
        Text(
          'INC.',
          style: TextStyle(
            fontSize: size * 0.13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
            color: const Color(0xFF0F172A),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}

class _SevenIncPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final redPaint = Paint()
      ..color = const Color(0xFFE11D48)
      ..style = PaintingStyle.fill;

    final darkPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.fill;

    // Top red chevron
    final redPath = Path();
    redPath.moveTo(size.width * 0.25, size.height * 0.08);
    redPath.lineTo(size.width * 0.45, size.height * 0.08);
    redPath.lineTo(size.width * 0.55, size.height * 0.35);
    redPath.lineTo(size.width * 0.35, size.height * 0.35);
    redPath.close();
    canvas.drawPath(redPath, redPaint);

    // Main dark chevron
    final darkPath1 = Path();
    darkPath1.moveTo(size.width * 0.15, size.height * 0.38);
    darkPath1.lineTo(size.width * 0.45, size.height * 0.38);
    darkPath1.lineTo(size.width * 0.70, size.height * 0.95);
    darkPath1.lineTo(size.width * 0.40, size.height * 0.95);
    darkPath1.close();
    canvas.drawPath(darkPath1, darkPaint);

    // Accent chevron cut
    final darkPath2 = Path();
    darkPath2.moveTo(size.width * 0.52, size.height * 0.38);
    darkPath2.lineTo(size.width * 0.75, size.height * 0.38);
    darkPath2.lineTo(size.width * 0.95, size.height * 0.85);
    darkPath2.lineTo(size.width * 0.72, size.height * 0.85);
    darkPath2.close();
    canvas.drawPath(darkPath2, darkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
