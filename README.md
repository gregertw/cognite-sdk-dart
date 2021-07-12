# cognite_cdf_sdk

**Maintainer**: Greger Wedel, https://github.com/gregertw

A Dart package with a simple SDK for Cognite CDF API, https://docs.cognite.com/dev/.

This SDK has been developed specifically for the needs of a Flutter application for
time series exploration. Thus, it has built in support for layering of datapoints that
simplifies zoom in, zoom out, and visual exploration of a plotted time series. 
It also has a history of requests that can be used to see exactly the REST API requests
and responses that have been executed.

The SDK is currently limited to the timeseries API and is read-only, but it should
be fairly easy to extend.

## Disclaimer

Although developed by an employee of Cognite, this SDK has been developed as part
of a personal tinkering project, and there are no guarantees that this SDK will be
kept updated or extended. It is shared Apache-2 licensed for the benefit of anybody 
who may have a need for a Dart SDK or may want to contribute.

## Contributing

All activity related to this SDK is on Github. Please use the issue tracker to submit
bugs or feature suggestions, or even better: submit a PR!

## Getting Started

Instantiate an http client and off you go!

NOTE!!! You need to supply an HttpClientAdapter() implementation as either found
in dio/adapter.dart (DefaultHttpClientAdapter()) or dio/adapter_browser.dart
(BrowserHttpClientAdapter()). See below for how to support both web and app.

```
import 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';
import 'package:dio/adapter.dart';

main() async {
  var apiClient = CDFApiClient(
      project: 'project_name',
      apikey: 'myapi_key',
      baseUrl: 'https://api.cognitedata.com/',
      httpAdapter: DefaultHttpClientAdapter());

  var res = await TimeSeriesAPI(apiClient).getAllTimeSeries();
  if (res != null && res.length >= 1) {
    print(res[0].externalId);
  }
}
```

## Use Web and App httpAdapter in Same Code

Create two files, httpadapter.dart and webhttpadapter.dart, that both defines a GenericHttpAdapter() class:

httpadapter.dart:
```
import 'package:dio/adapter.dart';

class GenericHttpClientAdapter extends DefaultHttpClientAdapter {}
```

webhttpadapter.dart:
```
import 'package:dio/adapter_browser.dart';

class GenericHttpClientAdapter extends BrowserHttpClientAdapter {}
```

You can then use the generic adapter class this way:
```
import 'httpadapter.dart' if (dart.library.html) 'webhttpadapter.dart';
var client = CDFApiClient(httpAdapter: GenericHttpClientAdapter());
```