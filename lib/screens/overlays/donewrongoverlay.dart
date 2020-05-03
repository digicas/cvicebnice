import 'package:flutter/material.dart';
import './shaderoverlay.dart';

class DoneWrongOverlay extends StatelessWidget {
  const DoneWrongOverlay({Key key, this.onBackToLevel}) : super(key: key);

  final VoidCallback onBackToLevel;

  @override
  Widget build(BuildContext context) {
    return ShaderOverlay(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                "assets/ada_full_body_wrong.png",
                width: 100,
              ),
              Container(width: 16),
              Expanded(
                  child: Container(
                    child: Text(
                      "AJAJAJAJ!",
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
          RaisedButton.icon(
            autofocus: true,
            label: Text("ZKUS TO OPRAVIT"),
            icon: Icon(Icons.repeat),
            shape: StadiumBorder(),
            onPressed: onBackToLevel,
          ),
          Container(height: 20),
        ],
      ),
    );
  }
}
