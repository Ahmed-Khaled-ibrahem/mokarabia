import 'package:dio/dio.dart';

class DioHelper {
  late Dio dio;
  String serverKey = 'AAAA0D7H_XQ:APA91bGu2eXPk11JH9oMx-f-fpTgDCXwqsaNQq7lTqUOEmnQM0u2rDpF5RyJyAboQqoP2gqpQJNDwW0MnjTe-m1YXL2ivZtIu1WgOG17sy1whpRsD95OMM2u4WyHFqxOkvmKQlF4uRSE';

  DioHelper() {
    dio = Dio(BaseOptions(
      // baseUrl: 'https://fcm.googleapis.com//v1/projects/mokarabia-50550/messages:send',
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
      'Authorization': 'key=$serverKey',
    };

    Map<String, dynamic> data = {
      "data": '',
      'topic':'alert',
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
