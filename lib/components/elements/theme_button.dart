import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_manager.dart';
import '../../theme_values.dart';

class ThemeButton extends StatelessWidget {
  final Color color;
  final AppTheme theme;

  const ThemeButton({Key? key, required this.color, required this.theme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeManager>(context);

    return Container(
      width: 30.0,
      height: 30.0,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(
          color: Colors.white,
          width: 2.5,
        ),
      ),
      child: TextButton(
        onPressed: () {
          themeNotifier.setTheme(theme);
          Navigator.pop(context);
        },
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) =>
              ScaleTransition(
            child: child,
            scale: animation,
          ),
          child: _getIcon(themeNotifier),
        ),
      ),
    );
  }

  Widget _getIcon(ThemeManager themeNotifier) {
    bool selected = (themeNotifier.themeData == appThemeData[theme]);

    return Container(
      key: Key((selected) ? "ON" : "OFF"),
      child: Icon(
        (selected) ? Icons.check : null,
        color: Colors.white,
        size: 10.0,
      ),
    );
  }
}
