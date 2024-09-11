import 'package:firmus/main.dart';
import 'package:flutter/material.dart';
import 'package:firmus/helper/logger.dart';

class FigmaColors {
  const FigmaColors();

  static const Color dMSurface = Color(0xff121212);
  static const Color dMPrimary = Color(0xff1f1b24);
  static const Color dMSurface1 = Color(0xff373737);
  static const Color dMSurface2 = Color(0xff363636);
  static const Color dMSurface3 = Color(0xff323232);
  static const Color dMSurface4 = Color(0xff2d2d2d);
  static const Color dMSurface5 = Color(0xff272727);
  static const Color dMSurface6 = Color(0xff252525);
  static const Color primaryPrimary100 = Color(0xff1479ec);
  static const Color primaryPrimary90 = Color(0xe51479ec);
  static const Color primaryPrimary80 = Color(0xcc1479ec);
  static const Color primaryPrimary70 = Color(0xb21479ec);
  static const Color primaryPrimary60 = Color(0x991479ec);
  static const Color primaryPrimary50 = Color(0x801479ec);
  static const Color primaryPrimary40 = Color(0x661479ec);
  static const Color primaryPrimary30 = Color(0x4d1479ec);
  static const Color primaryPrimary20 = Color(0x331479ec);
  static const Color primaryPrimary10 = Color(0x1a1479ec);
  static const Color secondarySecondary100 = Color(0xffec8714);
  static const Color secondarySecondary90 = Color(0xe5ec8714);
  static const Color secondarySecondary80 = Color(0xccec8714);
  static const Color secondarySecondary70 = Color(0xb2ec8714);
  static const Color secondarySecondary60 = Color(0x99ec8714);
  static const Color secondarySecondary50 = Color(0x80ec8714);
  static const Color secondarySecondary40 = Color(0x66ec8714);
  static const Color secondarySecondary30 = Color(0x4dec8714);
  static const Color secondarySecondary20 = Color(0x33ec8714);
  static const Color secondarySecondary10 = Color(0x1aec8714);
  static const Color neutralBlack = Color(0xff09101d);
  static const Color neutralNeutral1 = Color(0xff2c3a4b);
  static const Color neutralNeutral2 = Color(0xff394452);
  static const Color neutralNeutral3 = Color(0xff545d69);
  static const Color neutralNeutral4 = Color(0xff6d7580);
  static const Color neutralNeutral5 = Color(0xff858c94);
  static const Color neutralNeutral6 = Color(0xffa5abb3);
  static const Color neutralNeutral7 = Color(0xffdadee3);
  static const Color neutralNeutral8 = Color(0xffebeef2);
  static const Color neutralNeutral9 = Color(0xfff4f6f9);
  static const Color neutralWhite = Color(0xffffffff);
  static const Color accentAccent1 = Color(0xffecb2f2);
  static const Color accentAccent128 = Color(0x47ecb2f2);
  static const Color accentAccent2 = Color(0xff2d6a6a);
  static const Color accentAccent210 = Color(0x1a2d6a6a);
  static const Color accentAccent3 = Color(0xffe9ad8c);
  static const Color accentAccent323 = Color(0x3be9ad8c);
  static const Color accentAccent4 = Color(0xff221874);
  static const Color accentAccent410 = Color(0x1a221874);
  static const Color accentAccent5 = Color(0xff7cc6d6);
  static const Color accentAccent525 = Color(0x407cc6d6);
  static const Color accentAccent6 = Color(0xffe1604d);
  static const Color accentAccent615 = Color(0x26e1604d);
  static const Color statusSuccess = Color(0xff287d3c);
  static const Color statusSuccessBG = Color(0xffedf9f0);
  static const Color statusWarning = Color(0xffb95000);
  static const Color statusWarningBG = Color(0xfffff4ec);
  static const Color statusError = Color(0xffda1414);
  static const Color statusErrorBG = Color(0xfffeefef);
  static const Color statusInfo = Color(0xff2e5aac);
  static const Color statusInfoBG = Color(0xffeef2fa);
  static const Color actionPrimaryDefault = Color(0xff1479ec);
  static const Color actionPrimaryHover = Color(0xff1c66bc);
  static const Color actionPrimaryActive = Color(0xff0e54a5);
  static const Color actionPrimaryDisabled = Color(0x660e54a5);
  static const Color actionPrimaryHover10 = Color(0x1acc5f00);
  static const Color actionPrimaryActive20 = Color(0x33b25300);
  static const Color actionPrimaryInverted = Color(0xffffffff);
  static const Color actionPrimaryVisited = Color(0xff5e38ba);
  static const Color actionSecondaryDefault = Color(0xff19ab4f);
  static const Color actionSecondaryHover = Color(0xff0c9e42);
  static const Color actionSecondaryActive = Color(0xff009236);
  static const Color actionSecondaryDisabled = Color(0x8019ab4f);
  static const Color actionSecondaryHover10 = Color(0x1a0c9d41);
  static const Color actionSecondaryActive20 = Color(0x33009436);
  static const Color actionSecondaryInverted = Color(0xffffffff);
  static const Color actionSecondaryVisited = Color(0xff5e38ba);
  static const Color actionNeutralDefault = Color(0xff9098a1);
  static const Color actionNeutralHover = Color(0xff858c94);
  static const Color actionNeutralActive = Color(0xff798087);
  static const Color actionNeutralDisabled = Color(0xb29098a1);
  static const Color actionNeutralHover10 = Color(0x1a6d7580);
  static const Color actionNeutralActive20 = Color(0x336d7580);
  static const Color actionNeutralInverted = Color(0xffffffff);
  static const Color actionNeutralVisited = Color(0xff5e38ba);
}

