import 'dart:async';

import 'package:flutter/material.dart';

class AnimatedBranchContainer extends StatefulWidget {
  const AnimatedBranchContainer({
    required this.currentIndex,
    required this.children,
    super.key,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<AnimatedBranchContainer> createState() =>
      _AnimatedBranchContainerState();
}

class _AnimatedBranchContainerState extends State<AnimatedBranchContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late int _currentIndex;
  late int _previousIndex;
  bool _isTransitioning = false;
  bool _movingForward = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _previousIndex = widget.currentIndex;
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 250),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            setState(() {
              _isTransitioning = false;
              _previousIndex = _currentIndex;
            });
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AnimatedBranchContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      setState(() {
        _previousIndex = oldWidget.currentIndex;
        _currentIndex = widget.currentIndex;
        _movingForward = _currentIndex > _previousIndex;
        _isTransitioning = true;
      });
      unawaited(_controller.forward(from: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final beginOffset = _movingForward
        ? const Offset(1, 0)
        : const Offset(-1, 0);

    final enteringAnimation =
        Tween<Offset>(
          begin: beginOffset,
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
        );

    final leavingAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: -beginOffset,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutBack,
          ),
        );

    return Stack(
      children: List.generate(widget.children.length, (index) {
        final isCurrent = index == _currentIndex;
        final isPrevious = index == _previousIndex;

        if (_isTransitioning) {
          if (isCurrent) {
            return SlideTransition(
              position: enteringAnimation,
              child: TickerMode(
                enabled: true,
                child: widget.children[index],
              ),
            );
          } else if (isPrevious) {
            return SlideTransition(
              position: leavingAnimation,
              child: TickerMode(
                enabled: false,
                child: IgnorePointer(
                  child: widget.children[index],
                ),
              ),
            );
          } else {
            return Offstage(
              child: TickerMode(
                enabled: false,
                child: widget.children[index],
              ),
            );
          }
        } else {
          return Offstage(
            offstage: !isCurrent,
            child: TickerMode(
              enabled: isCurrent,
              child: widget.children[index],
            ),
          );
        }
      }),
    );
  }
}
