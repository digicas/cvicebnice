// ignore_for_file: prefer_const_constructors

/// Generated file with git commit info
/// run ./tools/git_commit_info.bat if missing and after each commit
/// Hopefully can be automated in the builder - see git_revision branch
import 'package:cvicebnice/git_info.g.dart' as git_info;
import 'package:cvicebnice/widgets/launch_url.dart';
import 'package:flutter/material.dart';

/// About Dialog
void buildAboutDialog(BuildContext context) {
  return showAboutDialog(
    context: context,
    applicationName: 'Matika do kapsy',
    applicationVersion: git_info.shortSHA,
    // TODO(KeepItSaber): add app icon
    applicationLegalese:
        '''Vytvořeno v rámci neziskového projektu EduKids spolkem Kvalitní digičas, z.s. s pomocí přispěvovatelů.''',
    children: [
      const SizedBox(height: 8),
      const Text(
        '''Chceme posilovat vzdělání dětí účinným využitím mobilů a minimalizovat tak digitální konzum.''',
//                  style: TextStyle(fontSize: 12),
      ),
      const SizedBox(height: 12),
      TextWithLinks(
        'web: https://www.edukids.cz\n\n'
        '(f) https://www.facebook.com/EduKids.cz',
        key: Key('Facebook'),
      ),
      const SizedBox(height: 12),
      TextWithLinks(
        'Budeme rádi, když nám pomůžete - https://www.edukids.cz/podporte-nas',
        key: Key('Support'),
      ),
    ],
  );
}
