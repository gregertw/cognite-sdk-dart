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

```
var apiClient = CDFApiClient(
           project: 'project_name',
           apikey: 'myapi_key',
           baseUrl: 'https://api.cognitedata.com/')

var res = await TimeSeriesAPI(apiClient).getAllTimeSeries();
```