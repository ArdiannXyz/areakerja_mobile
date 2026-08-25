import 'package:flutter/material.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;
  final List<String>? suggestedFollowUps;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.suggestedFollowUps,
  });
}

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isBotTyping = false;

  final List<ChatMessage> _messages = [];

  // Database of FAQ questions & template answers
  final List<Map<String, dynamic>> _faqTemplates = [
    {
      'question': 'Bagaimana cara melamar lowongan kerja?',
      'keywords': ['melamar', 'lamar', 'daftar loker', 'kirim lamaran', 'cara melamar'],
      'answer':
          'Untuk melamar lowongan kerja di AreaKerja:\n\n1️⃣ Buka tab "Beranda" atau "Lowongan".\n2️⃣ Pilih lowongan yang sesuai dengan keahlian Anda.\n3️⃣ Klik tombol "Lamar Sekarang" di bagian bawah.\n4️⃣ Lengkapi dokumen (CV & Surat Lamaran), lalu klik "Kirim Lamaran".\n\nStatus lamaran Anda dapat dipantau langsung!',
      'followUps': ['Apakah melamar lowongan dipungut biaya?', 'Bagaimana cara mengunduh CV?'],
    },
    {
      'question': 'Apakah melamar lowongan dipungut biaya?',
      'keywords': ['biaya', 'gratis', 'bayar', 'dipungut biaya', 'biaya lamar'],
      'answer':
          '✅ Tidak sama sekali!\n\nMelamar seluruh lowongan pekerjaan reguler di AreaKerja 100% GRATIS tanpa biaya tersembunyi apapun. Hati-hati terhadap pihak yang mengatasnamakan perusahaan dan meminta biaya transportasi/akomodasi.',
      'followUps': ['Apa keuntungan menjadi Kandidat?', 'Bagaimana cara melamar lowongan kerja?'],
    },
    {
      'question': 'Apa itu program Kandidat AreaKerja?',
      'keywords': ['kandidat', 'program kandidat', 'keuntungan kandidat', 'apa itu kandidat'],
      'answer':
          '🌟 Program Kandidat adalah program prioritas penyaluran kerja eksklusif AreaKerja.\n\nKeuntungan menjadi Kandidat:\n• Menjadi prioritas rekomendasi ke perusahaan mitra.\n• Pelatihan & sertifikasi keahlian terakreditasi.\n• Bimbingan portofolio dan simulasi interview kerja.\n• Lifetime support dan konsultasi karir.',
      'followUps': ['Bagaimana alur pendaftaran Kandidat?', 'Berapa lama verifikasi pembayaran?'],
    },
    {
      'question': 'Bagaimana alur pendaftaran Kandidat?',
      'keywords': ['daftar kandidat', 'alur kandidat', 'cara daftar kandidat', 'registrasi kandidat'],
      'answer':
          'Alur pendaftaran Program Kandidat:\n\n1️⃣ Buka menu tab "Daftar Kandidat".\n2️⃣ Pilih divisi pelatihan yang Anda minati.\n3️⃣ Selesaikan pembayaran biaya registrasi ke rekening resmi AreaKerja.\n4️⃣ Unggah bukti transfer di halaman Detail Transaksi.\n5️⃣ Setelah diverifikasi, Anda siap mengikuti pelatihan!',
      'followUps': ['Berapa lama verifikasi pembayaran?', 'Apa itu program Kandidat AreaKerja?'],
    },
    {
      'question': 'Berapa lama verifikasi pembayaran?',
      'keywords': ['verifikasi', 'bukti transfer', 'konfirmasi bayar', 'berapa lama'],
      'answer':
          '⏱️ Proses verifikasi bukti transfer dilakukan oleh tim admin AreaKerja dalam waktu maksimal 1x24 jam kerja (biasanya 1–3 jam pada hari kerja aktif).',
      'followUps': ['Bagaimana alur pendaftaran Kandidat?', 'Hubungi Admin Support via WhatsApp'],
    },
    {
      'question': 'Bagaimana cara mengunduh CV?',
      'keywords': ['unduh cv', 'download cv', 'format cv', 'cv pdf', 'cetak cv'],
      'answer':
          '📄 Untuk mengunduh CV:\n\n1️⃣ Buka menu tab "Profil".\n2️⃣ Klik menu "Unduh CV".\n3️⃣ Klik tombol "Download Sekarang".\n\nSistem akan secara otomatis menyusun dan mengunduh CV standar AreaKerja dalam format PDF ke perangkat Anda.',
      'followUps': ['Bagaimana cara mengubah data diri?', 'Bagaimana cara melamar lowongan kerja?'],
    },
    {
      'question': 'Bagaimana cara mengubah kata sandi?',
      'keywords': ['ubah kata sandi', 'ganti password', 'lupa kata sandi', 'reset password'],
      'answer':
          '🔒 Untuk mengubah kata sandi:\n\n1️⃣ Buka menu tab "Profil".\n2️⃣ Pilih menu "Ubah Kata Sandi".\n3️⃣ Masukkan Kata Sandi Lama Anda.\n4️⃣ Buat Kata Sandi Baru (minimal 8 karakter kombinasi huruf & angka).\n5️⃣ Klik "Simpan Kata Sandi".',
      'followUps': ['Bagaimana cara mengubah data diri?', 'Hubungi Admin Support via WhatsApp'],
    },
    {
      'question': 'Hubungi Admin Support via WhatsApp',
      'keywords': ['hubungi', 'whatsapp', 'cs', 'admin', 'kontak', 'bantuan manusia'],
      'answer':
          '💬 Butuh bantuan langsung dari tim kami?\n\nAnda dapat menghubungi Layanan Pelanggan AreaKerja melalui WhatsApp Official:\n📱 No. WA: +62 812-3456-7890\n⏰ Jam Operasional: Senin - Sabtu (08.00 - 17.00 WIB)\n\nTim kami siap membantu kendala Anda!',
      'followUps': ['Bagaimana cara melamar lowongan kerja?', 'Apa itu program Kandidat AreaKerja?'],
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initial welcome message from bot
    _messages.add(
      ChatMessage(
        text:
            'Halo! 👋 Selamat datang di Pusat Bantuan AreaKerja.\n\nAda yang bisa kami bantu seputar loker, lamaran, akun, atau program kandidat? Silakan pilih salah satu pertanyaan di bawah ini atau ketik langsung pertanyaan Anda.',
        isUser: false,
        time: DateTime.now(),
        suggestedFollowUps: [
          'Bagaimana cara melamar lowongan kerja?',
          'Apakah melamar lowongan dipungut biaya?',
          'Apa itu program Kandidat AreaKerja?',
          'Bagaimana alur pendaftaran Kandidat?',
          'Berapa lama verifikasi pembayaran?',
          'Bagaimana cara mengunduh CV?',
          'Bagaimana cara mengubah kata sandi?',
          'Hubungi Admin Support via WhatsApp',
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleQuestionSelect(String questionText) {
    // 1. Add User Message
    setState(() {
      _messages.add(
        ChatMessage(
          text: questionText,
          isUser: true,
          time: DateTime.now(),
        ),
      );
      _isBotTyping = true;
    });
    _scrollToBottom();

    // 2. Simulate Bot Thinking & Answering with matching template
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      Map<String, dynamic>? matchedTemplate;

      // Exact match
      for (final t in _faqTemplates) {
        if (t['question'].toString().toLowerCase() == questionText.toLowerCase()) {
          matchedTemplate = t;
          break;
        }
      }

      // Keyword match if not found
      if (matchedTemplate == null) {
        final queryLower = questionText.toLowerCase();
        for (final t in _faqTemplates) {
          final List<String> keywords = List<String>.from(t['keywords'] ?? []);
          if (keywords.any((kw) => queryLower.contains(kw.toLowerCase()))) {
            matchedTemplate = t;
            break;
          }
        }
      }

      final String answerText = matchedTemplate != null
          ? matchedTemplate['answer']
          : 'Terima kasih atas pertanyaannya. 😊\n\nUntuk pertanyaan spesifik mengenai "$questionText", tim Customer Service kami siap membantu Anda secara langsung via WhatsApp Official AreaKerja.';

      final List<String> followUps = matchedTemplate != null
          ? List<String>.from(matchedTemplate['followUps'] ?? [])
          : [
              'Hubungi Admin Support via WhatsApp',
              'Bagaimana cara melamar lowongan kerja?',
              'Apa itu program Kandidat AreaKerja?',
            ];

      setState(() {
        _isBotTyping = false;
        _messages.add(
          ChatMessage(
            text: answerText,
            isUser: false,
            time: DateTime.now(),
            suggestedFollowUps: followUps,
          ),
        );
      });
      _scrollToBottom();
    });
  }

  void _handleSubmittedText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _textController.clear();
    _handleQuestionSelect(text);
  }

  void _resetChat() {
    setState(() {
      _messages.clear();
      _messages.add(
        ChatMessage(
          text: 'Percakapan telah diatur ulang. 👋\n\nSilakan pilih topik bantuan di bawah ini:',
          isUser: false,
          time: DateTime.now(),
          suggestedFollowUps: [
            'Bagaimana cara melamar lowongan kerja?',
            'Apakah melamar lowongan dipungut biaya?',
            'Apa itu program Kandidat AreaKerja?',
            'Bagaimana cara mengunduh CV?',
            'Hubungi Admin Support via WhatsApp',
          ],
        ),
      );
    });
    _scrollToBottom();
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
        title: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(Icons.support_agent_rounded, color: Color(0xFFFF5E14), size: 24),
                  ),
                ),
                Positioned(
                  bottom: -1,
                  right: -1,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFF5E14), width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Asisten AreaKerja',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Online • Menjawab Otomatis',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            tooltip: 'Reset Chat',
            onPressed: _resetChat,
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Questions Horizontal Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                  child: Row(
                    children: [
                      Icon(Icons.help_outline_rounded, size: 16, color: Color(0xFFFF5E14)),
                      SizedBox(width: 6),
                      Text(
                        'Pilihan Pertanyaan Populer:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 34,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    scrollDirection: Axis.horizontal,
                    itemCount: _faqTemplates.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final item = _faqTemplates[index];
                      return InkWell(
                        onTap: () => _handleQuestionSelect(item['question']),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF5E14).withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFFF5E14).withValues(alpha: 0.25),
                              width: 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              item['question'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF5E14),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isBotTyping) {
                  return _buildTypingIndicator();
                }

                final msg = _messages[index];
                return _buildMessageItem(msg);
              },
            ),
          ),

          // Bottom Chat Input Bar
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    final isUser = message.isUser;
    final formattedTime =
        '${message.time.hour.toString().padLeft(2, '0')}:${message.time.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5E14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 18),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFFFF5E14) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: isUser ? const Radius.circular(16) : const Radius.circular(4),
                      bottomRight: isUser ? const Radius.circular(4) : const Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isUser ? 0.12 : 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.45,
                          color: isUser ? Colors.white : const Color(0xFF1E293B),
                          fontWeight: isUser ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 10.5,
                          color: isUser ? Colors.white70 : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Follow up chips (if any and it's a bot message)
          if (!isUser && message.suggestedFollowUps != null && message.suggestedFollowUps!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: message.suggestedFollowUps!.map((q) {
                  return InkWell(
                    onTap: () => _handleQuestionSelect(q),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFFF5E14).withValues(alpha: 0.4)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.touch_app_rounded, color: Color(0xFFFF5E14), size: 14),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              q,
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF5E14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFF5E14),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.support_agent_rounded, color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5E14)),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'Mengetik...',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF64748B),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha: 0.06), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _textController,
                  onSubmitted: (_) => _handleSubmittedText(),
                  textInputAction: TextInputAction.send,
                  decoration: const InputDecoration(
                    hintText: 'Ketik pertanyaan Anda...',
                    hintStyle: TextStyle(fontSize: 13.5, color: Color(0xFF94A3B8)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Material(
              color: const Color(0xFFFF5E14),
              shape: const CircleBorder(),
              elevation: 2,
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: _handleSubmittedText,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
