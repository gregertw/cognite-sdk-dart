part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

class StatusModel {
  String user;
  bool loggedIn;
  String project;
  int projectId;
  int apiKeyId;

  @override
  String toString() {
    return 'StatusModel[ user=$user, loggedIn=$loggedIn, project=$project, projectId=$projectId, apiKeyId=$apiKeyId ]';
  }

  StatusModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] ?? null;
    loggedIn = json['loggedIn'] ?? false;
    project = json['project'] ?? null;
    projectId = json['projectId'] ?? null;
    apiKeyId = json['apiKeyId'] ?? null;
  }

  Map toJson() => {
        'user': user,
        'loggedIn': loggedIn,
        'project': project,
        'projectId': projectId,
        'apiKeyId': apiKeyId
      };
}
