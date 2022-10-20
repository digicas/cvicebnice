import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(LinkableElement link) async {
  log('launching URL $link');

  if (await canLaunchUrl(Uri.parse(link.url))) {
    await launchUrl(Uri.parse(link.url));
  } else {
    log('Could not launch $link');
  }
}

class TextWithLinks extends StatelessWidget {
  const TextWithLinks(
    this.text, {
    super.key,
    this.style,
    this.linkStyle,
  });

  final String text;
  final TextStyle? style;
  final TextStyle? linkStyle;

  @override
  Widget build(BuildContext context) {
    return Linkify(
      onOpen: launchURL,
      text: text,
      style: style,
      linkStyle: linkStyle,
    );
  }
}
