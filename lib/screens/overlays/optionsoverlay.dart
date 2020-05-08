import 'package:flutter/material.dart';
import './shaderoverlay.dart';

/// Overlay screen when successful submission (incl. buttons to navigate next)
///
/// To be used in [Stack]; uses [ShaderOverlay] as a base widget
class OptionsOverlay extends StatelessWidget {
  const OptionsOverlay({
    Key key,
    this.levelInfoText,
    this.showBackground,
    this.onBackToLevel,
    this.onBack,
    this.onRestartLevel,
    this.onDecreaseLevel,
    this.onSwitchBackgroundImage,
    this.canDecreaseLevel = true,
    this.canIncreaseLevel = true,
  }) : super(key: key);

  /// Callback when getting back from this options overlay
  final VoidCallback onBackToLevel;
  /// Callback when getting out of the taskscreen back "parent" screen
  final VoidCallback onBack;
  /// Callback to clean and de facto restart the task screen
  final VoidCallback onRestartLevel;
  /// Callback to restart with lower level
  final VoidCallback onDecreaseLevel;
  /// Callback when background button was touched
  final VoidCallback onSwitchBackgroundImage;

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
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: onBackToLevel,
                child: Image.asset(
                  "assets/ada_full_body.png",
                  width: 100,
                ),
              ),
              Container(width: 16),
              Expanded(
                  child: Container(
                    child: Text(
                      "JSI NA ÚROVNI $levelInfoText.\n\nCO PRO TEBE MŮŽU UDĚLAT?",
                    ),
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  )),
            ],
          ),
          Container(height: 0),
          RaisedButton.icon(
            autofocus: true,
            label: Text("NIC, CHCI ZPĚT"),
            icon: Icon(Icons.arrow_back_ios),
            shape: StadiumBorder(),
            onPressed: onBackToLevel,
          ),
          showBackground
              ? RaisedButton.icon(
            autofocus: true,
            label: Text("VYPNOUT OBRÁZEK"),
            icon: Icon(Icons.image),
            shape: StadiumBorder(),
            onPressed: onSwitchBackgroundImage,
          )
              : RaisedButton.icon(
            autofocus: true,
            label: Text("UKAZOVAT OBRÁZEK"),
            icon: Icon(Icons.add_photo_alternate),
            shape: StadiumBorder(),
            onPressed: onSwitchBackgroundImage,
          ),
          RaisedButton.icon(
            autofocus: true,
            label: Text("VYČISTIT A ZAČÍT ZNOVU"),
            icon: Icon(Icons.refresh),
            shape: StadiumBorder(),
            onPressed: onRestartLevel,
          ),

          /// show only if we can decrease level
          canDecreaseLevel
              ? RaisedButton.icon(
            label: Text("TO JE MOC TĚŽKÉ, CHCI LEHČÍ"),
            icon: Icon(Icons.file_download),
            shape: StadiumBorder(),
            onPressed: onDecreaseLevel,
          )
              : Container(),
          RaisedButton.icon(
            label: Text("ZPĚT NA VÝBĚR TŘÍDY"),
            icon: Icon(Icons.assignment),
            shape: StadiumBorder(),
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}
