import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/job_card.dart';
import '../../data/models/lowongan_model.dart';
import '../bloc/lowongan_bloc.dart';

class DaftarLowonganPage extends StatefulWidget {
  final String? initialCategory;

  const DaftarLowonganPage({super.key, this.initialCategory});

  @override
  State<DaftarLowonganPage> createState() => _DaftarLowonganPageState();
}

class _DaftarLowonganPageState extends State<DaftarLowonganPage> {
  final _searchController = TextEditingController();
  String _selectedCategory = 'Semua';
  String? _selectedTipe;

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    _loadJobs();
  }

  void _loadJobs() {
    context.read<LowonganBloc>().add(
          FetchLowonganListEvent(
            keyword: _searchController.text.trim(),
            kategori: _selectedCategory,
            tipe: _selectedTipe,
          ),
        );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String catName) {
    setState(() {
      _selectedCategory = catName;
    });
    _loadJobs();
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        String? tempTipe = _selectedTipe;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Filter Lowongan', style: AppTextStyles.heading3),
                      TextButton(
                        onPressed: () {
                          setModalState(() => tempTipe = null);
                          setState(() => _selectedTipe = null);
                          Navigator.pop(ctx);
                          _loadJobs();
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Tipe Pekerjaan', style: AppTextStyles.labelLarge),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: ['Semua', 'Full Time', 'Part Time', 'Remote', 'Freelance', 'Magang'].map((t) {
                      final isSel = (tempTipe == null && t == 'Semua') || tempTipe == t;
                      return ChoiceChip(
                        label: Text(t),
                        selected: isSel,
                        selectedColor: AppColors.primarySurface,
                        labelStyle: TextStyle(
                          color: isSel ? AppColors.primaryDark : AppColors.textPrimary,
                          fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
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
                      onPressed: () {
                        setState(() => _selectedTipe = tempTipe);
                        Navigator.pop(ctx);
                        _loadJobs();
                      },
                      child: const Text('Terapkan Filter'),
                    ),
                  ),
                ],
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Eksplorasi Lowongan',
          style: AppTextStyles.heading3,
        ),
      ),
      body: Column(
        children: [
          // Search & Filter Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: _searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _loadJobs(),
                      decoration: InputDecoration(
                        hintText: 'Cari posisi, skill, atau perusahaan...',
                        hintStyle: AppTextStyles.caption.copyWith(fontSize: 13),
                        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textSecondary),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  _loadJobs();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                InkWell(
                  onTap: _openFilterDialog,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: _selectedTipe != null ? AppColors.primarySurface : AppColors.inputBackground,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedTipe != null ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Icon(
                      Icons.tune_rounded,
                      color: _selectedTipe != null ? AppColors.primary : AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Categories Horizontal List
          BlocBuilder<LowonganBloc, LowonganState>(
            builder: (context, state) {
              List<KategoriLowonganModel> categories = [];
              if (state is LowonganLoaded) {
                categories = state.categories;
              }
              if (categories.isEmpty) {
                categories = const [
                  KategoriLowonganModel(id: '1', nama: 'Semua', icon: 'apps'),
                  KategoriLowonganModel(id: '2', nama: 'Teknologi & IT', icon: 'computer'),
                  KategoriLowonganModel(id: '3', nama: 'Desain & Kreatif', icon: 'palette'),
                  KategoriLowonganModel(id: '4', nama: 'Pemasaran & Sales', icon: 'campaign'),
                  KategoriLowonganModel(id: '5', nama: 'Keuangan & Akuntansi', icon: 'payments'),
                ];
              }

              return Container(
                height: 48,
                color: Colors.white,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final cat = categories[index];
                    final isSelected = _selectedCategory == cat.nama;

                    return ChoiceChip(
                      label: Text(cat.nama),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.inputBackground,
                      labelStyle: TextStyle(
                        fontSize: 12.5,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      onSelected: (_) => _onCategorySelected(cat.nama),
                    );
                  },
                ),
              );
            },
          ),
          const Divider(height: 1),

          // Jobs List View
          Expanded(
            child: BlocBuilder<LowonganBloc, LowonganState>(
              builder: (context, state) {
                if (state is LowonganLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  );
                }

                if (state is LowonganLoaded) {
                  if (state.jobs.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'Lowongan Tidak Ditemukan',
                      message: 'Coba ubah kata kunci pencarian atau filter kategori Anda.',
                      actionButtonText: 'Reset Pencarian',
                      onActionPressed: () {
                        _searchController.clear();
                        _selectedCategory = 'Semua';
                        _selectedTipe = null;
                        _loadJobs();
                      },
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () async => _loadJobs(),
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.jobs.length,
                      itemBuilder: (context, index) {
                        final job = state.jobs[index];
                        return JobCard(
                          lowongan: job,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/lowongan/detail',
                              arguments: {'lowongan': job},
                            );
                          },
                          onBookmarkTap: () {
                            context.read<LowonganBloc>().add(ToggleFavoriteJobEvent(job.id));
                          },
                        );
                      },
                    ),
                  );
                }

                if (state is LowonganErrorState) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline_rounded,
                    title: 'Gagal Memuat Lowongan',
                    message: state.message,
                    actionButtonText: 'Coba Lagi',
                    onActionPressed: _loadJobs,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
