import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../data/models/profil_perusahaan_model.dart';
import '../bloc/perusahaan_bloc.dart';

class EditProfilPerusahaanPage extends StatefulWidget {
  final ProfilPerusahaanModel profile;

  const EditProfilPerusahaanPage({super.key, required this.profile});

  @override
  State<EditProfilPerusahaanPage> createState() =>
      _EditProfilPerusahaanPageState();
}

class _EditProfilPerusahaanPageState extends State<EditProfilPerusahaanPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _deskripsiCtrl;
  late TextEditingController _industriCtrl;
  late TextEditingController _websiteCtrl;
  late TextEditingController _alamatCtrl;
  late TextEditingController _teleponCtrl;
  late TextEditingController _ukuranCtrl;
  late TextEditingController _tahunBerdiriCtrl;

  @override
  void initState() {
    super.initState();
    _deskripsiCtrl =
        TextEditingController(text: widget.profile.deskripsi ?? '');
    _industriCtrl = TextEditingController(text: widget.profile.industri ?? '');
    _websiteCtrl = TextEditingController(text: widget.profile.website ?? '');
    _alamatCtrl = TextEditingController(text: widget.profile.alamat ?? '');
    _teleponCtrl = TextEditingController(text: widget.profile.telepon ?? '');
    _ukuranCtrl =
        TextEditingController(text: widget.profile.jumlahKaryawan?.toString() ?? '');
    _tahunBerdiriCtrl =
        TextEditingController(text: widget.profile.tahunBerdiri ?? '');
  }

  @override
  void dispose() {
    _deskripsiCtrl.dispose();
    _industriCtrl.dispose();
    _websiteCtrl.dispose();
    _alamatCtrl.dispose();
    _teleponCtrl.dispose();
    _ukuranCtrl.dispose();
    _tahunBerdiriCtrl.dispose();
    super.dispose();
  }

  void _onSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedData = {
        'deskripsi': _deskripsiCtrl.text,
        'industri': _industriCtrl.text,
        'website': _websiteCtrl.text,
        'alamat': _alamatCtrl.text,
        'telepon': _teleponCtrl.text,
        'jumlah_karyawan': int.tryParse(_ukuranCtrl.text),
        'tahun_berdiri': _tahunBerdiriCtrl.text,
      };

      context.read<PerusahaanBloc>().add(UpdateProfileEvent(updatedData));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit Profil Perusahaan',
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: BlocConsumer<PerusahaanBloc, PerusahaanState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profil berhasil diperbarui!'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pop(); // Back to profile
            // Trigger refresh on parent
            context.read<PerusahaanBloc>().add(const FetchProfileEvent());
          } else if (state is PerusahaanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.danger,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PerusahaanLoading;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo/Avatar Upload
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primarySurface,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryLight,
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.apartment_rounded,
                            size: 48,
                            color: AppColors.primary,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  CustomTextField(
                    label: 'Industri',
                    controller: _industriCtrl,
                    hintText: 'Cth: Teknologi, Keuangan',
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    label: 'Ukuran Perusahaan',
                    controller: _ukuranCtrl,
                    hintText: 'Cth: 1-50 Karyawan',
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Tahun Berdiri',
                    controller: _tahunBerdiriCtrl,
                    hintText: 'Cth: 2015',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  
                  CustomTextField(
                    label: 'Website',
                    controller: _websiteCtrl,
                    hintText: 'Cth: https://www.perusahaan.com',
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Telepon Perusahaan',
                    controller: _teleponCtrl,
                    hintText: 'Cth: 021-1234567',
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Alamat',
                    controller: _alamatCtrl,
                    hintText: 'Alamat lengkap kantor pusat',
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Deskripsi Perusahaan',
                    controller: _deskripsiCtrl,
                    hintText: 'Ceritakan tentang visi & misi perusahaan',
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    text: 'Simpan Perubahan',
                    onPressed: isLoading ? null : _onSave,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
