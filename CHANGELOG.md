# CHANGELOG

## Jul 11, 2021

* Add support for additional client param token to support standard bearer token  (OpenID Connect)
* Clean up null safety to avoid having null variables (history and client)
* Release updated preview at 0.2.0-nullsafety.1

## Jun 6, 2021

* Migrate to null safety
* BREAKING: getDatapoints() now returns an empty DatapointModel instead of null
* Release preview at 0.2.0-nullsafety

## Dec 3, 2020

* Publish 0.1.3
* BREAKING: Add a proper HistoryModel to access client.history (instead of Dio's Response).
## Nov 30, 2020

* Publish 0.1.2
## Nov 29, 2020

* Publish 0.1.2-dev.4
* Add example 
* BREAKING: Fix issue with dio dependency on dart:io, httpAdapter is now required

## Nov 29, 2020

* Initial publishing of 0.1.2-dev.3 in preperation for release of 0.1.2

## Nov 22, 2020

* Added support for layering
* More detailed documentation in preparation for package release

## Oct 3, 2020

* Add support to retrieve datapoints

## Oct 1, 2020

* Initial timeseries GET
