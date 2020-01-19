import 'package:flutter_linkify/flutter_linkify.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:html' as html; // cannot be used in Flutter :(


Future<void> launchURL(LinkableElement link) async {
  print("launching URL $link");

//  TODO if on web
//  import 'dart:html' as html';
//  html.window.open(url,name);

  if (await canLaunch(link.url)) {
    await launch(link.url);
  } else {
    throw 'Could not launch $link';
  }
}
