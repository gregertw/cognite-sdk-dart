part of 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

class DatapointModel {
  /* 
    The number of milliseconds since 00:00:00 Thursday, 1 January 1970, 
    Coordinated Universal Time (UTC), minus leap seconds.
  */
  int timestamp;
  // timestamp in DateTime object
  DateTime datetime;
  // Numeric value of a data point
  double value;
  // String value of a data point
  String strValue;
  // The integral average value in the aggregate period.
  double average;
  // The maximum value in the aggregate period.
  double max;
  // The minimum value in the aggregate period.
  double min;
  // The number of datapoints in the aggregate period.
  int count;
  // The sum of the datapoints in the aggregate period.
  double sum;
  // The interpolated value of the series in the beginning of the aggregate.
  double interpolation;
  // The last value before or at the beginning of the aggregate.
  double stepInterpolation;
  // The variance of the interpolated underlying function.
  double continuousVariance;
  // The variance of the datapoint values.
  double discreteVariance;
  // The total variation of the interpolated underlying function.
  double totalVariance;
  /* As we load at deeper zoom levels, we can set the layer id with 0 as first */
  int layer = -1;

  get localDateTime => datetime.toLocal();

  @override
  String toString() {
    return 'DatapointModel[ layer=$layer, timestamp=$timestamp, value=$value, strValue=$strValue, average=$average, max=$max, min=$min, count=$count, sum=$sum, interpolation=$interpolation, stepInterpolation=$stepInterpolation, continuousVariance=$continuousVariance, discreteVariance=$discreteVariance, totalVariance=$totalVariance ]';
  }

  DatapointModel.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'] ?? null;
    datetime = DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
    if (json['value'] is double) {
      value = json['value'] ?? null;
    } else {
      strValue = json['value'] ?? null;
    }
    average = json['average'] ?? null;
    max = json['max'] ?? null;
    min = json['min'] ?? null;
    count = json['count'] ?? null;
    sum = json['sum'] ?? null;
    interpolation = json['interpolation'] ?? null;
    stepInterpolation = json['stepInterpolation'] ?? null;
    continuousVariance = json['continuousVariance'] ?? null;
    discreteVariance = json['discreteVariance'] ?? null;
    totalVariance = json['totalVariance'] ?? null;
  }

  static List<DatapointModel> listFromJson(List<dynamic> json) {
    return json == null
        ? <DatapointModel>[]
        : json.map((value) => DatapointModel.fromJson(value)).toList();
  }

  Map toJson() => {'timestamp': timestamp, 'value': value ?? strValue};
}
