part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

class TimeSeriesAPI {
  CDFApiClient client;
  TimeSeriesAPI(this.client);

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
    _log.w('getStatus() returned non-2xx response code');
    return null;
  }

  Future<DatapointsModel> getDatapoints(DatapointsFilterModel filter,
      {int layer: 0}) async {
    Response res;
    try {
      Map data = {
        'items': [filter.toJson()]
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
    _log.w('getStatus() returned non-2xx response code');
    return null;
  }
}
