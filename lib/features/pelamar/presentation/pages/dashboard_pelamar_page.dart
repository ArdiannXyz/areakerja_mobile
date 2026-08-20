import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../kandidat/presentation/pages/dashboard_kandidat_page.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../../../lowongan/presentation/bloc/lowongan_bloc.dart';
import '../../../lowongan/presentation/pages/daftar_lowongan_page.dart';
import '../../../lowongan/presentation/pages/detail_lowongan_page.dart';
import '../../../notifikasi/presentation/bloc/notifikasi_bloc.dart';
import 'profil_pelamar_page.dart';

class DashboardPelamarPage extends StatefulWidget {
  const DashboardPelamarPage({super.key});

  @override
  State<DashboardPelamarPage> createState() => _DashboardPelamarPageState();
}

class _DashboardPelamarPageState extends State<DashboardPelamarPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<LowonganBloc>().add(const FetchLowonganListEvent());
    context.read<NotifikasiBloc>().add(const FetchNotifikasiEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _BerandaHomeView(
              onViewAllJobs: () {
                setState(() => _currentIndex = 1);
              },
            ),
            const DaftarLowonganPage(),
            const DashboardKandidatPage(),
            const ProfilPelamarPage(),
          ],
        ),
        bottomNavigationBar: _buildCustomBottomBar(),
      ),
    );
  }

  Widget _buildCustomBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.black.withValues(alpha: 0.06), width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                index: 0,
                label: 'Beranda',
                icon: Icons.home_filled,
                isHome: true,
              ),
              _buildNavItem(
                index: 1,
                label: 'Lowongan Ke..',
                icon: Icons.business_center_outlined,
              ),
              _buildNavItem(
                index: 2,
                label: 'Daftar Kandi..',
                icon: Icons.people_outline_rounded,
              ),
              _buildNavItem(
                index: 3,
                label: 'Profil',
                icon: Icons.person_outline_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
    bool isHome = false,
  }) {
    final isSelected = _currentIndex == index;
    const activeColor = Color(0xFFFF5E14);
    const inactiveColor = Color(0xFF64748B);

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isHome && isSelected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.home_filled, color: Colors.white, size: 20),
              )
            else
              Icon(
                icon,
                color: isSelected ? activeColor : inactiveColor,
                size: 24,
              ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 1. BERANDA HOME VIEW (Matching Screenshot)
// ---------------------------------------------------------------------------
class _BerandaHomeView extends StatefulWidget {
  final VoidCallback onViewAllJobs;

  const _BerandaHomeView({required this.onViewAllJobs});

  @override
  State<_BerandaHomeView> createState() => _BerandaHomeViewState();
}

class _BerandaHomeViewState extends State<_BerandaHomeView> {
  String _selectedCategory = 'Semua';
  final _searchController = TextEditingController();

  final List<String> _categories = [
    'Semua',
    'Teknologi',
    'Administrasi',
    'Ekonomi',
    'Pemasaran',
    'Desain',
    'Kesehatan',
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 11) return 'Selamat Pagi,';
    if (hour >= 11 && hour < 15) return 'Selamat Siang,';
    if (hour >= 15 && hour < 18) return 'Selamat Sore,';
    return 'Selamat Malam,';
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userName = authState is Authenticated ? authState.user.name : 'Nama Pengguna';

    return RefreshIndicator(
      color: const Color(0xFFFF5E14),
      onRefresh: () async {
        context.read<LowonganBloc>().add(const FetchLowonganListEvent());
        context.read<NotifikasiBloc>().add(const FetchNotifikasiEvent());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TOP ORANGE HEADER WITH WATERMARK CIRCLES
            _buildOrangeHeader(context, userName),

            const SizedBox(height: 16),

            // CATEGORY CHIPS
            _buildCategoryChips(),

            const SizedBox(height: 20),

            // REKOMENDASI SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Rekomendasi',
                style: AppTextStyles.heading3.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
            const SizedBox(height: 12),
            _buildRekomendasiSection(),

            const SizedBox(height: 24),

            // TERBARU SECTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Terbaru',
                    style: AppTextStyles.heading3.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onViewAllJobs,
                    borderRadius: BorderRadius.circular(20),
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF0F172A),
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildTerbaruSection(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // --- 1. Top Orange Header ---
  Widget _buildOrangeHeader(BuildContext context, String userName) {
    return Stack(
      children: [
        // Orange Container Background with Decorative Circles
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            bottom: 24,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFFFF5E14),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Notification Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getGreeting(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Notification Bell with Red Dot Badge
                  BlocBuilder<NotifikasiBloc, NotifikasiState>(
                    builder: (context, notifState) {
                      final hasUnread = notifState is NotifikasiLoaded && notifState.unreadCount > 0;

                      return InkWell(
                        onTap: () => Navigator.of(context).pushNamed('/notifikasi'),
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            if (hasUnread)
                              Positioned(
                                top: 6,
                                right: 6,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: const Color(0xFFFF5E14), width: 1.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),

              // Thin White Underline
              Container(
                height: 1,
                color: Colors.white.withValues(alpha: 0.35),
                margin: const EdgeInsets.only(top: 8, bottom: 12),
              ),

              // Subtitle
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontFamily: 'Inter',
                  ),
                  children: [
                    TextSpan(text: 'Temukan loker terbaru se-'),
                    TextSpan(
                      text: 'Indonesia',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' dengan mudah!'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: (query) {
                    if (query.trim().isNotEmpty) {
                      context.read<LowonganBloc>().add(FetchLowonganListEvent(keyword: query.trim()));
                      widget.onViewAllJobs();
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Cari...',
                    hintStyle: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF94A3B8),
                      size: 24,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.tune_rounded,
                        color: Color(0xFF1E293B),
                        size: 22,
                      ),
                      onPressed: () {
                        widget.onViewAllJobs();
                      },
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Background decorative circles (Watermark effect matching design)
        Positioned(
          top: -30,
          right: -20,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
        ),
      ],
    );
  }

  // --- 2. Category Chips ---
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat;

          return InkWell(
            onTap: () {
              setState(() => _selectedCategory = cat);
              context.read<LowonganBloc>().add(
                    FetchLowonganListEvent(kategori: cat == 'Semua' ? null : cat),
                  );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFF5E14) : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF475569),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // --- 3. Rekomendasi Section (Orange Horizontal Cards) ---
  Widget _buildRekomendasiSection() {
    return BlocBuilder<LowonganBloc, LowonganState>(
      builder: (context, state) {
        List<LowonganModel> jobs = [];
        if (state is LowonganLoaded) {
          jobs = state.jobs;
        }

        if (jobs.isEmpty) {
          jobs = _getFallbackFeaturedJobs();
        }

        return SizedBox(
          height: 172,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: jobs.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final job = jobs[index];
              return _RekomendasiOrangeCard(job: job);
            },
          ),
        );
      },
    );
  }

  // --- 4. Terbaru Section (White Vertical Cards) ---
  Widget _buildTerbaruSection() {
    return BlocBuilder<LowonganBloc, LowonganState>(
      builder: (context, state) {
        if (state is LowonganLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5E14)),
              ),
            ),
          );
        }

        List<LowonganModel> jobs = [];
        if (state is LowonganLoaded) {
          jobs = state.jobs;
        }

        if (jobs.isEmpty) {
          jobs = _getFallbackRecentJobs();
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: jobs.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final job = jobs[index];
            return _TerbaruWhiteCard(job: job);
          },
        );
      },
    );
  }

  List<LowonganModel> _getFallbackFeaturedJobs() {
    return [
      LowonganModel(
        id: 'rec_1',
        judul: 'UI/UX Design',
        namaPerusahaan: 'Seven Inc',
        lokasi: 'Sleman, Yogyakarta',
        tipePekerjaan: 'Full Time',
        kategori: 'Desain',
        gajiMin: 8000000,
        gajiMax: 10000000,
        deskripsi: 'Bertanggung jawab mendesain aplikasi web dan mobile.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LowonganModel(
        id: 'rec_2',
        judul: 'Mobile Flutter Engineer',
        namaPerusahaan: 'Seven Inc',
        lokasi: 'Sleman, Yogyakarta',
        tipePekerjaan: 'Full Time',
        kategori: 'Teknologi',
        gajiMin: 9000000,
        gajiMax: 14000000,
        deskripsi: 'Mengembangkan aplikasi mobile Flutter.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  List<LowonganModel> _getFallbackRecentJobs() {
    return [
      LowonganModel(
        id: 'rec_1',
        judul: 'UI/UX Design',
        namaPerusahaan: 'Seven Inc',
        lokasi: 'Sleman, Yogyakarta',
        tipePekerjaan: 'Fulltime',
        kategori: 'Desain',
        gajiMin: 8000000,
        gajiMax: 10000000,
        deskripsi: 'Bertanggung jawab mendesain antarmuka aplikasi.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      LowonganModel(
        id: 'rec_2',
        judul: 'Frontend Web Developer',
        namaPerusahaan: 'Seven Inc',
        lokasi: 'Sleman, Yogyakarta',
        tipePekerjaan: 'Fulltime',
        kategori: 'Teknologi',
        gajiMin: 7500000,
        gajiMax: 11000000,
        deskripsi: 'Mengembangkan UI web modern.',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}

// ---------------------------------------------------------------------------
// 2. ORANGE REKOMENDASI CARD (Matching Screenshot)
// ---------------------------------------------------------------------------
class _RekomendasiOrangeCard extends StatelessWidget {
  final LowonganModel job;

  const _RekomendasiOrangeCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailLowonganPage(lowongan: job)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 275,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF5E14),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF5E14).withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title & Tags Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.judul,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      _formatSalary(job),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        job.tipePekerjaan,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Company Logo & Info Row + Expiry text
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Logo Container
                Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.business_rounded,
                          color: Color(0xFFFF5E14),
                          size: 20,
                        ),
                        Text(
                          job.namaPerusahaan.split(' ').first.toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 7.5,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.namaPerusahaan,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13.5,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        job.lokasi,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 11.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  '30 hari lagi',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatSalary(LowonganModel j) {
    if (j.gajiMin != null && j.gajiMax != null) {
      final min = (j.gajiMin! / 1000000).toStringAsFixed(0);
      final max = (j.gajiMax! / 1000000).toStringAsFixed(0);
      return 'Rp $min - $max Juta/bulan';
    }
    return 'Rp 8 - 10 Juta/bulan';
  }
}

// ---------------------------------------------------------------------------
// 3. TERBARU WHITE CARD (Matching Screenshot)
// ---------------------------------------------------------------------------
class _TerbaruWhiteCard extends StatelessWidget {
  final LowonganModel job;

  const _TerbaruWhiteCard({required this.job});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => DetailLowonganPage(lowongan: job)),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Salary Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.judul,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatShortSalary(job),
                  style: const TextStyle(
                    color: Color(0xFFFF5E14),
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Company Name with Icon
            Row(
              children: [
                const Icon(
                  Icons.apartment_rounded,
                  color: Color(0xFF64748B),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    job.namaPerusahaan,
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Work Type with Hourglass Icon
            Row(
              children: [
                const Icon(
                  Icons.hourglass_empty_rounded,
                  color: Color(0xFF64748B),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  job.tipePekerjaan,
                  style: const TextStyle(
                    color: Color(0xFF334155),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),

            // Location with Pin Icon & Time Ago on right
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Color(0xFF64748B),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    job.lokasi,
                    style: const TextStyle(
                      color: Color(0xFF334155),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Text(
                  '1 hari lalu',
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatShortSalary(LowonganModel j) {
    if (j.gajiMin != null && j.gajiMax != null) {
      final min = (j.gajiMin! / 1000000).toStringAsFixed(0);
      final max = (j.gajiMax! / 1000000).toStringAsFixed(0);
      return 'Rp $min-$max jt';
    }
    return 'Rp 8-10 jt';
  }
}