class FigmaTextStyles {
  const FigmaTextStyles();

  TextStyle get displayLargeHeavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 69,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 76 / 69,
        letterSpacing: 0,
      );

  TextStyle get displayLargeHeavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 51,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 56 / 51,
        letterSpacing: 0,
      );

  TextStyle get displayLargeHeavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 41,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 48 / 41,
        letterSpacing: 0,
      );

  TextStyle get displayLargeRegular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 69,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 76 / 69,
        letterSpacing: 0,
      );

  TextStyle get displayLargeRegular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 51,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 56 / 51,
        letterSpacing: 0,
      );

  TextStyle get displayLargeRegular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 41,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 48 / 41,
        letterSpacing: 0,
      );

  TextStyle get displayLargeLight1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 69,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 76 / 69,
        letterSpacing: 0,
      );

  TextStyle get displayLargeLight576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 51,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 56 / 51,
        letterSpacing: 0,
      );

  TextStyle get displayLargeLight0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 41,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 48 / 41,
        letterSpacing: 0,
      );

  TextStyle get displaySmallHeavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 57,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 64 / 57,
        letterSpacing: 0,
      );

  TextStyle get displaySmallHeavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 44,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 48 / 44,
        letterSpacing: 0,
      );

  TextStyle get displaySmallHeavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 36,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 40 / 36,
        letterSpacing: 0,
      );

  TextStyle get displaySmallRegular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 57,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 64 / 57,
        letterSpacing: 0,
      );

  TextStyle get displaySmallRegular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 44,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 48 / 44,
        letterSpacing: 0,
      );

  TextStyle get displaySmallRegular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 36,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 40 / 36,
        letterSpacing: 0,
      );

  TextStyle get displaySmallLight1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 57,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 64 / 57,
        letterSpacing: 0,
      );

  TextStyle get displaySmallLight576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 44,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 48 / 44,
        letterSpacing: 0,
      );

  TextStyle get displaySmallLight0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 36,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 40 / 36,
        letterSpacing: 0,
      );

  TextStyle get f1Heavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 48,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 52 / 48,
        letterSpacing: 0,
      );

  TextStyle get f1Heavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 38,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 44 / 38,
        letterSpacing: 0,
      );

  TextStyle get f1Heavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 32,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 36 / 32,
        letterSpacing: 0,
      );

  TextStyle get f1Regular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 48,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 52 / 48,
        letterSpacing: 0,
      );

  TextStyle get f1Regular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 38,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 44 / 38,
        letterSpacing: 0,
      );

  TextStyle get f1Regular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 32,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 36 / 32,
        letterSpacing: 0,
      );

  TextStyle get f1Light1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 48,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 52 / 48,
        letterSpacing: 0,
      );

  TextStyle get f1Light576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 38,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 44 / 38,
        letterSpacing: 0,
      );

  TextStyle get f1Light0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 32,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 36 / 32,
        letterSpacing: 0,
      );

  TextStyle get f2Heavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 40,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 44 / 40,
        letterSpacing: 0,
      );

  TextStyle get f2Heavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 33,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 36 / 33,
        letterSpacing: 0,
      );

  TextStyle get f2Heavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 29,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 32 / 29,
        letterSpacing: 0,
      );

  TextStyle get f2Regular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 40,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 44 / 40,
        letterSpacing: 0,
      );

  TextStyle get f2Regular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 33,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 36 / 33,
        letterSpacing: 0,
      );

  TextStyle get f2Regular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 29,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 32 / 29,
        letterSpacing: 0,
      );

  TextStyle get f2Light1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 40,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 44 / 40,
        letterSpacing: 0,
      );

  TextStyle get f2Light576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 33,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 36 / 33,
        letterSpacing: 0,
      );

  TextStyle get f2Light0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 29,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 32 / 29,
        letterSpacing: 0,
      );

  TextStyle get f3Heavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 33,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 36 / 33,
        letterSpacing: 0,
      );

  TextStyle get f3Heavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 28,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 32 / 28,
        letterSpacing: 0,
      );

  TextStyle get f3Heavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 26,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 32 / 26,
        letterSpacing: 0,
      );

  TextStyle get f3Regular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 33,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 36 / 33,
        letterSpacing: 0,
      );

  TextStyle get f3Regular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 28,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 32 / 28,
        letterSpacing: 0,
      );

  TextStyle get f3Regular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 26,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 32 / 26,
        letterSpacing: 0,
      );

  TextStyle get f3Light1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 33,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 36 / 33,
        letterSpacing: 0,
      );

  TextStyle get f3Light576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 28,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 32 / 28,
        letterSpacing: 0,
      );

  TextStyle get f3Light0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 26,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 32 / 26,
        letterSpacing: 0,
      );

  TextStyle get f4Heavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 28,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 32 / 28,
        letterSpacing: 0,
      );

  TextStyle get f4Heavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 24,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 28 / 24,
        letterSpacing: 0,
      );

  TextStyle get f4Heavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 23,
        letterSpacing: 0,
      );

  TextStyle get f4Regular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 28,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 32 / 28,
        letterSpacing: 0,
      );

  TextStyle get f4Regular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 24,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 28 / 24,
        letterSpacing: 0,
      );

  TextStyle get f4Regular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 24 / 23,
        letterSpacing: 0,
      );

  TextStyle get f4Light1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 28,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 32 / 28,
        letterSpacing: 0,
      );

  TextStyle get f4Light576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 24,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 28 / 24,
        letterSpacing: 0,
      );

  TextStyle get f4Light0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 24 / 23,
        letterSpacing: 0,
      );

  TextStyle get f5Heavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 23,
        letterSpacing: 0,
      );

  TextStyle get f5Heavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 21,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 21,
        letterSpacing: 0,
      );

  TextStyle get f5Heavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 20,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 20,
        letterSpacing: 0,
      );

  TextStyle get f5Regular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 24 / 23,
        letterSpacing: 0,
      );

  TextStyle get f5Regular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 21,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 24 / 21,
        letterSpacing: 0,
      );

  TextStyle get f5Regular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 20,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 24 / 20,
        letterSpacing: 0,
      );

  TextStyle get f5Light1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 24 / 23,
        letterSpacing: 0,
      );

  TextStyle get f5Light576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 21,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 24 / 21,
        letterSpacing: 0,
      );

  TextStyle get f5Light0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 20,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 24 / 20,
        letterSpacing: 0,
      );

  TextStyle get f6Heavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 19,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 19,
        letterSpacing: 0,
      );

  TextStyle get f6Heavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 18,
        letterSpacing: 0,
      );

  TextStyle get f6Heavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 18,
        letterSpacing: 0,
      );

  TextStyle get f6Regular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 19,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 19,
        letterSpacing: 0,
      );

  TextStyle get f6Regular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 18,
        letterSpacing: 0,
      );

  TextStyle get f6Regular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 18,
        letterSpacing: 0,
      );

  TextStyle get f6Light1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 19,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 20 / 19,
        letterSpacing: 0,
      );

  TextStyle get f6Light576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 20 / 18,
        letterSpacing: 0,
      );

  TextStyle get f6Light0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 20 / 18,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeHeavy1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 36 / 23,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeHeavy576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 21,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 32 / 21,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeHeavy0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 20,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeRegular1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 36 / 23,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeRegular576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 21,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 32 / 21,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeRegular0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 20,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 28 / 20,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeLight1200 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 23,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 36 / 23,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeLight576 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 21,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 32 / 21,
        letterSpacing: 0,
      );

  TextStyle get paragraphLargeLight0 => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 20,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 28 / 20,
        letterSpacing: 0,
      );

  TextStyle get paragraphBaseHeavy => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        letterSpacing: 0,
      );

  TextStyle get paragraphBaseRegular => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
        letterSpacing: 0,
      );

  TextStyle get paragraphBaseLight => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 24 / 16,
        letterSpacing: 0,
      );

  TextStyle get paragraphSmallHeavy => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 13,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 13,
        letterSpacing: 0,
      );

  TextStyle get paragraphSmallRegular => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 13,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 13,
        letterSpacing: 0,
      );

  TextStyle get paragraphSmallLight => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 13,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 20 / 13,
        letterSpacing: 0,
      );

  TextStyle get paragraphXSmallHeavy => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 11,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 16 / 11,
        letterSpacing: 0,
      );

  TextStyle get paragraphXSmallRegular => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 11,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 16 / 11,
        letterSpacing: 0,
      );

  TextStyle get paragraphXSmallLight => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 11,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 16 / 11,
        letterSpacing: 0,
      );

  TextStyle get paragraphTinyHeavy => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 9,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 12 / 9,
        letterSpacing: 0,
      );

  TextStyle get paragraphTinyRegular => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 9,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 12 / 9,
        letterSpacing: 0,
      );

  TextStyle get paragraphTinyLight => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 9,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 12 / 9,
        letterSpacing: 0,
      );

  TextStyle get smallCapsHeavy => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0.70,
      );

  TextStyle get smallCapsRegular => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 5,
      );

  TextStyle get smallCapsLight => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w300,
        height: 20 / 14,
        letterSpacing: 6,
      );

  TextStyle get actionButtonLarge => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 28 / 18,
        letterSpacing: 0,
      );

  TextStyle get actionButtonMedium => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        letterSpacing: 0,
      );

  TextStyle get actionButtonSmall => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0,
      );

  TextStyle get actionLinkLarge => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 20,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 28 / 20,
        letterSpacing: 0,
      );

  TextStyle get actionLinkMedium => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
        letterSpacing: 0,
      );

  TextStyle get actionLinkSmall => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        letterSpacing: 0,
      );

  TextStyle get docsPageTitle => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 560,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 560 / 560,
        letterSpacing: 2,
      );

  TextStyle get docsSectionTitle => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 160,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 160 / 160,
        letterSpacing: 1,
      );

  TextStyle get docsCategoryTitle => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 54,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 72 / 54,
        letterSpacing: 0,
      );

  TextStyle get docsComponentName => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 24,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 24 / 24,
        letterSpacing: 0,
      );

  TextStyle get docsComponentSubtitle => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 16,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w700,
        height: 28 / 16,
        letterSpacing: 0,
      );

  TextStyle get docsComponentDescription => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 18,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 28 / 18,
        letterSpacing: 0,
      );

  TextStyle get docsComponentSmallDescription => const TextStyle(
        fontFamily: "SourceSansPro",
        fontSize: 14,
        decoration: TextDecoration.none,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
        letterSpacing: 0,
      );
}

