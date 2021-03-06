part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Represents the datapoints of a timeseries.
class DatapointsModel {
  /// A server-generated ID for the object.
  int? id;

  /// The externally supplied ID for the time series.
  String? externalId;

  /// Whether the time series is string valued or not.
  bool? isString;

  /// The physical unit of the time series.
  String? unit;

  /// Whether the time series is a step series or not.
  bool? isStep;

  /// Number of layers we have
  int layers = 0;

  List<DatapointModel> _datapoints = [];

  /// Always the number of datapoints in total across layers.
  get datapointsLength => _datapoints.length;

  /// The full list of [DatapointModel] with all layers.
  get datapoints => _datapoints;

  /// Used to retrieve a given layer (default last added).
  List<DatapointModel> layer({int? layer}) {
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

  /// Used to assign all unassigned datapoints to a new layer.
  void pushLayer() {
    layers += 1;
    _datapoints.forEach((element) {
      if (element.layer < 0) {
        element.layer = layers;
      }
    });
  }

  /// Delete all datapoints on the last layer.
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

  /// Clear all datapoints for layer information. Used by [addDatapoints].
  void clearLayers() {
    _datapoints.forEach((element) {
      element.layer = -1;
    });
  }

  /// Takes another [DatapointsModel] dp and adds all its datapoints as a new layer.
  ///
  /// [removeDuplicates] is default false and if true, same timestamp datapoints
  /// will be deleted.
  void addDatapoints(DatapointsModel dp, {removeDuplicates: false}) {
    dp.clearLayers();
    _datapoints.addAll(dp._datapoints);
    _datapoints.sort((a, b) => a.timestamp!.compareTo(b.timestamp!));
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
    _datapoints.forEach((element) => list.add(element.toJson() as Map<String, dynamic>));
    return {'externalId': externalId, 'datapoints': list};
  }
}
