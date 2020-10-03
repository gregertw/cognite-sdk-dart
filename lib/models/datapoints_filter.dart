part of 'package:cognite_dart_sdk/cognite_dart_sdk.dart';

class DatapointsFilterModel {
  int start;
  int end;
  int limit;
  List<String> aggregates = const [];
  String granularity;
  bool includeOutsidePoints;
  String externalId;

  @override
  String toString() {
    return 'DatapointsFilterModel[ externalId=$externalId, start=$start, end=$end, aggregates=$aggregates, granularity=$granularity, includeOutsidePoints=$includeOutsidePoints ]';
  }

  Map toJson() {
    Map ret = {
      'externalId': externalId,
      'start': start ?? 0,
      'end': end ?? 0,
      'limit': limit ?? 100,
      'includeOutsidePoints': includeOutsidePoints ?? false
    };
    if (aggregates.isNotEmpty) {
      ret['aggregates'] = aggregates;
      if (granularity != null) {
        ret['granularity'] = granularity;
      } else {
        // Granularity must be set if aggregates is set
        throw (CDFApiClient_ParameterException);
      }
    }
    return ret;
  }
}
