import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_floaty/flutter_floaty.dart';

// Main floaty component
class FloatyButton extends StatelessWidget {
  final ColorScheme colorScheme;
  final Rect boundaries;
  final double buttonSize;
  final double initialX;
  final double initialY;
  final VoidCallback onMenuTap;
  final Function(DragStartDetails) onDragStart;
  final Function(DragUpdateDetails) onDragUpdate;
  final Function(DragEndDetails) onDragEnd;

  const FloatyButton({
    super.key,
    required this.colorScheme,
    required this.boundaries,
    required this.buttonSize,
    required this.initialX,
    required this.initialY,
    required this.onMenuTap,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterFloaty(
      intrinsicBoundaries: boundaries,
      width: buttonSize,
      height: buttonSize,
      initialX: initialX,
      initialY: initialY,
      builder: (context) => Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onMenuTap,
          child: SvgPicture.asset(
            'assets/csplus.svg',
            colorFilter: ColorFilter.mode(
              colorScheme.onSecondary,
              BlendMode.srcIn,
            ),
            width: 70,
            height: 70,
          ),
        ),
      ),
      shadow: const BoxShadow(
        color: Colors.black26,
        blurRadius: 10,
        offset: Offset(0, 2),
      ),
      backgroundColor: colorScheme.primary,
      onDragBackgroundColor: colorScheme.primary.withValues(alpha: 0.3),
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      borderRadius: 25,
      growingFactor: 1.0,
    );
  }
} 

// Delete area for floaty
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
                Colors.red.withAlpha(0),
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