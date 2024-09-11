import 'dart:convert';

import 'package:device_safety_info/device_safety_info.dart';
import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firmus/helper/logger.dart';
import 'package:firmus/infra/services/http/http_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_service.dart';

class DioHttpService implements HttpService {
  final ProviderRef ref;
  final dio = Dio();

  DioHttpService(this.ref);

  @override
  Future initialize() async {
    //
    //
    //dio.options.baseUrl = "http://192.168.0.19:3000";
    //

    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);

    bool isReal = kIsWeb ? false : await DeviceSafetyInfo.isRealDevice;

    if (kDebugMode) {
      if (isReal) {
        dio.options.baseUrl = "http://172.20.10.4:3000";
      } else {
        dio.options.baseUrl = "http://127.0.0.1:3000";
      }
    } else {
      dio.options.baseUrl = 'https://api.firmus.hr';
    }

    if (kDebugMode) {
      try {
        await dio.get(dio.options.baseUrl);
      } catch (e) {
        logger.info("Health Check Failed $e");
      }
      // dio.options.connectTimeout = const Duration(seconds: 1500); //5s
      // dio.options.receiveTimeout = const Duration(seconds: 1500);
    }

    dio.interceptors.add(RetryInterceptor(
      dio: dio,
      retryEvaluator: (e, _) async {
        if ([
          500,
          401,
          403,
          404,
          405,
        ].contains(e.response?.statusCode)) {
          return false;
        }
        return true;
      },
      logPrint: debugPrint,
      retries: 3,
      retryDelays: const [
        Duration(seconds: 1),
        Duration(seconds: 2),
        Duration(seconds: 3),
      ],
    ));

    dio.interceptors.add(InterceptorsWrapper(onRequest: (r, h) async {
      final token = await ref.refresh(tokenProvider.future);
      // logger.info("token is $token");
      r.headers["Authorization"] = "Bearer $token";
      return h.next(r);
    }, onResponse: (r, h) {
      if (r.data is String) {
        r.data = jsonDecode(r.data);
      }
      r.data ??= <String, dynamic>{};

      return h.next(r);
    }));
  }

  @override
  Future<T> request<T>(BaseHttpRequest request,
      {required T Function(Map<String, dynamic> response) converter}) async {
    Map<String, dynamic> value;

    debugPrint("${request.runtimeType} ${request.endpoint}");

    final data = request.contentType == Headers.multipartFormDataContentType
        ? FormData.fromMap(await request.toMap())
        : await request.toMap();

    value = await dio
        .requestUri(Uri.parse(request.endpoint),
            data: data,
            options: Options(
              method: request.type.name.toUpperCase(),
              contentType: request.contentType,
            ))
        .then((value) => value.data)
        .catchError((err, st) {
      if (err is DioException) {
        FirebaseCrashlytics.instance.recordError(err, st, information: [
          "Error in request ${request.runtimeType} ${request.endpoint} ${err.response?.statusCode} ${err.response}"
        ]);
        logger.severe(
            "Error in request ${request.runtimeType} ${request.endpoint} ${err.response?.statusCode} ${err.response}");
      }

      throw err;
    });

    return converter(value);
  }
}
