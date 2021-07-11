part of 'package:cognite_cdf_sdk/cognite_cdf_sdk.dart';

/// Returned data from [CDFApiClient.getStatus].
class StatusModel {
  String? user;
  bool loggedIn = false;
  String? project;
  List<String>? projects;
  int? projectId;
  int? apiKeyId;

  @override
  String toString() {
    return 'StatusModel[ user=$user, loggedIn=$loggedIn, project=$project, projectId=$projectId, apiKeyId=$apiKeyId ]';
  }

  StatusModel();

  StatusModel.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('user')) {
      user = json['user'] ?? null;
      loggedIn = json['loggedIn'] ?? false;
      project = json['project'] ?? null;
      projects = null;
      projectId = json['projectId'] ?? null;
      apiKeyId = json['apiKeyId'] ?? null;
    } else if (json.containsKey('subject')) {
      user = json['subject'] ?? null;
      loggedIn = true;
      if (json.containsKey('projects')) {
        project = json['projects'][0]["projectUrlName"] ?? null;
        projects = <String>[];
        for (Map<String, dynamic> j in json['projects']) {
          projects?.add(j["projectUrlName"]);
        }
      } else {
        project = null;
      }
      projectId = null;
      apiKeyId = null;
    }
  }

  Map toJson() => {
        'user': user,
        'loggedIn': loggedIn,
        'project': project,
        'projects': projects,
        'projectId': projectId,
        'apiKeyId': apiKeyId
      };
}
