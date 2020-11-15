part of 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

class DatapointsFilterModel {
  int _start = 0;
  int _end = 0;
  int limit;
  List<String> aggregates = const [];
  int _resolution;
  String granularity;
  bool includeOutsidePoints;
  String externalId;

  get resolution => _resolution;
  set start(int i) {
    if (i <= 0) {
      throw CdfApiClientDatapointFilterException;
    } else {
      _start = i;
    }
  }

  get start => _start;
  get end => _end;
  set end(int i) {
    if (i <= 0) {
      throw CdfApiClientDatapointFilterException;
    } else if (i <= _start) {
      _end = _start + 1;
    } else {
      _end = i;
    }
  }

  set resolution(int r) {
    if (r >= 60 * 60 * 24) {
      // Days
      _resolution = (r / (60 * 60 * 24)).round() * 60 * 60 * 24;
      granularity = (r / (60 * 60 * 24)).round().toString() + 'd';
    } else if (r >= 60 * 60) {
      // Hours
      _resolution = (r / (60 * 60)).round() * 60 * 60;
      granularity = (r / (60 * 60)).round().toString() + 'h';
    } else if (r >= 60) {
      // Minutes
      _resolution = (r / 60).round() * 60;
      granularity = (r / 60).round().toString() + 'm';
    } else {
      // Seconds
      _resolution = r;
      if (_resolution < 1) {
        _resolution = 1;
      }
      granularity = _resolution.toString() + 's';
    }
    calculateLimit();
  }

  @override
  String toString() {
    return 'DatapointsFilterModel[ externalId=$externalId, start=$_start, end=$_end, aggregates=$aggregates, resolution=$_resolution, granularity=$granularity, limit=$limit, includeOutsidePoints=$includeOutsidePoints ]';
  }

  calculateLimit() {
    if (_start > 0 && _end > 0) {
      limit = ((_end - _start) / (1000 * _resolution)).round();
      if (aggregates != null && limit > 10000) {
        limit = 10000;
      } else if (limit > 100000) {
        limit = 100000;
      }
      if (limit < 100) {
        limit = 100;
      }
    }
  }

  Map toJson() {
    Map ret = {
      'externalId': externalId,
      'start': _start ?? 0,
      'end': _end ?? 0,
      'limit': limit ?? 100,
      'includeOutsidePoints': includeOutsidePoints ?? false
    };
    if (aggregates.isNotEmpty) {
      ret['aggregates'] = aggregates;
      if (granularity != null) {
        ret['granularity'] = granularity;
      } else {
        // Granularity must be set if aggregates is set
        throw (CdfApiClientParameterException);
      }
    }
    return ret;
  }
}
