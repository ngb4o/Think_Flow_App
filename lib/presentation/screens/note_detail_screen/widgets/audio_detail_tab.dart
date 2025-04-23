part of 'widget_imports.dart';

class AudioDetailTab extends StatefulWidget {
  const AudioDetailTab({super.key, required this.noteId});

  final String noteId;
  @override
  State<AudioDetailTab> createState() => _AudioDetailTabState();
}

class _AudioDetailTabState extends State<AudioDetailTab> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  int? currentlyPlayingIndex;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double playbackSpeed = 1.0;
  final List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    context.read<NoteDetailBloc>().add(NoteAudioDetailInitialFetchDataEvent(noteId: widget.noteId));
    
    audioPlayer.positionStream.listen((position) {
      if (mounted) {
        setState(() {
          currentPosition = position;
        });
      }
    });
    
    audioPlayer.durationStream.listen((duration) {
      if (mounted) {
        setState(() {
          totalDuration = duration ?? Duration.zero;
        });
      }
    });
  }

  Future<void> _playAudio(int index, String url) async {
    if (currentlyPlayingIndex == index) {
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
      setState(() {
        isPlaying = audioPlayer.playing;
      });
      return;
    }

    if (currentlyPlayingIndex != null) {
      await audioPlayer.stop();
    }

    setState(() {
      currentlyPlayingIndex = index;
      isPlaying = true;
      currentPosition = Duration.zero;
      playbackSpeed = 1.0;
    });

    await audioPlayer.setUrl(url);
    await audioPlayer.setSpeed(playbackSpeed);
    await audioPlayer.play();

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) {
          setState(() {
            isPlaying = false;
            currentPosition = Duration.zero;
            audioPlayer.seek(Duration.zero);
          });
        }
      }
    });
  }

  Future<void> _seekTo(Duration position) async {
    await audioPlayer.seek(position);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteDetailBloc, NoteDetailState>(
      buildWhen: (previous, current) => current is! NoteDetailActionState,
      builder: (context, state) {
        if (state is NoteAudioDetailLoadingState) {
          return const Center(child: LoadingSpinkit.loadingPage);
        }

        if (state is NoteAudioDetailSuccessState) {
          final audioList = state.audioNoteModel?.data ?? [];
          
          if (audioList.isEmpty) {
            return Center(
              child: TEmpty(subTitle: 'No audio recordings yet'),
            );
          }

          return Column(
            children: [
              SizedBox(height: TSizes.spaceBtwItems),
              if(audioList.isEmpty)
                Expanded(
                  child: Center(
                    child: TEmpty(subTitle: 'No audio recordings yet'),
                  ),
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: audioList.length,
                  itemBuilder: (context, index) {
                    final audio = audioList[index];
                    return RecordingListItem(
                      name: 'Audio ${index + 1}',
                      duration: 'Date: ${Utils.formatDate(audio.createdAt)}',
                      isPlaying: currentlyPlayingIndex == index && isPlaying,
                      onPlayPause: () => _playAudio(index, audio.fileUrl ?? ''),
                      onDelete: () {
                        // TODO: Implement delete functionality if needed
                      },
                    );
                  },
                ),
              ),
              if (currentlyPlayingIndex != null)
                AudioPlayerControls(
                  fileName: audioList[currentlyPlayingIndex!].id ?? 'Untitled',
                  currentPosition: currentPosition,
                  totalDuration: totalDuration,
                  playbackSpeed: playbackSpeed,
                  availableSpeeds: availableSpeeds,
                  isPlaying: isPlaying,
                  onSpeedChanged: (double speed) async {
                    setState(() {
                      playbackSpeed = speed;
                    });
                    await audioPlayer.setSpeed(speed);
                  },
                  onClose: () {
                    audioPlayer.stop();
                    setState(() {
                      currentlyPlayingIndex = null;
                      isPlaying = false;
                      currentPosition = Duration.zero;
                    });
                  },
                  onPlayPause: () => _playAudio(
                    currentlyPlayingIndex!, 
                    audioList[currentlyPlayingIndex!].fileUrl ?? ''
                  ),
                  onSeek: _seekTo,
                  onBackward: () {
                    final newPosition = currentPosition - const Duration(seconds: 15);
                    _seekTo(newPosition.isNegative ? Duration.zero : newPosition);
                  },
                  onForward: () {
                    final newPosition = currentPosition + const Duration(seconds: 15);
                    _seekTo(newPosition > totalDuration ? totalDuration : newPosition);
                  },
                ),
            ],
          );
        }

        return const Center(child: Text('Error loading audio content'));
      },
    );
  }
}
