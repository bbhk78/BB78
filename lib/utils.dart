import 'dart:collection';
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// Modified from source: https://stackoverflow.com/a/61867272
extension DateTimeHelper on DateTime {
  bool isToday() {
    final DateTime now = DateTime.now();
    return now.day == day && now.month == month && now.year == year;
  }

  static DateTime today() {
    final DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  String formatted(String format) => DateFormat(format).format(this);
}

// Source: https://stackoverflow.com/a/65314708
extension RangeExtension on int {
  List<int> to(int maxInclusive, {int step = 1}) =>
      <int>[for (int i = this; i <= maxInclusive; i += step) i];
}

class MathReducers {
  static int sum(int accumulator, int element) => accumulator + element;
}

class LocaleBundle extends Equatable {
  final String lang;
  final Locale locale;
  final Map<String, String> trMap;

  const LocaleBundle(
      {required this.lang, required this.locale, required this.trMap});

  @override
  List<Object> get props => <Object>[lang, locale];
}

class GuiUtils {
  static PreferredSize simpleAppBar(
          {String title = '',
          String subtitle = '',
          bool showBackButton = false}) =>
      PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(top: 60, left: 40),
            child: Row(
              children: <Widget>[
                if (showBackButton)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back<void>(),
                    iconSize: 30,
                    padding: const EdgeInsets.only(right: 25),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title,
                        style: const TextStyle(
                            fontSize: 25,
                            fontFamily: 'OpenSans SemiBold',
                            color: Colors.black)),
                    if (subtitle.isNotEmpty)
                      Text(subtitle,
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: 'OpenSans SemiBold',
                              color: Colors.black)),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  // NOTE: Meant to be used with Get.dialog
  static Widget loaderDialogContent([String loaderText = 'Loading...']) =>
      AlertDialog(
        content: Row(children: <Widget>[
          const CircularProgressIndicator(),
          Container(
              margin: const EdgeInsets.only(left: 8), child: Text(loaderText)),
        ]),
      );
}

class FutureUtils {
  static Future<void> waitFor(bool Function() func, Duration duration) async {
    while (!func()) await Future<void>.delayed(duration);
  }

  static Future<void> waitForAsync(
      Future<bool> Function() func, Duration duration) async {
    while (!(await func())) await Future<void>.delayed(duration);
  }
}

class TypeUtils {
  static List<T> parseList<T>(dynamic possibleList) =>
      (possibleList as List<dynamic>).cast<T>();

  static Map<K, V> parseMap<K, V>(dynamic possibleMap) =>
      (possibleMap as Map<dynamic, dynamic>).cast<K, V>();

  static HashMap<K, V> parseHashMap<K, V>(dynamic possibleMap) =>
      HashMap<K, V>.from(TypeUtils.parseMap<K, V>(possibleMap));
}

// Copied & modified from "auto_id_generator.dart" from Firestore SDK
class FirebaseAutoIdGenerator {
  static const int _AUTO_ID_LENGTH = 20;
  static const String _AUTO_ID_ALPHABET =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  static final Random _random = Random();

  /// Automatically Generates a random new Id
  static String autoId() {
    final StringBuffer stringBuffer = StringBuffer();
    const int maxRandom = _AUTO_ID_ALPHABET.length;

    for (int i = 0; i < _AUTO_ID_LENGTH; ++i)
      stringBuffer.write(_AUTO_ID_ALPHABET[_random.nextInt(maxRandom)]);

    return stringBuffer.toString();
  }
}
