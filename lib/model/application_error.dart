import 'dart:convert';

import 'package:dio/dio.dart' hide Headers;
import 'package:golf_uiv2/router/app_routers.dart';
import 'package:golf_uiv2/utils/constants.dart';
import 'package:get/get.dart';
import 'package:golf_uiv2/utils/support.dart';

class ApplicationError implements Exception {
  ApplicationErrorCode? _errorCode;
  String? _errorMessage = "";

  ApplicationError.withDioError(DioException error) {
    _handleError(error);
  }

  ApplicationError.withMessage([String? messError]) {
    _errorCode = ApplicationErrorCode.UNKNOW_APPLICATION_ERROR;
    _errorMessage = messError ?? 'application_error'.tr;
  }

  ApplicationError.withCode(ApplicationErrorCode errorCode) {
    _applyErrorType(errorCode);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        _applyErrorType(ApplicationErrorCode.REQUEST_CANCEL);
        break;
      case DioExceptionType.connectionTimeout:
        _applyErrorType(ApplicationErrorCode.CONNECTION_ERROR);
        break;
      case DioExceptionType.unknown:
        _applyErrorType(ApplicationErrorCode.UNKNOW_SERVER_ERROR);
        break;
      case DioExceptionType.receiveTimeout:
        _applyErrorType(ApplicationErrorCode.RESPONSE_TIMEOUT);
        break;
      default:
        if (error.response?.statusCode == 401) {
          SupportUtils.letsLogout();
          Get.offAllNamed(AppRoutes.LOGIN);
        }

        final extractedMessage = _extractServerMessage(error.response?.data);
        _errorCode = ApplicationErrorCode.UNKNOW_SERVER_ERROR;
        _errorMessage =
            (extractedMessage ?? "").isNotEmpty
                ? extractedMessage
                : (error.response?.statusMessage ?? "").isNotEmpty
                ? error.response?.statusMessage
                : 'server_error'.tr;
        break;
    }
  }

  String? _extractServerMessage(dynamic responseData) {
    if (responseData == null) {
      return null;
    }

    if (responseData is Map) {
      final dynamic message =
          responseData['message'] ??
          responseData['Message'] ??
          responseData['error'] ??
          responseData['Error'] ??
          responseData['detail'] ??
          responseData['Detail'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString().trim();
      }
      return null;
    }

    if (responseData is String) {
      final raw = responseData.trim();
      if (raw.isEmpty) {
        return null;
      }

      try {
        final decoded = jsonDecode(raw);
        final decodedMessage = _extractServerMessage(decoded);
        if ((decodedMessage ?? '').isNotEmpty) {
          return decodedMessage;
        }
      } catch (_) {
        // Not JSON string, use raw text directly.
      }

      return raw;
    }

    return responseData.toString();
  }

  _applyErrorType(ApplicationErrorCode errorCode) {
    switch (errorCode) {
      case ApplicationErrorCode.CONNECTION_ERROR:
        _errorCode = ApplicationErrorCode.CONNECTION_ERROR;
        _errorMessage = 'connect_error'.tr;
        break;
      case ApplicationErrorCode.REQUEST_CANCEL:
        _errorCode = ApplicationErrorCode.REQUEST_CANCEL;
        _errorMessage = 'request_cancel'.tr;
        break;
      case ApplicationErrorCode.RESPONSE_TIMEOUT:
        _errorCode = ApplicationErrorCode.RESPONSE_TIMEOUT;
        _errorMessage = 'server_response_timeout'.tr;
        break;
      case ApplicationErrorCode.UNKNOW_APPLICATION_ERROR:
        _errorCode = ApplicationErrorCode.UNKNOW_APPLICATION_ERROR;
        _errorMessage = 'application_error'.tr;
        break;
      case ApplicationErrorCode.UNKNOW_SERVER_ERROR:
        _errorCode = ApplicationErrorCode.UNKNOW_SERVER_ERROR;
        _errorMessage = 'server_error'.tr;
        break;
    }
  }
}
