part of 'note_archived_imports.dart';

@RoutePage()
class NoteArchivedScreen extends StatefulWidget {
  const NoteArchivedScreen({super.key});

  @override
  State<NoteArchivedScreen> createState() => _NoteArchivedScreenState();
}

class _NoteArchivedScreenState extends State<NoteArchivedScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NoteArchivedBloc>().add(NoteArchivedInitialFetchDataEvent());
  }

  void _unarchiveNote(String noteId) {
    context.read<NoteArchivedBloc>().add(NoteClickButtonUnarchiveEvent(noteId: noteId));
  }

  void deleteNoteWarningPopup(String noteId) {
    TWarningPopup.show(
      context: context,
      title: 'Delete Note',
      message: 'Are you sure you want to delete this note? This action cannot be undone.',
      onConfirm: () {
        context.read<HomeBloc>().add(HomeClickButtonDeleteNoteEvent(noteId: noteId));
        context.read<NoteArchivedBloc>().add(NoteArchivedInitialFetchDataEvent());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NoteArchivedBloc, NoteArchivedState>(
      listenWhen: (previous, current) => current is NoteArchivedActionState,
      buildWhen: (previous, current) => current is! NoteArchivedActionState,
      listener: (context, state) {
        if (state is NoteUnarchiveSuccessActionState) {
          TLoaders.successSnackBar(context, title: 'Note unarchived successfully');
          context.read<NoteArchivedBloc>().add(NoteArchivedInitialFetchDataEvent());
          context.read<HomeBloc>().add(HomeInitialFetchDataEvent());
        } else if(state is NoteUnarchiveErrorActionState) {
          TLoaders.errorSnackBar(context, title: 'Note unarchived failed', message: state.message);
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case NoteArchivedLoadingState:
            return Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                title: Text('Archived Note'),
                centerTitle: true,
              ),
              body: Center(child: LoadingSpinkit.loadingPage),
            );
          case NoteArchivedSuccessState:
            final noteArchived = state as NoteArchivedSuccessState;
            return Scaffold(
              appBar: TAppbar(
                showBackArrow: true,
                title: Text('Archived Note'),
                centerTitle: true,
              ),
              body: Column(
                children: [
                  Expanded(
                    child: noteArchived.noteModel.data.isEmpty
                        ? Center(
                            child: TEmpty(
                              subTitle: 'You don\'t have any resources yet.',
                            ),
                          )
                        : ListView.builder(
                            controller: null,
                            padding: EdgeInsets.all(TSizes.defaultSpace),
                            itemCount: noteArchived.noteModel.data.length,
                            itemBuilder: (context, index) {
                              final note = noteArchived.noteModel.data[index];
                              return Padding(
                                padding: EdgeInsets.only(bottom: TSizes.spaceBtwItems),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: TColors.grey, width: 2),
                                  ),
                                  padding: EdgeInsets.all(TSizes.spaceBtwItems),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              note.title,
                                              style: Theme.of(context).textTheme.titleMedium,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ),
                                          if (state is HomeDeleteNoteLoadingState)
                                            LoadingSpinkit.loadingButton
                                          else
                                          GestureDetector(
                                            onTap: () {
                                              deleteNoteWarningPopup(note.id);
                                            },
                                            child: Icon(
                                              Iconsax.trash,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: TSizes.lg),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            note.createdAt,
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                          if (state is NoteUnarchiveLoadingState)
                                            LoadingSpinkit.loadingButton
                                          else
                                            GestureDetector(
                                              onTap: () => _unarchiveNote(note.id),
                                              child: Icon(Iconsax.clipboard_export, size: 25),
                                            ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          case NoteArchivedErrorState:
            final message = state as NoteArchivedErrorState;
            return Scaffold(
              body: Center(
                child: Text(message.toString()),
              ),
            );
          default:
            return SizedBox();
        }
      },
    );
  }
}
