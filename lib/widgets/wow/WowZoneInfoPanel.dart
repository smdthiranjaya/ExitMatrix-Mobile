import 'package:exitmatrix/core/constants/constants.dart';
import 'package:flutter/material.dart';

class WowZoneInfoPanel extends StatefulWidget {
  final String zoneName;
  final String subZone;
  final String level;

  const WowZoneInfoPanel({
    Key? key,
    required this.zoneName,
    required this.subZone,
    required this.level,
  }) : super(key: key);

  @override
  State<WowZoneInfoPanel> createState() => _WowZoneInfoPanelState();
}

class _WowZoneInfoPanelState extends State<WowZoneInfoPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: MapThemeColors.background.withOpacity(0.9),
            border: Border.all(
              color: MapThemeColors.primary,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: MapThemeColors.primary.withOpacity(0.2 * _glowAnimation.value),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Corner decorations
              ...List.generate(4, (index) {
                final isTop = index < 2;
                final isLeft = index.isEven;
                return Positioned(
                  top: isTop ? -2 : null,
                  bottom: !isTop ? -2 : null,
                  left: isLeft ? -2 : null,
                  right: !isLeft ? -2 : null,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border(
                        top: isTop ? BorderSide.none : BorderSide(color: MapThemeColors.primary, width: 2),
                        bottom: !isTop ? BorderSide.none : BorderSide(color: MapThemeColors.primary, width: 2),
                        left: isLeft ? BorderSide.none : BorderSide(color: MapThemeColors.primary, width: 2),
                        right: !isLeft ? BorderSide.none : BorderSide(color: MapThemeColors.primary, width: 2),
                      ),
                    ),
                  ),
                );
              }),
              
              // Content
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Level indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: MapThemeColors.primary.withOpacity(0.2),
                          border: Border.all(color: MapThemeColors.primary, width: 1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'LVL ${widget.level}',
                          style: TextStyle(
                            color: MapThemeColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Zone name
                      Expanded(
                        child: Text(
                          widget.zoneName,
                          style: TextStyle(
                            color: MapThemeColors.secondary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: MapThemeColors.primary.withOpacity(0.5 + (0.5 * _glowAnimation.value)),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.subZone,
                    style: TextStyle(
                      color: MapThemeColors.secondary.withOpacity(0.7),
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          color: MapThemeColors.primary.withOpacity(0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}