import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_floaty/flutter_floaty.dart';

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
      onDragBackgroundColor: colorScheme.primary.withOpacity(0.3),
      onDragStart: onDragStart,
      onDragUpdate: onDragUpdate,
      onDragEnd: onDragEnd,
      borderRadius: 25,
      growingFactor: 1.0,
    );
  }
} 