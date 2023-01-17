import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hamah_cs_admin/common/const/colors.dart';
import 'package:hamah_cs_admin/common/const/data.dart';

import '../../common/component/custom_text_form_field.dart';
import '../../common/layout/default_layout.dart';
import '../../common/view/root_tab.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    var refreshToken = '';

    return DefaultLayout(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          top: true,
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 70.0),
                _Title(),
                const SizedBox(height: 16.0),
                _SubTitle(),
                Image.asset(
                  'asset/img/logo/logo_login_screen.png',
                  width: MediaQuery.of(context).size.width / 3 * 2,
                ),
                const SizedBox(height: 50.0),
                CustomTextFormField(
                  hintText: '아이디를 입력해주세요.',
                  onChanged: (String value) {
                    username = value;
                  },
                ),
                const SizedBox(height: 16.0),
                CustomTextFormField(
                  hintText: '비밀번호를 입력해주세요.',
                  onChanged: (String value) {
                    password = value;
                  },
                  obscureText: true,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    final rawString = '$username:$password';

                    Codec<String, String> stringToBase64 = utf8.fuse(base64);
                    String token = stringToBase64.encode(rawString);

                    final resp = await dio.post('http://$ip/auth/login',
                      options: Options(
                        headers: {
                          'authorization': 'Basic $token',
                        },
                      ),
                    );

                    print(resp.data);
                    refreshToken = resp.data['refreshToken'];
                    storage.write(key: 'ACCESS_TOKEN', value: resp.data['accessToken']);
                    storage.write(key: 'REFRESH_TOKEN', value: resp.data['refreshToken']);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => RootTab(),
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PRIMARY_COLOR,
                  ),
                  child: Text(
                    '로그인',
                  ),
                ),
                TextButton(
                  onPressed: () async {

                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    '회원가입',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '환영합니다!',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      '아이디와 비밀번호를 입력해서 로그인 해주세요!\n오늘도 안전 작업하세요 :)',
      style: TextStyle(
        fontSize: 11,
        color: BODY_TEXT_COLOR,
      ),
    );
  }
}