class FigmaSizes {
  static const double primaryWidth = 375;
  static const double secondaryWidth = 120;
  static const double primaryHeight = 48;
  static const double secondaryHeight = 36;
}

InputDecoration get inputDecoration => InputDecoration(
    errorStyle: textStyles.paragraphTinyHeavy.copyWith(color: Colors.black),
    hintStyle: Theme.of(navkey.currentContext!)
        .textTheme
        .bodyLarge!
        .copyWith(color: Colors.white.withOpacity(0.5)),
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xffFEEFEF))),
    border: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xffFEEFEF)),
        borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10)),
    disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12));

InputDecoration get invertedInputDecoration => InputDecoration(
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff0000A0))),
    hintStyle: Theme.of(navkey.currentContext!).textTheme.bodyLarge!.copyWith(
        color: Theme.of(navkey.currentContext!)
            .textTheme
            .bodyLarge!
            .color!
            .withOpacity(0.5)),
    errorStyle: textStyles.paragraphTinyHeavy.copyWith(color: Colors.black),
    border: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.neutralNeutral1),
        borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.neutralNeutral1),
        borderRadius: BorderRadius.circular(10)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.neutralNeutral1),
        borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.neutralNeutral1),
        borderRadius: BorderRadius.circular(10)),
    disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.neutralNeutral1),
        borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12));
