import 'package:cvicebnice/keyboard/keyboard_controller.dart';
import 'package:flutter/material.dart';

class SoftwareKeyboard<T> extends StatelessWidget {
  const SoftwareKeyboard({
    super.key,
    required this.onValuesChanged,
    this.focusedValueIndex,
    required this.controller,
  });
  final KeyboardController<T> controller;
  final void Function(List<T?>) onValuesChanged;
  final int? focusedValueIndex;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: DefaultTextStyle(
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Color(0xffa02b5f),
          fontSize: 18,
        ),
        child: Center(
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xffECE6E9),
            child: GridView.count(
              childAspectRatio: (MediaQuery.of(context).size.width / 11) / 48,
              crossAxisSpacing: 2,
              padding: const EdgeInsets.symmetric(horizontal: 2),
              crossAxisCount: 11,
              children: <Widget>[
                ...List.generate(10, (int i) {
                  final value = i == 9 ? 0 : i + 1;
                  return InkWell(
                    onTap: () {
                      if (focusedValueIndex == null) return;
                      controller.changeValueAt(focusedValueIndex!, value as T);
                      onValuesChanged(controller.values);
                    },
                    child: KeyboardButton(
                      label: '$value',
                    ),
                  );
                }),
                InkWell(
                  onTap: () {
                    if (focusedValueIndex == null) return;
                    controller.onDelete(
                      focusedValueIndex!,
                    );
                    onValuesChanged(controller.values);
                  },
                  child: const KeyboardButton(
                    label: 'X',
                    iconData: Icons.backspace_outlined,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardButton extends StatelessWidget {
  const KeyboardButton({
    super.key,
    required this.label,
    this.value,
    this.iconData,
  });

  final String label;
  final String? value;
  final IconData? iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.white70,
      ),
      child: Center(
        child: iconData == null
            ? Text(label)
            : Icon(
                iconData,
                size: 18,
                color: const Color(
                  0xff415a70,
                ),
              ),
      ),
    );
  }
}
