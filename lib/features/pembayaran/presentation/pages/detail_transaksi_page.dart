import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DetailTransaksiPage extends StatefulWidget {
  final String? noTransaksi;
  final String? namaKandidat;
  final String? divisi;
  final String? bankName;
  final String? totalPayment;

  const DetailTransaksiPage({
    super.key,
    this.noTransaksi,
    this.namaKandidat,
    this.divisi,
    this.bankName,
    this.totalPayment,
  });

  @override
  State<DetailTransaksiPage> createState() => _DetailTransaksiPageState();
}

class _DetailTransaksiPageState extends State<DetailTransaksiPage> {
  final Map<int, bool> _expanded = {0: false, 1: false, 2: false};

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Nomor rekening berhasil disalin ke clipboard!'),
        backgroundColor: Color(0xFFFF5E14),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showUploadBuktiDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Upload Bukti Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Format file yang didukung: JPG, PNG, atau PDF (Maks. 5MB).',
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBD5E1), style: BorderStyle.solid),
              ),
              child: const Column(
                children: [
                  Icon(Icons.cloud_upload_outlined, color: Color(0xFFFF5E14), size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Pilih foto/file bukti transfer',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bukti pembayaran berhasil diunggah! Tim AreaKerja akan memverifikasi dalam 1x24 jam.'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                },
                child: const Text('Kirim Bukti Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final transactionNo = widget.noTransaksi ?? 'AK0078223327';
    final bank = widget.bankName ?? 'Bank BCA';
    final total = widget.totalPayment ?? 'Rp. 202.000,-';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF0F172A),
            size: 30,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Transaksi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DETAIL TRANSAKSI CARD (Matching Image 4)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Detail Transaksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // No. Transaksi
                  _buildRow('No. Transaksi', transactionNo),
                  const SizedBox(height: 12),

                  // Rekening Tujuan
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Rekening Tujuan',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '$bank, Areakerja.com',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '731 025 2527',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 6),
                              InkWell(
                                onTap: () => _copyToClipboard('7310252527'),
                                child: const Icon(
                                  Icons.copy_rounded,
                                  size: 16,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Status Tagihan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Status Tagihan',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5A623),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Menunggu Pembayaran',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Batas pembayaran
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Batas pembayaran:',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      const Text(
                        '23 jam 59 menit 59 detik',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFF5E14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Total Tagihan
                  _buildRow('Total Tagihan', total, isBold: true),
                  const SizedBox(height: 12),

                  // Metode Pembayaran + Ubah Metode
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Metode Pembayaran',
                        style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            bank.contains('Bank') ? 'Transfer Bank' : 'QRIS',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Ubah Metode',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF5E14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Upload Bukti Pembayaran Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upload Bukti Pembayaran',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _showUploadBuktiDialog,
                        child: const Text(
                          'Upload Bukti',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. PETUNJUK PEMBAYARAN SECTION
            const Text(
              'Petunjuk Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            // Accordion Items
            _buildAccordionItem(
              index: 0,
              title: 'Transfer ATM',
              content:
                  '1. Masukkan kartu ATM dan PIN Anda.\n2. Pilih menu "Transaksi Lainnya" > "Transfer" > "Ke Rekening BCA".\n3. Masukkan nomor rekening 731 025 2527 dan nominal tepat Rp 202.000,-.\n4. Konfirmasi transaksi dan simpan struk sebagai bukti transfer.',
            ),
            _buildAccordionItem(
              index: 1,
              title: 'Transfer M-Banking',
              content:
                  '1. Buka aplikasi Mobile Banking Anda dan login.\n2. Pilih menu "Transfer" > "Daftar Transfer" / "Antar Bank".\n3. Masukkan nomor rekening 731 025 2527 atas nama Areakerja.com.\n4. Masukkan nominal transfer Rp 202.000,-.\n5. Masukkan PIN dan simpan bukti transfer digital (screenshot).',
            ),
            _buildAccordionItem(
              index: 2,
              title: 'Transfer Via Teller',
              content:
                  '1. Kunjungi kantor cabang bank terdekat.\n2. Isi slip setoran dengan nomor rekening 731 025 2527 atas nama Areakerja.com.\n3. Serahkan uang tunai sebesar Rp 202.000,- kepada teller.\n4. Simpan salinan slip setoran dari teller.',
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildAccordionItem({
    required int index,
    required String title,
    required String content,
  }) {
    final isExpanded = _expanded[index] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expanded[index] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF0F172A),
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Text(
                content,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF475569),
                  height: 1.5,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
