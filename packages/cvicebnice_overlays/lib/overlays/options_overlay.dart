import 'package:cvicebnice_overlays/overlays/shader_overlay.dart';
import 'package:cvicebnice_overlays/utils.dart';
import 'package:flutter/material.dart';

/// Overlay screen when successful submission (incl. buttons to navigate next)
///
/// To be used in [Stack]; uses [ShaderOverlay] as a base widget
class OptionsOverlay extends StatelessWidget {
  const OptionsOverlay({
    super.key,
    required this.levelInfoText,
    required this.showBackground,
    this.onBackToLevel,
    this.onBack,
    this.onRestartLevel,
    this.onDecreaseLevel,
    this.onSwitchBackgroundImage,
    this.canDecreaseLevel = true,
    this.canIncreaseLevel = true,
  });

  /// Callback when getting back from this options overlay
  final VoidCallback? onBackToLevel;

  /// Callback when getting out of the taskscreen back "parent" screen
  final VoidCallback? onBack;

  /// Callback to clean and de facto restart the task screen
  final VoidCallback? onRestartLevel;

  /// Callback to restart with lower level
  final VoidCallback? onDecreaseLevel;

  /// Callback when background button was touched
  final VoidCallback? onSwitchBackgroundImage;

  /// text (typically number) to show
  final String levelInfoText;

  /// Visibility for image in background
  final bool showBackground;

  /// Whether to show button to decrease level
  final bool canDecreaseLevel;

  /// Whether to show button to increase level
  final bool canIncreaseLevel;

  @override
  Widget build(BuildContext context) {
//    removeEditableFocus(context);

    return ShaderOverlay(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: onBackToLevel,
                child: Image.asset(
                  'assets/ada_full_body.png',
                  width: 100,
                ),
              ),
              Container(width: 16),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    'JSI NA ÚROVNI $levelInfoText.\n\nCO PRO TEBE MŮŽU UDĚLAT?',
                  ),
                ),
              ),
            ],
          ),
          Container(height: 0),
          ElevatedButton.icon(
            autofocus: true,
            label: const Text('NIC, CHCI ZPĚT'),
            icon: const Icon(Icons.arrow_back_ios),
            style: stadiumButtonStyle,
            onPressed: onBackToLevel,
          ),
          if (showBackground)
            ElevatedButton.icon(
              autofocus: true,
              label: const Text('VYPNOUT OBRÁZEK'),
              icon: const Icon(Icons.image),
              style: stadiumButtonStyle,
              onPressed: onSwitchBackgroundImage,
            )
          else
            ElevatedButton.icon(
              autofocus: true,
              label: const Text('UKAZOVAT OBRÁZEK'),
              icon: const Icon(Icons.add_photo_alternate),
              style: stadiumButtonStyle,
              onPressed: onSwitchBackgroundImage,
            ),
          ElevatedButton.icon(
            autofocus: true,
            label: const Text('VYČISTIT A ZAČÍT ZNOVU'),
            icon: const Icon(Icons.refresh),
            style: stadiumButtonStyle,
            onPressed: onRestartLevel,
          ),

          /// show only if we can decrease level
          if (canDecreaseLevel)
            ElevatedButton.icon(
              label: const Text('MOC TĚŽKÉ, CHCI LEHČÍ'),
              icon: const Icon(Icons.file_download),
              style: stadiumButtonStyle,
              onPressed: onDecreaseLevel,
            ),
          ElevatedButton.icon(
            label: const Text('ZPĚT NA HLAVNÍ VÝBĚR'),
            icon: const Icon(Icons.assignment),
            style: stadiumButtonStyle,
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}
