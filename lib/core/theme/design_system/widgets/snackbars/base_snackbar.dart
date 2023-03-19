import 'package:flutter/material.dart';

import '../../../../helpers/snackbar_helper.dart';

class BaseSnackbar extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final Color progressBarColor;
  final Color textColor;
  final IconData icon;
  final Duration duration;

  const BaseSnackbar({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.progressBarColor,
    required this.textColor,
    required this.icon,
    required this.duration,
  });

  @override
  State<BaseSnackbar> createState() => _BaseSnackbarState();
}

class _BaseSnackbarState extends State<BaseSnackbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _stopTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration + const Duration(milliseconds: 400),
    );
    _stopTween = Tween<double>(begin: 1, end: 0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  double get _maxRowWidth {
    const iconWidth = 24.0;
    const iconSpacing = 8.0;
    final textStyle = TextStyle(color: widget.textColor);
    final textSpan = TextSpan(text: widget.message, style: textStyle);
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr)..layout();
    final textWidth = textPainter.width;
    final rowWidth = iconWidth + iconSpacing + textWidth;
    return rowWidth;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: GestureDetector(
        onTap: context.hideSnackbar,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(6),
            ),
            margin: const EdgeInsets.all(8),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(widget.icon, color: widget.textColor),
                      const SizedBox(width: 8),
                      Text(
                        widget.message,
                        style: TextStyle(
                          color: widget.textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => Container(
                    width: _maxRowWidth,
                    height: 5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        stops: [_stopTween.value, _stopTween.value],
                        colors: [
                          widget.progressBarColor,
                          widget.backgroundColor
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                    ),
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
