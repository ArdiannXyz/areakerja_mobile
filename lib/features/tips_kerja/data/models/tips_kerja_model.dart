import 'package:equatable/equatable.dart';

class TipsKerjaModel extends Equatable {
  final String id;
  final String judul;
  final String? ringkasan;
  final String konten;
  final String? coverImage;
  final String? penulis;
  final String? kategori;
  final int viewCount;
  final DateTime? createdAt;

  const TipsKerjaModel({
    required this.id,
    required this.judul,
    this.ringkasan,
    required this.konten,
    this.coverImage,
    this.penulis,
    this.kategori,
    this.viewCount = 0,
    this.createdAt,
  });

  factory TipsKerjaModel.fromJson(Map<String, dynamic> json) {
    return TipsKerjaModel(
      id: json['id']?.toString() ?? '',
      judul: json['judul']?.toString() ?? json['title']?.toString() ?? '',
      ringkasan: json['ringkasan']?.toString() ?? json['excerpt']?.toString() ?? json['summary']?.toString(),
      konten: json['konten']?.toString() ?? json['content']?.toString() ?? json['body']?.toString() ?? '',
      coverImage: json['cover_image']?.toString() ?? json['image']?.toString() ?? json['thumbnail']?.toString(),
      penulis: json['penulis']?.toString() ?? json['author']?.toString() ?? 'Redaksi AreaKerja',
      kategori: json['kategori']?.toString() ?? json['category']?.toString() ?? 'Karir & Tips',
      viewCount: json['views'] is int ? json['views'] : (json['view_count'] is int ? json['view_count'] : 0),
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'ringkasan': ringkasan,
      'konten': konten,
      'cover_image': coverImage,
      'penulis': penulis,
      'kategori': kategori,
      'views': viewCount,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        judul,
        ringkasan,
        konten,
        coverImage,
        penulis,
        kategori,
        viewCount,
        createdAt,
      ];
}
