import 'package:flutter/material.dart';

import '../../../../../base/app_constants.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: AssetImage('assets/images/splash_logo.png'),
              width: 120,
              height: 120,
            ),
            SizedBox(height: 24),
            Text(
              kAppName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
