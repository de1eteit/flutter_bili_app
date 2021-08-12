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

class RegistrationPage extends StatefulWidget {
  final VoidCallback onJumpToLogin;

  const RegistrationPage({Key? key, required this.onJumpToLogin})
      : super(key: key);
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  bool protect = false;
  bool loginEnable = false;
  late String username;
  late String password;
  late String rePass;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('注册', '登录', widget.onJumpToLogin),
      body: Container(
        child: ListView(
          // 自适应键盘，防止遮挡
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
              keyboardType: TextInputType.text,
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
            LoginInput(
                title: "确认密码",
                hint: "请再次输入密码",
                lineStretch: true,
                obscureText: true,
                onChanged: (text) {
                  rePass = text;
                  checkInput();
                },
                focusChanged: (focus) {
                  this.setState(() {
                    protect = focus;
                  });
                },
                keyboardType: TextInputType.visiblePassword),
            LoginInput(
                title: "邮箱",
                hint: "请输入邮箱",
                lineStretch: true,
                onChanged: (text) {
                  email = text;
                  checkInput();
                },
                focusChanged: (focus) {},
                keyboardType: TextInputType.text),
            Padding(
              padding: EdgeInsets.only(top: 20, left: 20, right: 20),
              child: LoginButton(
                  title: '注册', enable: loginEnable, onPressed: checkParams),
            )
          ],
        ),
      ),
    );
  }

  void checkInput() {
    bool enable;
    if (isNotEmpty(username) &&
        isNotEmpty(password) &&
        isNotEmpty(rePass) &&
        isNotEmpty(email)) {
      enable = true;
    } else {
      enable = false;
    }
    setState(() {
      loginEnable = enable;
    });
  }

  _loginButton() {
    return InkWell(
      onTap: () {
        if (loginEnable) {
          checkParams();
        } else {
          print('loginEnable is false');
        }
      },
      child: Text('注册'),
    );
  }

  void send() async {
    try {
      var result = await LoginDao.registration(username, password, email);
      print(result);
      if (result['code'] == 200) {
        print("注册成功");
        showToast('注册成功');
        if (widget.onJumpToLogin != null) {
          widget.onJumpToLogin();
        }
      } else {
        print(result['message']);
        showWarnToast(result['message']);
      }
    } on NeedAuth catch (e) {
      print(e);
      showToast(e.message);
    } on HiNetError catch (e) {
      print(e);
      showToast(e.message);
    }
  }

  void checkParams() {
    String? tips;
    if (password != rePass && password != '') {
      tips = '两次密码不一致！';
    } else if (email == null || email == '') {
      tips = '请输入邮箱';
    }
    if (tips != null) {
      print(tips);
      return;
    }
    send();
  }
}
