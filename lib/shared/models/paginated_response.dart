class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;
  final int perPage;

  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.perPage,
  });

  bool get hasMorePages => currentPage < lastPage;

  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic itemJson) fromJsonT,
  ) {
    final rawList = json['data'] ?? json['items'] ?? json['results'] ?? [];
    final List<T> items = (rawList as List).map((e) => fromJsonT(e)).toList();

    return PaginatedResponse<T>(
      items: items,
      currentPage: json['current_page'] is int ? json['current_page'] : 1,
      lastPage: json['last_page'] is int ? json['last_page'] : 1,
      total: json['total'] is int ? json['total'] : items.length,
      perPage: json['per_page'] is int ? json['per_page'] : items.length,
    );
  }

  factory PaginatedResponse.empty() {
    return const PaginatedResponse(
      items: [],
      currentPage: 1,
      lastPage: 1,
      total: 0,
      perPage: 10,
    );
  }
}
