import 'package:flutter/material.dart';
import '../../data/models/divisi_model.dart';

class LengkapiDataKandidatPage extends StatefulWidget {
  final DivisiModel divisi;

  const LengkapiDataKandidatPage({
    super.key,
    required this.divisi,
  });

  @override
  State<LengkapiDataKandidatPage> createState() =>
      _LengkapiDataKandidatPageState();
}

class _LengkapiDataKandidatPageState extends State<LengkapiDataKandidatPage> {
  static const _orange = Color(0xFFFF5E14);

  // Controller for the form
  final _namaController = TextEditingController(text: 'John Doe');
  final _emailController = TextEditingController(text: 'johndoe@example.com');
  final _hpController = TextEditingController(text: '081234567890');
  final _pendidikanController = TextEditingController(text: 'S1 Teknik Informatika');
  final _alamatController = TextEditingController(text: 'Jl. Contoh Alamat No. 123');

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _hpController.dispose();
    _pendidikanController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              color: Color(0xFF0F172A), size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Lengkapi Data',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info Divisi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: _orange, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Kamu memilih program divisi ${widget.divisi.nama}. Pastikan data diri kamu sudah benar.',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF92400E),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'Data Diri',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildTextField(label: 'Nama Lengkap', controller: _namaController),
            _buildTextField(label: 'Email', controller: _emailController, keyboardType: TextInputType.emailAddress),
            _buildTextField(label: 'Nomor HP', controller: _hpController, keyboardType: TextInputType.phone),
            _buildTextField(label: 'Pendidikan Terakhir', controller: _pendidikanController),
            _buildTextField(label: 'Alamat', controller: _alamatController, maxLines: 3),

            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  '/kandidat/pilih-pembayaran',
                  arguments: {'divisi': widget.divisi},
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Simpan & Lanjutkan'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _orange),
              ),
            ),
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}
