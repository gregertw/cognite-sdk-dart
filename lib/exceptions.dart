part of 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

class CdfApiClientParameterException implements Exception {
  String errMsg() => 'API parameters do not satisfy requirements';
}

class CdfApiClientDatapointFilterException implements Exception {
  String errMsg() => 'Filter for datapoints is invalid';
}
