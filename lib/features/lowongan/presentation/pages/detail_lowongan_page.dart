import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/lowongan_model.dart';
import '../bloc/lowongan_bloc.dart';
import 'daftar_lowongan_page.dart';
import 'form_lamaran_page.dart';

class DetailLowonganPage extends StatefulWidget {
  final LowonganModel lowongan;

  const DetailLowonganPage({super.key, required this.lowongan});

  @override
  State<DetailLowonganPage> createState() => _DetailLowonganPageState();
}

class _DetailLowonganPageState extends State<DetailLowonganPage> {
  late LowonganModel _job;

  @override
  void initState() {
    super.initState();
    _job = widget.lowongan;
  }

  void _toggleBookmark() {
    context.read<LowonganBloc>().add(ToggleFavoriteJobEvent(_job.id));
    setState(() {
      _job = _job.copyWith(isFavorit: !_job.isFavorit);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gajiText = _formatGajiText(_job);
    final daysAgo = _getDaysAgoText(_job);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: Color(0xFF0F172A), size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Detail Lowongan',
          style: TextStyle(
            fontSize: 17.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _job.isFavorit ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded,
              color: _job.isFavorit ? const Color(0xFFFF5E14) : const Color(0xFF64748B),
              size: 24,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. CENTERED COMPANY & JOB HEADER (Matching Screenshot 2)
            Center(
              child: Column(
                children: [
                  const SevenIncLogoWidget(size: 60),
                  const SizedBox(height: 14),
                  Text(
                    _job.judul,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _job.namaPerusahaan,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _job.lokasi,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF64748B),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13.5,
                        color: Color(0xFF64748B),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        daysAgo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),
            const Divider(color: Color(0xFFE2E8F0), thickness: 1),
            const SizedBox(height: 16),

            // 2. DESKRIPSI PEKERJAAN (Matching Screenshot 2)
            const Text(
              'Deskripsi Pekerjaan',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            ..._buildBulletList(_getJobDescriptions(_job)),

            const SizedBox(height: 20),

            // 3. SYARAT PEKERJAAN (Matching Screenshot 2)
            const Text(
              'Syarat Pekerjaan',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 10),
            ..._buildBulletList(_getJobRequirements(_job)),

            const SizedBox(height: 20),

            // 4. SPECIFICATION KEY-VALUE ITEMS (Matching Screenshot 2 & 3)
            _buildSpecItem('Jenis Lowongan', _job.tipePekerjaan),
            const SizedBox(height: 14),

            _buildSpecItem('Gaji', gajiText),
            const SizedBox(height: 14),

            _buildSpecItem('Pendidikan', 'D4/S1 - Teknologi Informasi'),
            const SizedBox(height: 14),

            _buildSpecItem('Umur', '25 Tahun'),
            const SizedBox(height: 14),

            _buildSpecItem('Jenis Kelamin', 'Laki-laki/Perempuan'),

            const SizedBox(height: 22),
            const Divider(color: Color(0xFFE2E8F0), thickness: 1),
            const SizedBox(height: 16),

            // 5. LOWONGAN SEVEN INC LAINNYA (Matching Screenshot 3)
            Text(
              'Lowongan ${_job.namaPerusahaan} lainnya',
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),
            _buildRelatedJobsList(),

            const SizedBox(height: 28),

            // 6. BOTTOM CTA: LAMAR SEKARANG
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5E14),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => FormLamaranPage(lowongan: _job),
                    ),
                  );
                },
                child: const Text(
                  'Lamar Sekarang',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Bullet Point Item Widget ---
  List<Widget> _buildBulletList(List<String> items) {
    return items.map((text) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 4, right: 8),
              child: Icon(
                Icons.arrow_right_rounded,
                size: 16,
                color: Color(0xFF334155),
              ),
            ),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF334155),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // --- Spec Key-Value Item ---
  Widget _buildSpecItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            color: Color(0xFF475569),
          ),
        ),
      ],
    );
  }

  // --- Related Jobs Horizontal Carousel ---
  Widget _buildRelatedJobsList() {
    final relatedJobs = [
      LowonganModel(
        id: 'rel_1',
        judul: 'UI/UX Designer',
        namaPerusahaan: _job.namaPerusahaan,
        lokasi: _job.lokasi,
        tipePekerjaan: 'Full Time',
        kategori: _job.kategori,
        gajiMin: _job.gajiMin ?? 8000000,
        gajiMax: _job.gajiMax ?? 10000000,
        deskripsi: _job.deskripsi,
      ),
      LowonganModel(
        id: 'rel_2',
        judul: 'UI/UX Designer',
        namaPerusahaan: _job.namaPerusahaan,
        lokasi: _job.lokasi,
        tipePekerjaan: 'Full Time',
        kategori: _job.kategori,
        gajiMin: _job.gajiMin ?? 8000000,
        gajiMax: _job.gajiMax ?? 10000000,
        deskripsi: _job.deskripsi,
      ),
      LowonganModel(
        id: 'rel_3',
        judul: 'UI/UX Designer',
        namaPerusahaan: _job.namaPerusahaan,
        lokasi: _job.lokasi,
        tipePekerjaan: 'Full Time',
        kategori: _job.kategori,
        gajiMin: _job.gajiMin ?? 8000000,
        gajiMax: _job.gajiMax ?? 10000000,
        deskripsi: _job.deskripsi,
      ),
    ];

    return SizedBox(
      height: 248,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: relatedJobs.length,
        separatorBuilder: (_, _) => const SizedBox(width: 14),
        itemBuilder: (context, index) {
          final relJob = relatedJobs[index];
          return LowonganVerticalCard(job: relJob);
        },
      ),
    );
  }

  String _formatGajiText(LowonganModel j) {
    if (j.gajiMin != null && j.gajiMax != null) {
      return 'Rp. ${_formatNumber(j.gajiMin!)} - Rp. ${_formatNumber(j.gajiMax!)} per bulan';
    }
    return 'Rp. 8.000.000 - Rp. 10.000.000 per bulan';
  }

  String _formatNumber(num n) {
    final s = n.toInt().toString();
    return s.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _getDaysAgoText(LowonganModel j) {
    if (j.createdAt != null) {
      final days = DateTime.now().difference(j.createdAt!).inDays;
      if (days > 0) return 'Dipasang $days hari yang lalu';
    }
    return 'Dipasang 7 hari yang lalu';
  }

  List<String> _getJobDescriptions(LowonganModel j) {
    if (j.deskripsi.isNotEmpty && j.deskripsi.contains('\n')) {
      return j.deskripsi.split('\n').where((s) => s.trim().isNotEmpty).toList();
    }
    return const [
      'Lorem ipsum dolor sit amet consectetur.',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
    ];
  }

  List<String> _getJobRequirements(LowonganModel j) {
    if (j.persyaratan.isNotEmpty) {
      return j.persyaratan;
    }
    return const [
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
      'Lorem ipsum dolor sit amet consectetur. Sed et',
    ];
  }
}
