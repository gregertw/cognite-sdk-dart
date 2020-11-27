part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// This API covers the timeseries API.
///
/// https://docs.cognite.com/api/v1/#tag/Time-series
class TimeSeriesAPI {
  CDFApiClient client;
  TimeSeriesAPI(this.client);

  /// Returns the first 100 (default) timeseries or null.
  ///
  /// As no query parameters or paging is supported, it is mostly
  /// for demonstration purposes.
  /// https://docs.cognite.com/api/v1/#operation/getTimeSeries
  Future<List<TimeSeriesModel>> getAllTimeSeries() async {
    Response res;
    try {
      res = await client.http.get('/timeseries');
    } on DioError {
      return null;
    }
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      return TimeSeriesModel.listFromJson(res.data['items'] ?? null);
    }
    _log.w('getAllTimeSeries() returned non-2xx response code');
    return null;
  }

  /// Needs a [DatapointsFilterModel] to retrieve either aggregates or raw datapoints.
  ///
  /// This API endpoint does not support paging, so max 10,000 aggregated or
  /// 100,000 raw datapoints can be retrieved at the time.
  /// https://docs.cognite.com/api/v1/#operation/getMultiTimeSeriesDatapoints
  /// Use [raw] as true to ignore the aggregate in the filter and just get
  /// raw datapoints.
  Future<DatapointsModel> getDatapoints(DatapointsFilterModel filter,
      {raw: false}) async {
    Response res;
    var f = filter.toJson();
    if (raw) {
      f.remove('aggregates');
    }
    try {
      Map data = {
        'items': [f]
      };
      res = await client.http.post('/timeseries/data/list', data: data);
    } on DioError {
      return null;
    }
    if (res.statusCode >= 200 && res.statusCode <= 299) {
      DatapointsModel dp = DatapointsModel();
      dp.fromJson(res.data['items'][0]);
      return dp;
    }
    _log.w('getDatapoints() returned non-2xx response code');
    return null;
  }
}
