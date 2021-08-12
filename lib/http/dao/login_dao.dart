import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/http/request/login_request.dart';
import 'package:flutter_bili_app/http/request/registration_request.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";

  static login(String username, String password) {
    return _send(username, password);
  }

  static registration(String username, String password, String email) async {
    return _send(username, password, email: email);
  }

  static _send(String username, String password, {email}) async {
    BaseRequest request;
    if (email != null) {
      request = RegistrationRequest();
      request
          .add('username', username)
          .add('password', password)
          .add('email', email);
    } else {
      request = LoginRequest();
      request.add('username', username).add('password', password);
    }

    var result = await HiNet.getInstance().fire(request);
    // print(result);
    if (result['code'] == 200 && result['data'] != null) {
      HiCache.getInstance().setString(BOARDING_PASS, result['data']);
    }
    return result;
  }

  static getBoardingPass() {
    return HiCache.getInstance().get(BOARDING_PASS);
  }
}
