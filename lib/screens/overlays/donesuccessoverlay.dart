import 'package:flutter/material.dart';
import './shaderoverlay.dart';

/// Overlay screen when successful submission (incl. buttons to navigate next)
class DoneSuccessOverlay extends StatelessWidget {
  const DoneSuccessOverlay(
      {Key? key, this.onNextUpLevel, this.onNextSameLevel, this.onBack})
      : super(key: key);

  final VoidCallback? onNextUpLevel;
  final VoidCallback? onNextSameLevel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return ShaderOverlay(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/ada_full_body_correct.png",
                width: 120,
              ),
              Container(width: 16),
              Expanded(
                  child: Container(
                    child: Text(
                      "VÝBORNĚ!\n\nTak a můžeš pokračovat.",
                      softWrap: true,
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
//          Container(height: 20,),
          RaisedButton.icon(
            label: Text("ZKUSIT TĚŽŠÍ"),
            icon: Icon(Icons.landscape),
            shape: StadiumBorder(),
            onPressed: onNextUpLevel,
          ),
          RaisedButton.icon(
            label: Text("JEŠTĚ STEJNĚ TĚŽKOU"),
            icon: Icon(Icons.compare_arrows),
            shape: StadiumBorder(),
            onPressed: onNextSameLevel,
          ),
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
