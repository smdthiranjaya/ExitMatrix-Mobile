import 'package:exitmatrix/core/constants/constants.dart';
import 'package:exitmatrix/services/ttsservice.dart';
import 'package:flutter/material.dart';
import 'package:exitmatrix/models/map_data.dart';

class InfoPanel extends StatefulWidget {
  final MapData mapData;

  const InfoPanel({
    Key? key,
    required this.mapData,
  }) : super(key: key);

  @override
  State<InfoPanel> createState() => _InfoPanelState();
}

class _InfoPanelState extends State<InfoPanel> {
  final TTSService _ttsService = TTSService();

  @override
  void initState() {
    super.initState();
    _initializeTTS();
  }

  Future<void> _initializeTTS() async {
    await _ttsService.initialize();
  }

  @override
  void didUpdateWidget(InfoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mapData.instructions.isNotEmpty &&
        widget.mapData.currentInstructionIndex < widget.mapData.instructions.length) {
      final newInstruction = widget.mapData.instructions[widget.mapData.currentInstructionIndex];
      _ttsService.speakInstruction(newInstruction);
    }
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: EmergencyThemeColors.surface,
              boxShadow: [
                BoxShadow(
                  color: EmergencyThemeColors.text.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Location Header
                if (widget.mapData.buildingName.isNotEmpty)
                  _HeaderBox(
                    header: '${widget.mapData.buildingName} - Floor ${widget.mapData.floorNumber}',
                    onTap: () => _ttsService.speakInstruction(
                      'You are in ${widget.mapData.buildingName}, Floor ${widget.mapData.floorNumber}',
                    ),
                  ),

                // Warning Box
                if (widget.mapData.warning != null && widget.mapData.warning!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _WarningBox(
                      warning: widget.mapData.warning!,
                      onTap: () => _ttsService.speakInstruction(widget.mapData.warning!),
                    ),
                  ),

                // Instructions Box
                if (widget.mapData.instructions.isNotEmpty &&
                    widget.mapData.currentInstructionIndex < widget.mapData.instructions.length)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: _InstructionBox(
                      instruction: widget.mapData.instructions[widget.mapData.currentInstructionIndex],
                      instructionNumber: widget.mapData.currentInstructionIndex + 1,
                      totalInstructions: widget.mapData.instructions.length,
                      onTap: () => _ttsService.speakInstruction(
                        widget.mapData.instructions[widget.mapData.currentInstructionIndex],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBox extends StatelessWidget {
  final String header;
  final VoidCallback onTap;

  const _HeaderBox({
    required this.header,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: EmergencyThemeColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: EmergencyThemeColors.secondary),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.location_on, color: EmergencyThemeColors.secondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  header,
                  style: TextStyle(
                    color: EmergencyThemeColors.text,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(Icons.volume_up, color: EmergencyThemeColors.secondary),
            ],
          ),
        ),
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  final String warning;
  final VoidCallback onTap;

  const _WarningBox({
    required this.warning,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: EmergencyThemeColors.primary.withOpacity(0.1),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: EmergencyThemeColors.primary, width: 2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: EmergencyThemeColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  warning,
                  style: TextStyle(
                    color: EmergencyThemeColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(Icons.volume_up, color: EmergencyThemeColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _InstructionBox extends StatelessWidget {
  final String instruction;
  final int instructionNumber;
  final int totalInstructions;
  final VoidCallback onTap;

  const _InstructionBox({
    required this.instruction,
    required this.instructionNumber,
    required this.totalInstructions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: EmergencyThemeColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: EmergencyThemeColors.secondary),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              child: LinearProgressIndicator(
                value: instructionNumber / totalInstructions,
                backgroundColor: EmergencyThemeColors.surface,
                valueColor: AlwaysStoppedAnimation<Color>(EmergencyThemeColors.secondary),
                minHeight: 4,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: EmergencyThemeColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$instructionNumber/$totalInstructions',
                      style: TextStyle(
                        color: EmergencyThemeColors.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      instruction,
                      style: TextStyle(
                        color: EmergencyThemeColors.text,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(Icons.volume_up, color: EmergencyThemeColors.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}