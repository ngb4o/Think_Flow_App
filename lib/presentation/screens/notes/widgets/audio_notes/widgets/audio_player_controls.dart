import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class AudioPlayerControls extends StatefulWidget {
  final String fileName;
  final Duration currentPosition;
  final Duration totalDuration;
  final double playbackSpeed;
  final List<double> availableSpeeds;
  final bool isPlaying;
  final Function(double) onSpeedChanged;
  final VoidCallback onClose;
  final VoidCallback onPlayPause;
  final Function(Duration) onSeek;
  final VoidCallback onBackward;
  final VoidCallback onForward;

  const AudioPlayerControls({
    Key? key,
    required this.fileName,
    required this.currentPosition,
    required this.totalDuration,
    required this.playbackSpeed,
    required this.availableSpeeds,
    required this.isPlaying,
    required this.onSpeedChanged,
    required this.onClose,
    required this.onPlayPause,
    required this.onSeek,
    required this.onBackward,
    required this.onForward,
  }) : super(key: key);

  @override
  State<AudioPlayerControls> createState() => _AudioPlayerControlsState();
}

class _AudioPlayerControlsState extends State<AudioPlayerControls> {
  late bool _isPlaying;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
  }

  @override
  void didUpdateWidget(AudioPlayerControls oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isPlaying != widget.isPlaying) {
      _isPlaying = widget.isPlaying;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: TColors.primary,
        borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.fileName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: TColors.white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.close_circle, color: TColors.white),
                onPressed: widget.onClose,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                _formatDuration(widget.currentPosition),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TColors.white),
              ),
              Expanded(
                child: widget.totalDuration > Duration.zero
                    ? SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: TColors.white,
                          inactiveTrackColor: TColors.white.withOpacity(0.3),
                          thumbColor: TColors.white,
                          trackHeight: 4,
                        ),
                        child: Slider(
                          value: widget.currentPosition.inSeconds.toDouble(),
                          max: widget.totalDuration.inSeconds.toDouble(),
                          onChanged: (value) {
                            widget.onSeek(Duration(seconds: value.toInt()));
                          },
                        ),
                      )
                    : const SizedBox(),
              ),
              Text(
                _formatDuration(widget.totalDuration),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: TColors.white),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    PopupMenuButton<double>(
                      icon: Text(
                        '${widget.playbackSpeed}x',
                        style: const TextStyle(color: TColors.white),
                      ),
                      onSelected: widget.onSpeedChanged,
                      itemBuilder: (BuildContext context) => widget.availableSpeeds.map((double speed) {
                        return PopupMenuItem<double>(
                          value: speed,
                          child: Text('${speed}x'),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Iconsax.backward_15_seconds, color: TColors.white),
                onPressed: widget.onBackward,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              FloatingActionButton(
                backgroundColor: TColors.white,
                child: Icon(
                  _isPlaying ? Iconsax.pause : Iconsax.play,
                  color: TColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    _isPlaying = !_isPlaying;
                  });
                  widget.onPlayPause();
                },
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              IconButton(
                icon: const Icon(Iconsax.forward_15_seconds, color: TColors.white),
                onPressed: widget.onForward,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Iconsax.document_download5, color: TColors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 