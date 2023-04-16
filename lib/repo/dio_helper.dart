import 'package:dio/dio.dart';

class DioHelper {
  late Dio dio;

  DioHelper() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://fcm.googleapis.com/fcm/',
      receiveDataWhenStatusError: true,
      connectTimeout: 50000,
      sendTimeout: 50000,
      validateStatus: (status) {
        return status! < 500;
      },
    ));
  }

  Future<Response> postData({
    String path = 'send',
    required Map<String, String> sendData,
    required String title,
    required String body,
  }) async {

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=BBT8hWRgo9QKIJEX3etz2NudPhdh3AnN6gWxqw3JI89p3NaDFtIQK2rwu11W-BUM88AIGOTWRWGDSEUKdNTJQmY',
    };

    Map<String, dynamic> data = {
      "data": '',
      "to": "/topics/alert",
      "notification": {"title": title, "body": body, "sound": "default"},
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      }
    };

    return await dio.post(path, data: data).catchError((err) {
      print(exceptionsHandle(error: err));
    }).whenComplete((){
      print('done');
    });
  }

  String exceptionsHandle({required DioError error}) {
    final String message;
    switch (error.type) {
      case DioErrorType.connectTimeout:
        message = 'server not reachable';
        break;

      case DioErrorType.sendTimeout:
        message = 'send Time out';
        break;
      case DioErrorType.receiveTimeout:
        message = 'server not reachable';
        break;
      case DioErrorType.response:
        message = 'the server response, but with a incorrect status';
        break;
      case DioErrorType.cancel:
        message = 'request is cancelled';
        break;
      case DioErrorType.other:
        error.message.contains('SocketException')
            ? message = 'check your internet connection'
            : message = error.message;
        break;
    }
    return message;
  }
}
