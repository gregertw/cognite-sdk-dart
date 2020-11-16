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
  /* Number of layers we have */
  int layers = 0;

  List<DatapointModel> _datapoints = [];
  get datapointsLength => _datapoints.length;

  get datapoints => _datapoints;

  List<DatapointModel> layer({int layer}) {
    // Return only last layer if no layer specified
    if (layer == null) {
      layer = layers;
    }
    List<DatapointModel> ret = [];
    _datapoints.forEach((element) {
      if (element.layer == layer) {
        ret.add(element);
      }
    });
    return ret;
  }

  @override
  String toString() {
    return 'DatapointsModel[id=$id, externalId=$externalId, isString=$isString, unit=$unit, isStep=$isStep, datapoints=$_datapoints ]';
  }

  void pushLayer() {
    layers += 1;
    _datapoints.forEach((element) {
      if (element.layer < 0) {
        element.layer = layers;
      }
    });
  }

  void popLayer() {
    if (layers == 0) {
      return;
    }
    for (var i = 0; i < _datapoints.length; i++) {
      if (_datapoints[i].layer == layers) {
        _datapoints.removeAt(i);
        i--;
      }
    }
    layers -= 1;
  }

  void clearLayers() {
    _datapoints.forEach((element) {
      element.layer = -1;
    });
  }

  void addDatapoints(DatapointsModel dp, {removeDuplicates: false}) {
    dp.clearLayers();
    _datapoints.addAll(dp._datapoints);
    _datapoints.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    // Remove duplicates
    if (removeDuplicates) {
      for (var i = 0; i < _datapoints.length - 1; i++) {
        if (_datapoints[i].timestamp == _datapoints[i + 1].timestamp) {
          _datapoints.removeAt(i + 1);
        }
      }
    }
    pushLayer();
  }

  fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? null;
    externalId = json['externalId'] ?? null;
    isString = json['isString'] ?? null;
    unit = json['unit'] ?? null;
    isStep = json['isStep'] ?? null;
    _datapoints = DatapointModel.listFromJson(json['datapoints'] ?? null);
    pushLayer();
  }

  Map toJson() {
    List<Map<String, dynamic>> list = const [];
    _datapoints.forEach((element) => list.add(element.toJson()));
    return {'externalId': externalId, 'datapoints': list};
  }
}
