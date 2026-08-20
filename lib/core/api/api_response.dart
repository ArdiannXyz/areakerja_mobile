class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final dynamic errors;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic json)? fromJsonT,
  ) {
    final status = json['status'];
    final bool isSuccess = json['success'] == true ||
        status == 'success' ||
        status == 200 ||
        status == 201 ||
        json['code'] == 200 ||
        json['code'] == 201;

    final String message = json['message']?.toString() ??
        (isSuccess ? 'Operasi berhasil' : 'Terjadi kesalahan');

    dynamic rawData = json['data'] ?? json['user'] ?? json['result'];

    T? parsedData;
    if (rawData != null && fromJsonT != null) {
      try {
        parsedData = fromJsonT(rawData);
      } catch (e) {
        parsedData = null;
      }
    } else if (rawData is T) {
      parsedData = rawData;
    }

    return ApiResponse<T>(
      success: isSuccess,
      message: message,
      data: parsedData,
      errors: json['errors'] ?? json['error'],
      statusCode: json['code'] is int ? json['code'] : null,
    );
  }

  factory ApiResponse.success({
    required String message,
    T? data,
    int statusCode = 200,
  }) {
    return ApiResponse<T>(
      success: true,
      message: message,
      data: data,
      statusCode: statusCode,
    );
  }

  factory ApiResponse.error({
    required String message,
    dynamic errors,
    int statusCode = 400,
  }) {
    return ApiResponse<T>(
      success: false,
      message: message,
      errors: errors,
      statusCode: statusCode,
    );
  }
}
