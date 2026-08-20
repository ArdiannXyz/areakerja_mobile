import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/validators.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/error_widget.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../data/models/lowongan_model.dart';
import '../bloc/lowongan_bloc.dart';

class FormLamaranPage extends StatefulWidget {
  final LowonganModel lowongan;

  const FormLamaranPage({super.key, required this.lowongan});

  @override
  State<FormLamaranPage> createState() => _FormLamaranPageState();
}

class _FormLamaranPageState extends State<FormLamaranPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _experienceController = TextEditingController(text: '2');
  final _salaryController = TextEditingController();
  final _portfolioController = TextEditingController();
  final _coverLetterController = TextEditingController();

  String _selectedEducation = 'S1 / Sarjana';
  final String _selectedFileName = 'Curriculum_Vitae_Terbaru.pdf';

  @override
  void initState() {
    super.initState();
    _prefillUserData();
  }

  void _prefillUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      _nameController.text = authState.user.name;
      _emailController.text = authState.user.email;
      if (authState.user.phone != null) {
        _phoneController.text = authState.user.phone!;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _experienceController.dispose();
    _salaryController.dispose();
    _portfolioController.dispose();
    _coverLetterController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = LamaranRequestModel(
        lowonganId: widget.lowongan.id,
        namaLengkap: _nameController.text.trim(),
        email: _emailController.text.trim(),
        nomorHp: _phoneController.text.trim(),
        pendidikanTerakhir: _selectedEducation,
        pengalamanTahun: '${_experienceController.text.trim()} Tahun',
        ekspektasiGaji: _salaryController.text.trim(),
        portofolioUrl: _portfolioController.text.trim(),
        coverLetter: _coverLetterController.text.trim(),
        resumeFileName: _selectedFileName,
      );

      context.read<LowonganBloc>().add(SubmitLamaranEvent(request));
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.successLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: AppColors.success, size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                'Lamaran Terkirim!',
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                text: 'Kembali ke Lowongan',
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Formulir Lamaran', style: AppTextStyles.heading3),
      ),
      body: BlocConsumer<LowonganBloc, LowonganState>(
        listener: (context, state) {
          if (state is LamaranSuccessState) {
            _showSuccessDialog(state.message);
          } else if (state is LowonganErrorState) {
            AppSnackbar.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is LamaranSubmittingState;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Job Summary Mini Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        borderRadius: AppDimensions.borderRadiusM,
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.work_rounded, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.lowongan.judul,
                                  style: AppTextStyles.labelLarge.copyWith(fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.lowongan.namaPerusahaan,
                                  style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.space2XL),

                    Text('Data Diri Pelamar', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                    const SizedBox(height: AppDimensions.spaceM),

                    CustomTextField(
                      label: 'Nama Lengkap',
                      controller: _nameController,
                      isRequired: true,
                      prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.textSecondary, size: 20),
                      validator: (val) => Validators.validateRequired(val, fieldName: 'Nama lengkap'),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    CustomTextField(
                      label: 'Email',
                      controller: _emailController,
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary, size: 20),
                      validator: Validators.validateEmail,
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    CustomTextField(
                      label: 'Nomor Telepon / WhatsApp',
                      controller: _phoneController,
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary, size: 20),
                      validator: Validators.validatePhone,
                    ),
                    const SizedBox(height: AppDimensions.space2XL),

                    Text('Kualifikasi & Pengalaman', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                    const SizedBox(height: AppDimensions.spaceM),

                    // Education dropdown
                    Text('Pendidikan Terakhir *', style: AppTextStyles.labelLarge.copyWith(fontSize: 13.5)),
                    const SizedBox(height: AppDimensions.spaceS),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedEducation,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.school_outlined, color: AppColors.textSecondary, size: 20),
                      ),
                      items: ['SMA / SMK', 'Diploma (D3)', 'S1 / Sarjana', 'S2 / Magister', 'S3 / Doktor']
                          .map((edu) => DropdownMenuItem(value: edu, child: Text(edu)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedEducation = val);
                      },
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            label: 'Pengalaman (Thn)',
                            controller: _experienceController,
                            isRequired: true,
                            keyboardType: TextInputType.number,
                            prefixIcon: const Icon(Icons.history_edu_rounded, color: AppColors.textSecondary, size: 20),
                            validator: (val) => Validators.validateRequired(val, fieldName: 'Pengalaman'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomTextField(
                            label: 'Ekspektasi Gaji',
                            hintText: 'Contoh: 10 Jt',
                            controller: _salaryController,
                            prefixIcon: const Icon(Icons.payments_outlined, color: AppColors.textSecondary, size: 20),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    CustomTextField(
                      label: 'Tautan Portofolio / GitHub / LinkedIn',
                      hintText: 'https://...',
                      controller: _portfolioController,
                      prefixIcon: const Icon(Icons.link_rounded, color: AppColors.textSecondary, size: 20),
                    ),
                    const SizedBox(height: AppDimensions.space2XL),

                    // Resume / CV Attachment Section
                    Text('Lampiran Dokumen CV *', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
                    const SizedBox(height: AppDimensions.spaceM),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: AppDimensions.borderRadiusM,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.dangerLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.danger, size: 24),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedFileName,
                                  style: AppTextStyles.labelLarge.copyWith(fontSize: 13),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text('PDF (Maks. 5MB)', style: AppTextStyles.caption),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('CV terbaru telah diperbarui.')),
                              );
                            },
                            child: const Text('Ganti File'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spaceL),

                    CustomTextField(
                      label: 'Surat Lamaran / Catatan Pengantar',
                      hintText: 'Tuliskan secara singkat mengapa Anda cocok untuk posisi ini...',
                      controller: _coverLetterController,
                      maxLines: 4,
                    ),
                    const SizedBox(height: AppDimensions.space2XL),

                    PrimaryButton(
                      text: 'Kirim Lamaran Sekarang',
                      isLoading: isLoading,
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                      onPressed: _onSubmit,
                    ),
                    const SizedBox(height: AppDimensions.space2XL),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
