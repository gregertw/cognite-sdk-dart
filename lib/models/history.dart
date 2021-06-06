part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Keeps each request/response as part of client .history.
class HistoryModel {
  /// Base url
  String? baseUrl;

  /// Method
  String? method;

  /// Path component of URL
  String? path;

  /// Request body
  Map? request;

  /// Response body
  Map? response;

  /// Response code
  int? statusCode;

  /// Response message
  String? statusMessage;

  /// Internal request id
  int? id;

  /// Request timestamp on send
  int? timestampStart;

  /// Response timestamp on receive
  int? timestampEnd;

  HistoryModel(
      {this.baseUrl,
      this.path,
      this.method,
      this.id,
      this.request,
      this.response,
      this.statusCode,
      this.statusMessage}) {
    timestampStart = DateTime.now().millisecondsSinceEpoch;
  }
  @override
  String toString() {
    return 'HistoryModel[ id=$id, url=$baseUrl, path=$path, request=${request.toString()}, response=${response.toString()}, code=${statusCode.toString()}, msg=$statusMessage ]';
  }
}
