import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:inspector/app/config/api.dart';
import 'package:inspector/app/config/constant.dart';
import 'package:inspector/app/data/public_model.dart';
import 'package:inspector/app/tools/global_const.dart';
import 'package:inspector/app/tools/tools.dart';

import 'device.dart';

class Server {
  static String get domain {
    final env = GlobalConst.sharedPreferences?.getBool(Constant.env) ?? false;
    //return 'http://app.inspectors.cloud/';
    if (env) {
      return 'https://app.globalinsp.com/';
    } else {
      return 'https://app.globalinsp.com/';
    }
  }

  static String get web {
    final env = GlobalConst.sharedPreferences?.getBool(Constant.env) ?? true;
    if (env) {
      return 'https://app.globalinsp.com/';
    } else {
      return 'https://app.globalinsp.com/';
    }
  }
}

class ContentType {
  static String formData = "multipart/form-data";
  static String json = "application/json";
  static String formValue = "application/x-www-form-urlencoded";
  static String text = "application/text";
}

class LogInterceptor extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    Map<String, dynamic> headers = {};
    headers['appVersion'] = DeviceUtils.version;
    headers['osType'] = DeviceUtils.osType;
    headers['osVersion'] = DeviceUtils.sysVersion;
    headers['deviceType'] = DeviceUtils.deviceName;
    headers['deviceId'] = DeviceUtils.deviceId;
    headers['timestamp'] = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (GlobalConst.userModel?.token != null) {
      headers['token'] = GlobalConst.userModel!.token;
    }
    //mydev
    // print("===============GlobalConst.userModel===================");
    //print(GlobalConst.userModel);
    if (GlobalConst.userModel?.im_token != null) {
      headers['imtoken'] = GlobalConst.userModel!.im_token;
    }
    int language =
        GlobalConst.sharedPreferences?.getInt(Constant.kLanguage) ?? 999;
    headers['language'] = 'English';
    if (language != 999) {
      if (language == 3) {
        headers['language'] = 'German';
      } else if (language == 2) {
        headers['language'] = 'French';
      } else if (language == 1) {
        headers['language'] = 'Chinese';
      }
    }
    options.headers.addAll(headers);

    logger.d(
        'request: ${options.uri} headers :${options.headers} data:${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
        'respose: ${response.requestOptions.uri} ${response.requestOptions.data.toString()} ${response.toString()}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    logger.e(
        'error ${err.requestOptions.uri} ${err.message} ${err.response.toString()}');
    super.onError(err, handler);
  }
}

class PublicProvider {
  factory PublicProvider() => _getInstance() ?? PublicProvider();

  static PublicProvider? get instance => _getInstance();

  // 静态变量_instance，存储唯一对象
  static PublicProvider? _instance;
  final Dio _dio = Dio();

  // 获取对象
  static PublicProvider? _getInstance() {
    _instance ??= PublicProvider._internal();

    return _instance;
  }

  PublicProvider._internal() {
    _dio.interceptors.add(LogInterceptor());
    //
    // (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (client) {
    //   client.findProxy = (Uri) {
    //     return 'PROXY 192.168.31.128:8888';
    //   };
    // };
  }

  static _config() {
    instance!._dio.options.baseUrl = Server.domain;
    instance!._dio.options.method = 'POST';
    instance!._dio.options.contentType = ContentType.json;
    instance!._dio.options.connectTimeout = 10;
    instance!._dio.options.sendTimeout = 10;
    instance!._dio.options.receiveTimeout = 10;
    instance!._dio.options.responseType = ResponseType.json;
  }

  //mydev
  static Future<BaseModel<T>> request<T>({
    required String path,
    dynamic params,
    String? type,
    //mydev
    bool? chat,
    bool isAll = false,
    bool isPost = true,
    bool isDelete = false,
  }) async {
    _config();
    var url = !isAll ? instance!._dio.options.baseUrl + path : path;
    //mydev
    if (chat == true) {
      url = "http://wchat.inspector.ltd/api/" + path;
    }
    final response = await instance?._dio.fetch(
      RequestOptions(
          path: url,
          method: isDelete
              ? 'DELETE'
              : isPost
                  ? 'POST'
                  : 'GET',
          data: params,
          contentType: type),
    );
    // print("===response===response=====response====response===");
    // print(response);
    // print("===response===response=====response====response===");
    return BaseModel.fromJson(response);
  }

  static Future<dynamic> oriRequest({
    required String path,
    dynamic params,
    String? type,
    bool isPost = true,
  }) async {
    _config();
    final response = await instance?._dio.fetch(RequestOptions(
        path: path,
        method: isPost ? 'POST' : 'GET',
        data: params,
        contentType: type));
    return response?.data;
  }

  static Future<String?> uploadImages(String filePath, UploadType type) async {
    return PublicProvider.request<dynamic>(
            path: Api.uploadImage,
            isPost: true,
            params: FormData.fromMap({
              'type': type.name,
              'picfile':
                  await MultipartFile.fromFile(filePath, filename: filePath)
            }),
            type: "multipart/form-data")
        .then((value) async {
      if (value.isSuccess && value.data != null) {
        return value.data?.values.first;
      }
      return null;
    });
  }

  static Future<String?> userGps(num? lat, num? lon) async {
    if (lat == null || lon == null) {
      return Future.value();
    }

    return PublicProvider.request<String>(
        path: Api.userGps, params: {'lat': lat, 'lon': lon}).then((value) {
      if (value.isSuccess && value.data != null) {
      } else {
        return null;
      }
    });
  }
}

class FileInfo {
  String? url;
  String? name;

  FileInfo(this.url, this.name);
}

enum UploadType { plain, iden, resume }
