class ApiConstants {
  static const parseUrl = "https://parseapi.back4app.com/classes/";
  static const parseAppID = "bGUqBujXHjRUSSQv2gjyWg3k47FCH7h3Xg0XrHel";
  static const parseApiKey = "7a0vERfbTOdmFDQHLIPKYv3ka5f5bRmO8q4GHQsQ";

  static const task = "Task";
  static const tasks = "Tasks";
}


class EventConstants {
  static const int serverError = 3;
  static const int forbidden = 5;
  static const int requestSuccessful = 10;
  static const int requestUnsuccessful = 11;
  static const int requestNotFound = 12;
  static const int requestSuspended = 13;
  static const int requestUnpermited = 14;
  static const int requestInvalid = 15;
  static const int serviceUnavailable = 16;
  static const int preconditionFailed = 17;

  static const int noInternetConnection = 20;
}

class EventMessages {
  static const String preconditionFailed = 'Pre condition failed';
}
