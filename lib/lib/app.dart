import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'theme/app_colors.dart';
import 'pages/home_page.dart';

class PunjabSchemesApp extends StatelessWidget {
  const PunjabSchemesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Punjab Education Schemes',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: kBg,
            colorScheme: ColorScheme.fromSeed(
              seedColor: kPrimaryGreen,
              primary: kPrimaryGreen,
              secondary: kGold,
            ),
            fontFamily: 'Roboto',
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
