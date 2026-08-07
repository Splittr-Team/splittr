import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sky_design_system/sky_design_system.dart';
import 'package:splittr/utils/extensions/extensions.dart';

class GroupActionsFab extends StatefulWidget {
  const GroupActionsFab({
    required this.onCreateTapped,
    required this.onJoinTapped,
    super.key,
  });

  final VoidCallback onCreateTapped;
  final VoidCallback onJoinTapped;

  @override
  State<GroupActionsFab> createState() => _GroupActionsFabState();
}

class _GroupActionsFabState extends State<GroupActionsFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      value: 0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.easeOutBack,
      reverseCurve: Curves.easeIn,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isOpen = !_isOpen;
      if (_isOpen) {
        unawaited(_controller.forward());
      } else {
        unawaited(_controller.reverse());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _ActionItem(
          animation: _expandAnimation,
          icon: Icons.login_rounded,
          label: context.strings.joinGroup,
          onPressed: () {
            _toggle();
            widget.onJoinTapped();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        _ActionItem(
          animation: _expandAnimation,
          label: context.strings.createGroup,
          icon: Icons.group_add_rounded,
          onPressed: () {
            _toggle();
            widget.onCreateTapped();
          },
        ),
        const SizedBox(height: AppSpacing.md),
        FloatingActionButton(
          onPressed: _toggle,
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: _expandAnimation,
          ),
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.animation,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Animation<double> animation;
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: animation,
      child: FadeTransition(
        opacity: animation,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Material(
              color: context.colorScheme.surfaceContainerHigh,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + AppSpacing.xs,
                  vertical: AppSpacing.sm,
                ),
                child: AppText.labelLarge(
                  label,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm + AppSpacing.xs),
            FloatingActionButton.small(
              heroTag: label,
              onPressed: onPressed,
              backgroundColor: context.colorScheme.primaryContainer,
              child: AppIcon.md(icon),
            ),
          ],
        ),
      ),
    );
  }
}
