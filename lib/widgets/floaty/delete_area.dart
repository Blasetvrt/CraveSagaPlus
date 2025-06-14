import 'package:flutter/material.dart';

class DeleteArea extends StatelessWidget {
  final double scale;
  final double padding;
  final Color iconColor;

  const DeleteArea({
    super.key,
    required this.scale,
    required this.padding,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: scale,
        child: Container(
          height: 110,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.bottomCenter,
              radius: 1.0,
              colors: [
                Colors.red,
                Colors.red.withOpacity(0.0),
              ],
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.only(bottom: padding),
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(color: iconColor),
                child: Icon(
                  Icons.delete_outline,
                  color: iconColor,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
} 