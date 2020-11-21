part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Model holding returned timeseries.
///
/// https://docs.cognite.com/api/v1/#operation/getMultiTimeSeriesDatapoints
class TimeSeriesModel {
  /// A server-generated ID for the object.
  int id;

  /// The externally supplied ID for the time series.
  String externalId;

  /// The display short name of the time series. Note: Value of this field can differ from name presented by older versions of API 0.3-0.6.
  String name;

  /// Whether the time series is string valued or not.
  bool isString;

  /// Custom, application specific metadata. String key -> String value. Limits: Maximum length of key is 32 bytes, value 512 bytes, up to 16 key-value pairs.
  Map<String, String> metadata = const {};

  /// The physical unit of the time series.
  String unit;

  /// Asset ID of equipment linked to this time series.
  int assetId;

  /// Whether the time series is a step series or not.
  bool isStep;

  /// Description of the time series.
  String description;

  /// The required security categories to access this time series.
  List<int> securityCategories = const [];

  /// The dataSet Id for the item.
  int dataSetId;

  /// The number of milliseconds since 00:00:00 Thursday, 1 January 1970, Coordinated Universal Time (UTC), minus leap seconds.
  int createdTime;

  /// The number of milliseconds since 00:00:00 Thursday, 1 January 1970, Coordinated Universal Time (UTC), minus leap seconds.
  int lastUpdatedTime;

  @override
  String toString() {
    return 'TimeSeriesModel[id=$id, externalId=$externalId, name=$name, isString=$isString, metadata=$metadata, unit=$unit, assetId=$assetId, isStep=$isStep, description=$description, securityCategories=$securityCategories, dataSetId=$dataSetId, createdTime=$createdTime, lastUpdatedTime=$lastUpdatedTime, ]';
  }

  /// Call statically to get a list of [TimeSeriesModel] from a json list of timeseries.
  static List<TimeSeriesModel> listFromJson(List<dynamic> json) {
    List<TimeSeriesModel> ts = json == null
        ? <TimeSeriesModel>[]
        : json.map((value) => TimeSeriesModel.fromJson(value)).toList();
    return ts;
  }

  /// Constructor to create a [TimeSeriesModel] from a json.
  TimeSeriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    createdTime = json['createdTime'] ?? null;
    lastUpdatedTime = json['lastUpdatedTime'] ?? null;
    externalId = json['externalId'] ?? null;
    assetId = json['assetId'] ?? null;
    name = json['name'] ?? null;
    description = json['description'] ?? null;
    isString = json['isString'] ?? false;
    unit = json['unit'] ?? null;
    isStep = json['isStep'] ?? false;
  }

  /// Serialise to json
  Map toJson() => {
        'id': id,
        'createdTime': createdTime,
        'lastUpdatedTime': lastUpdatedTime,
        'externalId': externalId,
        'assetId': assetId,
        'name': name,
        'description': description,
        'isString': isString,
        'unit': unit,
        'isStep': isStep
      };
}
