import 'package:kasagardem/utils/constants/app_strings.dart';

class FetchDataException implements Exception {
  final String message;

  FetchDataException(this.message);

  @override
  String toString() {
    return '${AppStrings.fetchDataException}: $message';
  }
}

class BadRequestException implements Exception {
  final String message;
  BadRequestException(this.message);
  @override
  String toString() {
    return '${AppStrings.badRequestException}: $message';
  }
}

class UnauthorisedException implements Exception {
  final String message;
  UnauthorisedException(this.message);

  @override
  String toString() {
    return '${AppStrings.unauthorisedException}: $message';
  }
}

class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);

  @override
  String toString() {
    return '${AppStrings.notFoundException}: $message';
  }
}
