import 'package:flutter_bili_app/http/dao/login_dao.dart';

enum HttpMethod { GET, POST, DELETE }

/// 基础请求

abstract class BaseRequest {
  // curl -X GET "https://api.devio.org/uapi/test/test?requestParams=11" -H "accept: */*"
  // curl -X GET "https://api.devio.org/uapi/test/test/1"

  var pathParams;
  var useHttps = false;
  String authority() {
    return "192.168.31.7:8080";
    // return "localhost:8080";
  }

  HttpMethod httpMethod();
  String path();
  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    // http or https
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    if (needLogin()) {
      // 需要登陆的借口携带登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }
    print('url:${uri.toString()}');
    return uri.toString();
  }

  bool needLogin();
  Map<String, String> params = Map();

  /// 添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = Map();

  /// 添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
