import 'package:flutter/material.dart';
import 'package:pyramids_funnels/models/cell_type.dart';
import 'package:software_keyboard/cursor.dart';

class Cell extends StatelessWidget {
  const Cell({
    super.key,
    required this.value,
    this.masked = false,
    required this.hint,
    this.cellType = CellType.box,
    this.onSelected,
    this.isFocused = false,
  });
  final int? value;
  final bool masked;
  final bool hint;
  final CellType cellType;
  final VoidCallback? onSelected;
  final bool isFocused;

  @override
  Widget build(BuildContext context) {
    /// widgets for Funnel's bubble
    if (cellType == CellType.bubble) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: !masked ? const Color(0xff9C4D82) : const Color(0xffeeeeee),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(
              color: isFocused ? const Color(0xff9C4D82) : Colors.transparent,
              width: 4,
            ),
            boxShadow: !masked
                ? []
                : const [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: Offset(4, 4),
                    ),
                  ],
          ),
          child: Center(
            child: !masked
                ? Text(
                    '$value',
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    style: const TextStyle(
                      color: Color(0xffeeeeee),
                      fontSize: 22,
                    ),
                  )
                : GestureDetector(
                    onTap: onSelected,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            value != null ? '$value' : '',
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                          ),
                          if (isFocused)
                            const BlinkingCursor(
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      );
    }

    /// basic rendering - Boxes for Pyramid
    return Padding(
      padding: const EdgeInsets.all(2),
      child: Container(
        width: 64,
        height: 40,
        decoration: BoxDecoration(
          color: masked ? Colors.grey[200] : Colors.grey[400],
          border: Border.all(
            width: isFocused ? 2 : 1,
            color: isFocused ? const Color(0xff9C4D82) : Colors.black,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: !masked
              ? []
              : const [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(4, 4),
                  ),
                ],
        ),
        child: Center(
          child: !masked
              ? Text(
                  '$value',
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                )
              : GestureDetector(
                  onTap: onSelected,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value != null ? '$value' : '',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                          ),
                        ),
                        if (isFocused)
                          const BlinkingCursor(
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
