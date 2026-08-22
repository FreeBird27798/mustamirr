import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failures.dart';

/// Converts any thrown error (usually a [DioException]) into a [Failure]
/// with a user-friendly Arabic message. Used by repositories when a
/// data-source call fails, so the UI shows something meaningful instead
/// of a raw exception string.
Failure mapErrorToFailure(Object error) {
  // Data-layer exception that already carries a user-facing message.
  if (error is ServerException) {
    return ServerFailure(error.message);
  }
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('انتهت مهلة الاتصال. حاول مرة أخرى.');
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return const NetworkFailure(
          'تعذّر الاتصال بالخادم. تأكد من اتصالك بالإنترنت.',
        );
      case DioExceptionType.badCertificate:
        return const NetworkFailure('حدثت مشكلة في شهادة الأمان.');
      case DioExceptionType.cancel:
        return const NetworkFailure('تم إلغاء الطلب.');
      case DioExceptionType.badResponse:
        return _mapStatusCode(error);
    }
  }
  return const ServerFailure('حدث خطأ غير متوقع. حاول مرة أخرى.');
}

Failure _mapStatusCode(DioException error) {
  final status = error.response?.statusCode;
  final serverMessage = _extractServerMessage(error.response?.data);

  if (status == 401) {
    return UnauthorizedFailure(
      serverMessage ?? 'انتهت الجلسة. الرجاء تسجيل الدخول من جديد.',
    );
  }
  if (status == 403) {
    return UnauthorizedFailure(
      serverMessage ?? 'ليس لديك صلاحية لهذا الإجراء.',
    );
  }
  if (status == 422) {
    // Laravel validation errors
    return ServerFailure(serverMessage ?? 'البيانات المدخلة غير صحيحة.');
  }
  if (status != null && status >= 500) {
    return const ServerFailure('خطأ في الخادم. حاول لاحقًا.');
  }
  return ServerFailure(serverMessage ?? 'حدث خطأ. حاول مرة أخرى.');
}

/// Our backend wraps errors as `{ "error": { "code": "...", "message": "..." },
/// "errors": { ... } }`. Plain Laravel sometimes returns a top-level
/// `{ "message": "..." }`. Pull the most useful string, checking the nested
/// shape first.
String? _extractServerMessage(dynamic data) {
  if (data is Map) {
    // Field validation errors first — the specific one ("البريد مستخدم مسبقًا")
    // is far more useful than the generic "البيانات المرسلة غير صحيحة".
    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first.toString();
      if (first is String) return first;
    }

    // Nested error object: { "error": { "code", "message" } }
    final error = data['error'];
    if (error is Map) {
      final msg = error['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    }

    // Top-level message (plain Laravel / success envelope)
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}
