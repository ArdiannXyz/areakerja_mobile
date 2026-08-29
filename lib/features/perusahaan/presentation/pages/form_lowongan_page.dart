import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../../lowongan/data/models/lowongan_model.dart';
import '../bloc/perusahaan_bloc.dart';

class FormLowonganPage extends StatefulWidget {
  final LowonganModel? existingJob;

  const FormLowonganPage({super.key, this.existingJob});

  @override
  State<FormLowonganPage> createState() => _FormLowonganPageState();
}

class _FormLowonganPageState extends State<FormLowonganPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _gajiMinController = TextEditingController();
  final _gajiMaxController = TextEditingController();

  String _tipePekerjaan = 'Full-time';
  final List<String> _tipeList = ['Full-time', 'Part-time', 'Freelance', 'Kontrak', 'Magang'];

  bool get isEdit => widget.existingJob != null;

  @override
  void initState() {
    super.initState();
    if (isEdit) {
      final job = widget.existingJob!;
      _judulController.text = job.judul;
      _deskripsiController.text = job.deskripsi;
      _lokasiController.text = job.lokasi;
      _gajiMinController.text = job.gajiMin.toString();
      _gajiMaxController.text = job.gajiMax.toString();
      if (_tipeList.contains(job.tipePekerjaan)) {
        _tipePekerjaan = job.tipePekerjaan;
      }
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _gajiMinController.dispose();
    _gajiMaxController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = {
        'judul': _judulController.text,
        'deskripsi': _deskripsiController.text,
        'lokasi': _lokasiController.text,
        'gaji_min': _gajiMinController.text,
        'gaji_max': _gajiMaxController.text,
        'tipe_pekerjaan': _tipePekerjaan,
        if (!isEdit) 'status': 'Buka',
      };

      if (isEdit) {
        context.read<PerusahaanBloc>().add(
              UpdateJobEvent(jobId: widget.existingJob!.id, jobData: data),
            );
      } else {
        context.read<PerusahaanBloc>().add(CreateJobEvent(data));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          isEdit ? 'Edit Lowongan' : 'Buat Lowongan',
          style: GoogleFonts.poppins(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        elevation: 0,
      ),
      body: BlocConsumer<PerusahaanBloc, PerusahaanState>(
        listener: (context, state) {
          if (state is JobCreated || state is JobUpdated) {
            Navigator.of(context).pop(true);
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
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    label: 'Judul Pekerjaan',
                    controller: _judulController,
                    hintText: 'Cth: Software Engineer',
                    validator: (val) => val == null || val.isEmpty
                        ? 'Judul tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    'Tipe Pekerjaan',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _tipePekerjaan,
                        isExpanded: true,
                        items: _tipeList.map((String val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _tipePekerjaan = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Lokasi Penempatan',
                    controller: _lokasiController,
                    hintText: 'Cth: Jakarta Selatan',
                    validator: (val) => val == null || val.isEmpty
                        ? 'Lokasi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Gaji Minimum',
                          controller: _gajiMinController,
                          hintText: 'Cth: 5000000',
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Wajib diisi'
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomTextField(
                          label: 'Gaji Maksimum',
                          controller: _gajiMaxController,
                          hintText: 'Cth: 10000000',
                          keyboardType: TextInputType.number,
                          validator: (val) => val == null || val.isEmpty
                              ? 'Wajib diisi'
                              : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  CustomTextField(
                    label: 'Deskripsi Pekerjaan',
                    controller: _deskripsiController,
                    hintText: 'Jelaskan tanggung jawab dan kualifikasi...',
                    maxLines: 5,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Deskripsi tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    text: isEdit ? 'Simpan Perubahan' : 'Buat Lowongan',
                    onPressed: isLoading ? null : _submit,
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