InputDecoration get outlineInputDecoration => InputDecoration(
    errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xff0000A0))),
    border: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.primaryPrimary90),
        borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.primaryPrimary90),
        borderRadius: BorderRadius.circular(10)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.primaryPrimary90),
        borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.primaryPrimary90),
        borderRadius: BorderRadius.circular(10)),
    disabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: FigmaColors.primaryPrimary90),
        borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12));

var lightTheme = ThemeData(
        fontFamily: const TextStyle(
  fontFamily: "SourceSansPro",
).fontFamily)
    .copyWith(
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  textSelectionTheme: const TextSelectionThemeData(
    cursorColor: Colors.white,
  ),
  popupMenuTheme: const PopupMenuThemeData(
    color: Colors.white,
    surfaceTintColor: Colors.white,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: FigmaColors.primaryPrimary100,
  ),
  scaffoldBackgroundColor: const Color(0xffF4F6F9),
  primaryColor: FigmaColors.primaryPrimary100,
  iconTheme: const IconThemeData(
    color: FigmaColors.neutralWhite,
  ),
  dialogTheme: const DialogTheme()
      .copyWith(backgroundColor: Colors.white, surfaceTintColor: Colors.white),
  inputDecorationTheme: const InputDecorationTheme().copyWith(
      errorStyle: textStyles.paragraphTinyHeavy.copyWith(color: Colors.white),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xff0000A0))),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white))),
  textTheme: const TextTheme()
      .copyWith(
        titleLarge:
            textStyles.f6Heavy0.copyWith(color: FigmaColors.neutralNeutral2),

        titleMedium: textStyles.smallCapsHeavy
            .copyWith(color: FigmaColors.neutralNeutral2),

        labelLarge: textStyles.actionButtonLarge
            .copyWith(color: FigmaColors.neutralWhite),
        labelSmall: textStyles.actionButtonSmall,
        labelMedium: textStyles.actionButtonMedium
            .copyWith(color: FigmaColors.neutralWhite),

        /// headline
        headlineLarge:
            textStyles.f3Heavy1200.copyWith(color: FigmaColors.neutralWhite),
        headlineMedium:
            textStyles.f5Heavy1200.copyWith(color: FigmaColors.neutralBlack),
        headlineSmall: textStyles.paragraphBaseRegular
            .copyWith(color: FigmaColors.neutralNeutral2),

        /// body
        bodyLarge: textStyles.paragraphBaseHeavy
            .copyWith(color: FigmaColors.neutralNeutral1),
        bodyMedium: textStyles.paragraphSmallRegular
            .copyWith(color: FigmaColors.neutralNeutral2),
        bodySmall: textStyles.paragraphTinyHeavy
            .copyWith(color: FigmaColors.neutralNeutral1),
      )
      .apply(fontFamily: "SourceSansPro"),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(
        error: FigmaColors.statusError,
        secondary: FigmaColors.secondarySecondary100,
      )
      .copyWith(surface: const Color(0xffF4F6F9)),
);
