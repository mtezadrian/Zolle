import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Map {

  Map._();

  static Future<void> openMap() async {
    String googleUrl =
        'https://www.google.com/maps/search/Punto+Limpio';
    String appleUrl =
        'http://maps.apple.com/?q=Punto+Limpio&dirflg=d&t=h';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
    }
  }
}

