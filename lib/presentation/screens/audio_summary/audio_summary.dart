part of 'audio_summary_imports.dart';

@RoutePage()
class AudioSummaryScreen extends StatefulWidget {
  const AudioSummaryScreen(
      {super.key, required this.audioId, required this.permission});

  final String audioId;
  final String permission;

  @override
  State<AudioSummaryScreen> createState() => _AudioSummaryScreenState();
}

class _AudioSummaryScreenState extends State<AudioSummaryScreen> {
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;
  double playbackSpeed = 1.0;
  final List<double> availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];
  String? currentAudioUrl;
  bool _isEditing = false;
  AudioNoteModel? _cachedAudioNoteModel;
  final TextEditingController _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<AudioSummaryBloc>()
        .add(AudioSummaryInitialFetchDataAudioEvent(audioId: widget.audioId, permission: widget.permission));

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

    audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state.playing;
        });
      }
    });
  }

  Future<void> _playAudio(String url) async {
    try {
      if (currentAudioUrl != url) {
        await audioPlayer.setUrl(url);
        currentAudioUrl = url;
      }
      
      if (audioPlayer.playing) {
        await audioPlayer.pause();
      } else {
        await audioPlayer.play();
      }
    } catch (e) {
      print('Error playing audio: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error playing audio: $e')),
        );
      }
    }
  }

  Future<void> _seekTo(Duration position) async {
    try {
      await audioPlayer.seek(position);
    } catch (e) {
      print('Error seeking audio: $e');
    }
  }

  Future<void> _stopAndDisposeAudio() async {
    try {
      await audioPlayer.stop();
      await audioPlayer.dispose();
    } catch (e) {
      print('Error disposing audio player: $e');
    }
  }

  void _resetSummary() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note. Please contact the owner to update permissions.');
      return;
    }
    if (_cachedAudioNoteModel?.data?.id == null) {
      TLoaders.errorSnackBar(context,
          title: 'Error', message: 'Invalid audio data');
      return;
    }
    context.read<AudioSummaryBloc>().add(
          AudioSummaryCreateSummaryTextEvent(
            audioId: widget.audioId,
            permission: widget.permission,
          ),
        );
  }

  void _enterEditMode() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note. Please contact the owner to update permissions.');
      return;
    }
    if (_cachedAudioNoteModel?.data?.summary?.summaryText != null) {
      _summaryController.text =
          _cachedAudioNoteModel!.data!.summary!.summaryText!;
    }
    setState(() {
      _isEditing = true;
    });
  }

  void _updateSummary(String summaryId) {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note. Please contact the owner to update permissions.');
      return;
    }
    if (_cachedAudioNoteModel?.data?.summary?.id == null) {
      TLoaders.errorSnackBar(context,
          title: 'Error', message: 'Invalid summary data');
      return;
    }

    context.read<AudioSummaryBloc>().add(
          AudioSummaryClickButtonUpdateSummaryTextEvent(
            textId: summaryId,
            summaryText: _summaryController.text,
            audioId: widget.audioId,
            permission: widget.permission,
          ),
        );
  }

  @override
  void dispose() {
    _stopAndDisposeAudio();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AudioSummaryBloc, AudioSummaryState>(
      buildWhen: (previous, current) => current is! AudioSummaryActionState,
      listenWhen: (previous, current) => current is AudioSummaryActionState,
      listener: (context, state) {
        if (state is AudioSummarySuccessState) {
          final audioUrl = state.audioNoteModel?.data?.fileUrl;
          if (audioUrl != null && audioUrl.isNotEmpty) {
            _playAudio(audioUrl);
          }
        } else if (state is AudioSummaryErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is AudioSummaryCreateTextErrorState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is AudioSummaryUpdateSummaryTextSuccessActionState) {
          setState(() {
            _isEditing = false;
            _cachedAudioNoteModel = null;
            _summaryController.clear();
          });
          context
              .read<AudioSummaryBloc>()
              .add(AudioSummaryInitialFetchDataAudioEvent(audioId: widget.audioId, permission: widget.permission));
        }
      },
      builder: (context, state) {
        if (state is AudioSummaryLoadingState || state is AudioSummaryCreateSummaryTextLoadingState || state is AudioSummaryUpdateTextSummaryLoadingState) {
          return Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
              title: Text('Audio Summary'),
              centerTitle: true,
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Center(child: LoadingSpinkit.loadingPage)],
            ),
          );
        } 
        if (state is AudioSummarySuccessState) {
          _cachedAudioNoteModel = state.audioNoteModel;
          final summaryText = _cachedAudioNoteModel?.data?.summary?.summaryText;

          return Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
              title: Text('Audio Summary'),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Expanded(
                  child: !_isEditing
                      ? Padding(
                          padding: const EdgeInsets.only(
                            left: TSizes.defaultSpace,
                            right: TSizes.defaultSpace,
                            bottom: TSizes.defaultSpace,
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: summaryText == null || summaryText.isEmpty
                                        ? SizedBox(
                                            height: THelperFunctions.screenHeight(context) * 0.6,
                                            child: widget.permission == 'read'
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.lock_outline, size: 48, color: Colors.grey),
                                                        const SizedBox(height: 16),
                                                        Text(
                                                          'Audio summary has not been created yet. Please contact the owner to create.',
                                                          textAlign: TextAlign.center,
                                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : const Center(child: LoadingSpinkit.loadingPage),
                                          )
                                        : SingleChildScrollView(
                                            child: GestureDetector(
                                              onTap: widget.permission == 'read'
                                                  ? null
                                                  : _enterEditMode,
                                              child: Padding(
                                                padding: const EdgeInsets.all(TSizes.sm),
                                                child: Utils.buildSummaryText(context, summaryText),
                                              ),
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              if (summaryText != null && widget.permission != 'read')
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (state is AudioSummaryCreateSummaryTextLoadingState)
                                          Padding(
                                            padding: const EdgeInsets.all(TSizes.sm),
                                            child: LoadingSpinkit.loadingButton,
                                          )
                                        else
                                          IconButton(
                                            icon: Icon(Iconsax.refresh),
                                            onPressed: _resetSummary,
                                            tooltip: 'Reset Summary',
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: TSizes.defaultSpace,
                                right: TSizes.defaultSpace,
                                bottom: TSizes.defaultSpace,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _summaryController,
                                      maxLines: null,
                                      decoration: InputDecoration(
                                        hintText: 'Enter summary...',
                                        border: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state is AudioSummaryCreateSummaryTextLoadingState)
                              Positioned(
                                bottom: 10,
                                right: 0,
                                child: LoadingSpinkit.loadingButton,
                              )
                            else
                              Positioned(
                                bottom: TSizes.defaultSpace,
                                right: TSizes.defaultSpace,
                                child: GestureDetector(
                                  onTap: () {
                                    _updateSummary(_cachedAudioNoteModel!.data!.summary!.id.toString());
                                  },
                                  child: state is AudioSummaryUpdateTextSummaryLoadingState
                                      ? LoadingSpinkit.loadingButton
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: TColors.primary,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: TSizes.md, vertical: TSizes.sm),
                                          child: Text(
                                            'Save',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: TColors.white),
                                          ),
                                        ),
                                ),
                              ),
                          ],
                        ),
                ),
                AudioPlayerControls(
                  fileName: state.audioNoteModel?.data?.name ?? 'Audio',
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
                  onClose: () async {
                    await _stopAndDisposeAudio();
                    setState(() {
                      isPlaying = false;
                      currentPosition = Duration.zero;
                      currentAudioUrl = null;
                    });
                  },
                  onPlayPause: () =>
                      _playAudio(state.audioNoteModel?.data?.fileUrl ?? ''),
                  onSeek: _seekTo,
                  onBackward: () {
                    final newPosition =
                        currentPosition - const Duration(seconds: 15);
                    _seekTo(
                        newPosition.isNegative ? Duration.zero : newPosition);
                  },
                  onForward: () {
                    final newPosition =
                        currentPosition + const Duration(seconds: 15);
                    _seekTo(newPosition > totalDuration
                        ? totalDuration
                        : newPosition);
                  },
                ),
              ],
            ),
          );
        } else if (state is AudioSummaryErrorState) {
          return Scaffold(
            body: Center(
              child: Text('Error'),
            ),
          );
        }
        return Container();
      },
    );
  }
}
