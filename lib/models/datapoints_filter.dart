part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Used to create filter for [TimeSeriesAPI.getDatapoints].
///
/// Does not support querying for multiple timeseries per request.
/// Instead of using granularity and limit, use [resolution()] as it
/// will automatically calculate granularity and limit based on the granularity
/// in seconds.
class DatapointsFilterModel {
  /// Get datapoints starting from, and including, this time.
  int _start = 0;

  /// Get datapoints up to, but excluding, this point in time.
  int _end = 0;

  /// Return up to this number of datapoints.
  ///
  /// Maximum is 100000 non-aggregated data points and 10000 aggregated data points.
  int? limit;

  /// Specify the aggregates to return, or an empty array if this sub-query should return datapoints without aggregation.
  ///
  /// "average" "max" "min" "count" "sum" "interpolation" "stepInterpolation"
  /// "totalVariation" "continuousVariance" "discreteVariance"
  List<String> aggregates = const [];
  late int _resolution;

  /// The time granularity size and unit to aggregate over.
  String? granularity;

  /// Whether to include the last datapoint before the requested time period, and the first one after.
  bool? includeOutsidePoints;

  /// ExternalId of timeseries to retrieve.
  String? externalId;

  /// The resolution in seconds (i.e. time between each datapoint).
  int get resolution => _resolution;
  set start(int i) {
    if (i <= 0) {
      throw CDFApiClientDatapointFilterException;
    } else {
      _start = i;
    }
  }

  int get start => _start;
  int get end => _end;
  set end(int i) {
    if (i <= 0) {
      throw CDFApiClientDatapointFilterException;
    } else if (i <= _start) {
      _end = _start + 1;
    } else {
      _end = i;
    }
  }

  /// Given seconds [r] of time between each datapoint desired, set granularity and limit.
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

  /// Will calculate the limit to request based on range and resolution set.
  calculateLimit() {
    if (_start > 0 && _end > 0) {
      limit = ((_end - _start) / (1000 * _resolution)).round();
      if (limit! > 10000) {
        limit = 10000;
      } else if (limit! > 100000) {
        limit = 100000;
      }
      if (limit! < 100) {
        limit = 100;
      }
    }
  }

  Map toJson() {
    Map ret = {
      'externalId': externalId,
      'start': _start,
      'end': _end,
      'limit': limit ?? 100,
      'includeOutsidePoints': includeOutsidePoints ?? false
    };
    if (aggregates.isNotEmpty) {
      ret['aggregates'] = aggregates;
      if (granularity != null) {
        ret['granularity'] = granularity;
      } else {
        // Granularity must be set if aggregates is set
        throw (CDFApiClientParameterException);
      }
    }
    return ret;
  }
}
