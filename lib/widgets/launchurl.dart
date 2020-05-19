import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(LinkableElement link) async {
  print("launching URL $link");

  if (await canLaunch(link.url)) {
    await launch(link.url);
  } else {
    throw 'Could not launch $link';
  }
}

class TextWithLinks extends StatelessWidget {
  const TextWithLinks(this.text, {
    Key key,
    this.style, this.linkStyle,
  }) : super(key: key);

  final String text;
  final TextStyle style;
  final TextStyle linkStyle;

  @override
  Widget build(BuildContext context) {
    return Linkify(onOpen: (link) => launchURL(link), text: text, style: style, linkStyle: linkStyle,);
  }
}
