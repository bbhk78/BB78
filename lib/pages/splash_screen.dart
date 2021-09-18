import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 150),
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Image.asset('assets/logo.png', width: 150),
                  const SizedBox(height: 30),
                  Text(
                    'app title'.tr,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'OpenSans SemiBold'),
                  ),
                  Text(
                    'app subtitle'.tr,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontFamily: 'OpenSans SemiBold'),
                  )
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                'app author'.tr,
                style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: 'OpenSans SemiBold'),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      );
}
