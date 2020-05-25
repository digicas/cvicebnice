import 'package:cvicebnice/widgets/launchurl.dart';
import 'package:flutter/material.dart';

/// Generated file with git commit info
/// run ./tools/git_commit_info.bat if missing and after each commit
/// Hopefully can be automated in the builder - see git_revision branch
import 'package:cvicebnice/git_info.g.dart' as gitInfo;


/// About Dialog
void buildShowAboutDialog(BuildContext context) {
  return showAboutDialog(
    context: context,
    applicationName: "Matika do kapsy",
    applicationVersion: gitInfo.shortSHA,
    applicationIcon: null,
    // TODO add app icon
    applicationLegalese:
    "Vytvořeno v rámci neziskového projektu EduKids spolkem Kvalitní digičas, z.s. s pomocí přispěvovatelů.",
    children: [
      SizedBox(height: 8),
      Text(
        "Chceme posilovat vzdělání dětí účinným využitím mobilů a minimalizovat tak digitální konzum.",
//                  style: TextStyle(fontSize: 12),
      ),
      SizedBox(height: 12),
      TextWithLinks("web: https://www.edukids.cz\n\n"
          "(f) https://www.facebook.com/EduKids.cz"),
      SizedBox(height: 12),
      TextWithLinks(
          "Budeme rádi, když nám pomůžete - https://www.edukids.cz/podporte-nas"),
    ],
  );
}
