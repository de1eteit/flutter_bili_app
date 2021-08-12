import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/core/hi_error.dart';
import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/util/string_util.dart';
import 'package:flutter_bili_app/util/toast.dart';
import 'package:flutter_bili_app/widget/appbar.dart';
import 'package:flutter_bili_app/widget/login_button.dart';
import 'package:flutter_bili_app/widget/login_effect.dart';
import 'package:flutter_bili_app/widget/login_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool protect = false;
  bool loginEnable = false;
  late String username;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('密码登录', '注册', () {
        //
      }),
      body: Container(
        child: ListView(
          children: [
            LoginEffect(protect: protect),
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              onChanged: (text) {
                username = text;
                checkInput();
              },
              focusChanged: (bool value) {},
              keyboardType: TextInputType.name,
            ),
            LoginInput(
                title: "密码",
                hint: "请输入密码",
                lineStretch: true,
                obscureText: true,
                onChanged: (text) {
                  password = text;
                  checkInput();
                },
                focusChanged: (focus) {
                  this.setState(() {
                    protect = focus;
                  });
                },
                keyboardType: TextInputType.visiblePassword),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: LoginButton(
                  title: '登录',
                  enable: loginEnable,
                  onPressed: send,
                )),
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(username) && isNotEmpty(password)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  void send() async {
    try {
      var result = await LoginDao.login(username, password);
      print(result);
      if (result['code'] == 200) {
        print("登录成功");
        showToast("登陆成功");
      } else {
        print(result['message']);
        showWarnToast(result['message']);
      }
    } on NeedAuth catch (e) {
      print(e);
    } on HiNetError catch (e) {
      print(e);
    }
  }
}
