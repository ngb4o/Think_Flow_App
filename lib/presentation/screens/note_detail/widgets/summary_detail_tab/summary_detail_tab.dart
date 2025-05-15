part of '../widget_imports.dart';

class SummaryDetailTab extends StatefulWidget {
  const SummaryDetailTab({
    super.key,
    required this.noteId,
    required this.permission,
  });

  final String noteId;
  final String permission;

  @override
  State<SummaryDetailTab> createState() => _SummaryDetailTabState();
}

class _SummaryDetailTabState extends State<SummaryDetailTab>
    with AutomaticKeepAliveClientMixin {
  bool _isEditing = false;
  TextNoteModel? _cachedTextNoteModel;
  final TextEditingController _summaryController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadSummaryContent();
  }

  void _loadSummaryContent() {
    context
        .read<NoteDetailBloc>()
        .add(NoteInitialFetchDataSummaryEvent(noteId: widget.noteId));
  }

  void _resetSummary() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    if (_cachedTextNoteModel?.data?.id == null) {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'Cannot reset summary: Text note data not loaded');
      return;
    }
    context.read<NoteDetailBloc>().add(
          NoteDetailCreateSummaryEvent(textId: _cachedTextNoteModel!.data!.id!),
        );
  }

  void _enterEditMode() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    if (_cachedTextNoteModel?.data?.summary?.summaryText != null) {
      _summaryController.text =
          _cachedTextNoteModel!.data!.summary!.summaryText!;
    }
    setState(() {
      _isEditing = true;
    });
  }

  void _updateSummary(String textId) {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }

    context.read<NoteDetailBloc>().add(
          NoteClickButtonUpdateSummaryEvent(
            noteId: textId,
            summaryText: _summaryController.text,
          ),
        );
  }

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<NoteDetailBloc, NoteDetailState>(
      listenWhen: (previous, current) => current is NoteDetailActionState,
      buildWhen: (previous, current) => current is! NoteDetailActionState,
      listener: (context, state) {
        if (state is NoteUpdateSummaryDetailSuccessActionState) {
          setState(() {
            _isEditing = false;
          });
          _loadSummaryContent();
        } else if (state is NoteUpdateDetailErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is NoteDetailCreateSummaryErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if(state is NoteDetailCreateSummarySuccessActionState) {
          context.read<NoteDetailBloc>().add(NoteInitialFetchDataSummaryEvent(noteId: widget.noteId));
        }
      },
      builder: (context, state) {
        if (state is NoteSummaryLoadingState &&
            _cachedTextNoteModel?.data?.summary?.summaryText == null) {
          return const Center(child: LoadingSpinkit.loadingPage);
        }

        if (state is NoteSummarySuccessState) {
          _cachedTextNoteModel = state.textNoteModel;
        }

        final summaryText = _cachedTextNoteModel?.data?.summary?.summaryText;

        if (!_isEditing) {
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (summaryText == null || summaryText.isEmpty)
                      SizedBox(
                        height: THelperFunctions.screenHeight(context) * 0.6,
                        child: const Center(child: LoadingSpinkit.loadingPage),
                      )
                    else
                      GestureDetector(
                        onTap: widget.permission == 'read' ? null : _enterEditMode,
                        child: Padding(
                          padding: const EdgeInsets.all(TSizes.sm),
                          child: Utils.buildSummaryText(context, summaryText),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
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
                      if (state is NoteDetailCreateSummaryLoadingState)
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
          );
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: TextField(
                controller: _summaryController,
                maxLines: null,
                expands: true,
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
            if (state is NoteUpdateSummaryDetailLoadingState ||
                state is NoteDetailCreateSummaryLoadingState)
              Positioned(
                bottom: 10,
                right: 0,
                child: LoadingSpinkit.loadingButton,
              )
            else
              Positioned(
                bottom: 10,
                right: 0,
                child: GestureDetector(
                  onTap: () => _updateSummary(
                      _cachedTextNoteModel!.data!.summary!.id.toString()),
                  child: Container(
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
        );
      },
    );
  }
}
