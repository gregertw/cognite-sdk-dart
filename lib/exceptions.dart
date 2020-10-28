part of 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

class CDFApiClient_ParameterException implements Exception {
  String errMsg() => 'API parameters do not satisfy requirements';
}

class CDFApiClient_DatapointFilterException implements Exception {
  String errMsg() => 'Filter for datapoints is invalid';
}
