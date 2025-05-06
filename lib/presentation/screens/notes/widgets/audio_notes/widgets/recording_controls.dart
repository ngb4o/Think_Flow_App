import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:think_flow/utils/helpers/helper_functions.dart';
import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';

class RecordingControls extends StatelessWidget {
  final bool isRecording;
  final bool isPaused;
  final Duration recordingDuration;
  final VoidCallback onCancel;
  final VoidCallback onStop;
  final VoidCallback onPauseResume;
  final RecorderController recorderController;

  const RecordingControls({
    Key? key,
    required this.isRecording,
    required this.isPaused,
    required this.recordingDuration,
    required this.onCancel,
    required this.onStop,
    required this.onPauseResume,
    required this.recorderController,
  }) : super(key: key);

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return Container(
      padding: EdgeInsets.only(bottom: TSizes.defaultSpace),
      decoration: BoxDecoration(
        color: TColors.primary,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: TColors.grey),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isRecording)
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    _formatDuration(recordingDuration),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: TColors.white),
                  ),
                  const SizedBox(height: TSizes.sm),
                  Container(
                    height: 70,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AudioWaveforms(
                      size: Size(MediaQuery.of(context).size.width, 70),
                      recorderController: recorderController,
                      waveStyle: WaveStyle(
                        waveColor: TColors.white,
                        showBottom: true,
                        extendWaveform: true,
                        showMiddleLine: false,
                        spacing: 4,
                        waveCap: StrokeCap.round,
                        waveThickness: 2,
                        scaleFactor: 70,
                      ),
                      enableGesture: false,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton(
                backgroundColor: TColors.white,
                heroTag: 'cancel',
                onPressed: onCancel,
                child: Icon(Iconsax.close_circle, color: isDarkMode ? TColors.dark :TColors.primary),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              SizedBox(
                height: 65,
                width: 65,
                child: FloatingActionButton(
                  backgroundColor: Colors.pink,
                  heroTag: 'stop',
                  onPressed: onStop,
                  child: Icon(Iconsax.stop, color: TColors.white, size: 35),
                ),
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              FloatingActionButton(
                backgroundColor: TColors.white,
                heroTag: 'pause',
                onPressed: onPauseResume,
                child: Icon(isPaused ? Iconsax.play : Iconsax.pause, color: isDarkMode ? TColors.dark :TColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}