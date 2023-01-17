import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hamah_cs_admin/common/const/data.dart';
import 'package:hamah_cs_admin/common/layout/default_layout.dart';
import 'package:hamah_cs_admin/common/view/root_tab.dart';

import '../../user/view/login_screen.dart';
import '../const/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    //deleteTokne();

    Future.delayed(const Duration(seconds: 2)).then((_) {
      checkToken();
    });

  }

  void deleteTokne() async {
    await storage.deleteAll();
  }

  void checkToken() async {
    // 유효기간 : 하루
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    // 유효기간 : 5분
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final dio = Dio();

    try{
      final resp = await dio.post(
        'http://$ip/auth/token',
        options: Options(
          headers: {
            'authorization': 'Bearer $refreshToken'
          },
        ),
      );

      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.data['accessToken']);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => RootTab(),
        ),
            (route) => false,
      );
    }catch(e){
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => LoginScreen(),
        ),
            (route) => false,
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
        backgroundColor: WHITE_COLOR,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Image.asset(
                'asset/img/logo/logo.png',
                width: MediaQuery.of(context).size.width /2,
              ),
              const SizedBox(height: 16.0),
              CircularProgressIndicator(
                color: Colors.lightBlue,
              )
            ],
          ),
        )
    );
  }
}
