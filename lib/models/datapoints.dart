part of 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

class DatapointsModel {
  /* A server-generated ID for the object. */
  int id;
  /* The externally supplied ID for the time series. */
  String externalId;
  /* Whether the time series is string valued or not. */
  bool isString;
  /* The physical unit of the time series. */
  String unit;
  /* Whether the time series is a step series or not. */
  bool isStep;

  List<DatapointModel> datapoints = const [];

  @override
  String toString() {
    return 'DatapointsModel[id=$id, externalId=$externalId, isString=$isString, unit=$unit, isStep=$isStep, datapoints=$datapoints ]';
  }

  fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    externalId = json['externalId'] ?? null;
    isString = json['isString'] ?? null;
    unit = json['unit'] ?? null;
    isStep = json['isStep'] ?? null;
    datapoints = DatapointModel.listFromJson(json['datapoints'] ?? null);
  }

  Map toJson() {
    List<Map<String, dynamic>> list = const [];
    datapoints.forEach((element) => list.add(element.toJson()));
    return {'externalId': externalId, 'datapoints': list};
  }
}
