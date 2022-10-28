import 'package:cvicebnice_overlays/overlays/shader_overlay.dart';
import 'package:cvicebnice_overlays/utils.dart';

import 'package:flutter/material.dart';

/// Overlay screen when successful submission (incl. buttons to navigate next)
class DoneSuccessOverlay extends StatelessWidget {
  const DoneSuccessOverlay({
    super.key,
    this.onNextUpLevel,
    this.onNextSameLevel,
    this.onBack,
  });

  final VoidCallback? onNextUpLevel;
  final VoidCallback? onNextSameLevel;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return ShaderOverlay(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.asset(
                'assets/ada_full_body_correct.png',
                width: 120,
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
                  child: const Text(
                    'VÝBORNĚ!\n\nTak a můžeš pokračovat.',
                    softWrap: true,
                  ),
                ),
              ),
            ],
          ),
//          Container(height: 20,),
          ElevatedButton.icon(
            label: const Text('ZKUSIT TĚŽŠÍ'),
            icon: const Icon(Icons.landscape),
            style: stadiumButtonStyle,
            onPressed: onNextUpLevel,
          ),
          ElevatedButton.icon(
            label: const Text('JEŠTĚ STEJNĚ TĚŽKOU'),
            icon: const Icon(Icons.compare_arrows),
            style: stadiumButtonStyle,
            onPressed: onNextSameLevel,
          ),
          ElevatedButton.icon(
            label: const Text('ZPĚT NA VÝBĚR TŘÍDY'),
            icon: const Icon(Icons.assignment),
            style: stadiumButtonStyle,
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}
