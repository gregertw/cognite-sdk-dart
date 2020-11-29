part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Parameter combination is not accepted by the API.
class CDFApiClientParameterException implements Exception {
  String errMsg() => 'API parameters do not satisfy requirements';
}

/// The filter is not valid for timeseries datapoints retrieval.
class CDFApiClientDatapointFilterException implements Exception {
  String errMsg() => 'Filter for datapoints is invalid';
}

/// An instance of an HttpClientAdapter is required.
///
/// Use e.g. DefaultHttpClientAdapter() from dio/adapter.dart or BrowserHttpClientAdapter().
class CDFApiClientHttpAdapterException implements Exception {
  String errMsg() => 'An HttpClientAdapter is required';
}
