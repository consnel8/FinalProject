import 'dart:math';
import 'package:flutter/material.dart';

class GlitteringIcon extends StatefulWidget {
  final IconData icon;
  final double size;
  final double cardHeight;  // Height of the card
  final double cardWidth;   // Width of the card

  GlitteringIcon({
    required this.icon,
    required this.size,
    required this.cardHeight,
    required this.cardWidth,
  });

  @override
  _GlitteringIconState createState() => _GlitteringIconState();
}

class _GlitteringIconState extends State<GlitteringIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;
  late double _screenHeight;
  late double _screenWidth;

  @override
  void initState() {
    super.initState();
    _stars = [];
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 3))..repeat();

    // Set the height and width of the screen (or card)
    _screenHeight = widget.cardHeight;
    _screenWidth = widget.cardWidth;

    // Create random stars that will fall from the top to the bottom
    _generateStars();
  }

  // Generate a random number of stars and their positions
  void _generateStars() {
    for (int i = 0; i < 10; i++) {
      double x = (widget.cardWidth * (i + 1)) / 10;  // Spread across the width
      double size = (i % 2 == 0) ? 10.0 : 20.0; // Alternate between small and medium stars
      _stars.add(Star(x: x, size: size));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Main icon in the center
            Center(
              child: Icon(
                widget.icon,
                size: widget.size,
                color: Colors.yellow,
              ),
            ),
            // Falling stars
            ..._stars.map((star) {
              double fallPosition = (_controller.value * _screenHeight);
              return Positioned(
                top: -fallPosition,  // Start from above the card
                left: star.x,
                child: Container(
                  width: star.size,
                  height: star.size,
                  child: Icon(
                    widget.icon,
                    color: Colors.yellow.withOpacity(0.5),
                    size: star.size,
                  ),
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }
}

class Star {
  final double x;
  final double size;

  Star({required this.x, required this.size});
}
