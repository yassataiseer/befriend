import 'package:befriend/views/widgets/bubble_widget.dart';
import 'package:flutter/material.dart';

import '../../models/bubble.dart';
import '../../utilities/gradient_painter.dart';

class BubbleProgressIndicator extends StatelessWidget {
  const BubbleProgressIndicator({
    super.key,
    required this.friendship,
  });

  final Friendship friendship;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CircularProgressIndicator(
        value: friendship.progress / 100,
        strokeWidth: BubbleWidget.strokeWidth,
        valueColor: const AlwaysStoppedAnimation<Color>(
            Colors.transparent),
      ),
    );
  }
}

class BubbleGradientIndicator extends StatelessWidget {
  const BubbleGradientIndicator({
    super.key,
    required this.friendship,
  });

  final Friendship friendship;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: CustomPaint(
        painter: GradientPainter(
          gradient: friendship.friendBubble.gradient,
          progress: friendship.progress / 100,
          strokeWidth: BubbleWidget.strokeWidth,
        ),
      ),
    );
  }
}