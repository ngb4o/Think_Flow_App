part of 'widget_imports.dart';

class AudioDetailTab extends StatefulWidget {
  const AudioDetailTab({super.key, required this.noteId});

  final String noteId;
  @override
  State<AudioDetailTab> createState() => _AudioDetailTabState();
}

class _AudioDetailTabState extends State<AudioDetailTab> {
  @override
  void initState() {
    super.initState();
    context.read<NoteDetailBloc>().add(NoteAudioDetailInitialFetchDataEvent(noteId: widget.noteId));
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

          return ListView.builder(
            itemCount: audioList.length,
            itemBuilder: (context, index) {
              final audio = audioList[index];
              return ListTile(
                leading: Icon(Iconsax.audio_square, color: TColors.primary),
                title: Text(audio.id ?? 'Untitled'),
                subtitle: Text(
                  'Format: ${audio.format ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: Icon(Iconsax.play, color: TColors.primary),
                  onPressed: () {
                    // TODO: Implement audio playback
                  },
                ),
              );
            },
          );
        }

        return const Center(child: Text('Error loading audio content'));
      },
    );
  }
}
