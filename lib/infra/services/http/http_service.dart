import 'dart:async';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:firmus/infra/services/http/dio_http_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final httpServiceProvider = Provider<HttpService>((ref) => DioHttpService(ref));


abstract class HttpService {
  Future initialize();

  Future<T> request<T>(BaseHttpRequest request,
      {required T Function(Map<String, dynamic> response) converter  });
}

Map<String, dynamic> defaultConverter(Map<String, dynamic> c) {
  return c;
}

enum RequestType { get, post, patch, delete }

abstract class BaseHttpRequest with EquatableMixin {
  final String endpoint;
  final RequestType type;
  final String contentType;

  FutureOr<Map<String, dynamic>> toMap();

  const BaseHttpRequest({
    required this.endpoint,
    this.type = RequestType.get,
    this.contentType = Headers.jsonContentType,
  });

  @override
  List<Object?> get props => [endpoint, type, contentType, toMap()];
}

class GetRequest extends BaseHttpRequest {
  const GetRequest({
    required String endpoint,
  }) : super(endpoint: endpoint, type: RequestType.get);

  @override
  Map<String, dynamic> toMap() {
    return {};
  }
}

class PostRequest extends BaseHttpRequest {
  final Map<String, dynamic> body;

  const PostRequest({
    required String endpoint,
    required this.body,
  }) : super(endpoint: endpoint, type: RequestType.post);

  @override
  Map<String, dynamic> toMap() {
    return body;
  }
}
