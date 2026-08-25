import 'package:flutter/material.dart';

class AlamatPage extends StatefulWidget {
  const AlamatPage({super.key});

  @override
  State<AlamatPage> createState() => _AlamatPageState();
}

class _AlamatPageState extends State<AlamatPage> {
  final _formKey = GlobalKey<FormState>();
  final _alamatController = TextEditingController(text: 'Jl. Kaliurang KM 5, Gang Pandega Marta No. 12');
  final _kecamatanController = TextEditingController(text: 'Depok');
  final _kotaController = TextEditingController(text: 'Sleman');
  final _provinsiController = TextEditingController(text: 'D.I. Yogyakarta');
  final _kodePosController = TextEditingController(text: '55281');
  final _catatanController = TextEditingController(text: 'Dekat Ringroad Utara, pagar hitam');

  @override
  void dispose() {
    _alamatController.dispose();
    _kecamatanController.dispose();
    _kotaController.dispose();
    _provinsiController.dispose();
    _kodePosController.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _saveAlamat() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Alamat domisili berhasil disimpan!'),
            ],
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF5E14),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Alamat Domisili',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Info banner
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF5E14).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFF5E14).withValues(alpha: 0.2)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Color(0xFFFF5E14), size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pastikan alamat domisili sesuai untuk mempermudah rekomendasi loker terdekat.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF334155),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Form fields card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFieldLabel('Alamat Lengkap / Jalan'),
                    _buildTextField(
                      controller: _alamatController,
                      icon: Icons.home_outlined,
                      maxLines: 3,
                      hintText: 'Nama jalan, nomor rumah, RT/RW',
                      validator: (val) => val == null || val.isEmpty ? 'Alamat lengkap wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),

                    _buildFieldLabel('Provinsi'),
                    _buildTextField(
                      controller: _provinsiController,
                      icon: Icons.map_outlined,
                      hintText: 'Contoh: D.I. Yogyakarta',
                      validator: (val) => val == null || val.isEmpty ? 'Provinsi wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Kota / Kabupaten'),
                              _buildTextField(
                                controller: _kotaController,
                                icon: Icons.location_city_outlined,
                                hintText: 'Sleman',
                                validator: (val) => val == null || val.isEmpty ? 'Wajib diisi' : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Kecamatan'),
                              _buildTextField(
                                controller: _kecamatanController,
                                icon: Icons.explore_outlined,
                                hintText: 'Depok',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    _buildFieldLabel('Kode Pos'),
                    _buildTextField(
                      controller: _kodePosController,
                      icon: Icons.markunread_mailbox_outlined,
                      keyboardType: TextInputType.number,
                      hintText: 'Contoh: 55281',
                      validator: (val) => val == null || val.isEmpty ? 'Kode pos wajib diisi' : null,
                    ),
                    const SizedBox(height: 18),

                    _buildFieldLabel('Catatan / Patokan (Opsional)'),
                    _buildTextField(
                      controller: _catatanController,
                      icon: Icons.note_outlined,
                      hintText: 'Contoh: Sebelah minimarket, pagar hitam',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E14),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: _saveAlamat,
                  child: const Text(
                    'Simpan Alamat',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    String? hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        fontSize: 14.5,
        color: Color(0xFF0F172A),
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B), size: 22),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFF5E14), width: 1.6),
        ),
      ),
    );
  }
}
