import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:tasker/model/event_object.dart';
import 'package:tasker/constants.dart';

Future<EventObject> httpDelete({
  required http.Client client,
  required String url,
}) async {
  final http.Response response;
  try {
    response = await client.delete(
      Uri.parse(ApiConstants.parseUrl + url),
      headers: <String, String>{
        'X-Parse-Application-Id': ApiConstants.parseAppID,
        'X-Parse-REST-API-Key': ApiConstants.parseApiKey,
        'Content-Type': 'application/json',
      },
    );

    // ignore: avoid_print
    print(
        'Request: ${ApiConstants.parseUrl}$url \nStatusCode: ${response.statusCode}\nResponse: ${response.body}');

    switch (response.statusCode) {
      case 200:
      case 201:
        return EventObject(
          id: EventConstants.requestSuccessful,
          response: response.body,
          statusCode: response.statusCode
        );
      case 400:
      case 401:
        return EventObject(
          id: EventConstants.requestUnsuccessful,
          response: response.body,
          statusCode: response.statusCode
        );
      default:
        throw Exception('Oops! Invalid response');
    }
  } catch (exception) {
    throw Exception('Oops! Invalid response');
  }
}
