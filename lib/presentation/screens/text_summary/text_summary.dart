part of 'text_summary_imports.dart';

@RoutePage()
class TextSummaryScreen extends StatefulWidget {
  const TextSummaryScreen({
    super.key,
    required this.noteId,
    required this.permission,
    required this.titleSummary,
  });

  final String noteId;
  final String permission;
  final String titleSummary;

  @override
  State<TextSummaryScreen> createState() => _TextSummaryScreenState();
}

class _TextSummaryScreenState extends State<TextSummaryScreen> {
  bool _isEditing = false;
  TextNoteModel? _cachedTextNoteModel;
  final TextEditingController _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context
        .read<TextSummaryBloc>()
        .add(TextSummaryInitialFetchDataEvent(noteId: widget.noteId, permission: widget.permission));
  }

  void _resetSummary() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note. Please contact the owner to update permissions.');
      return;
    }
    if (_cachedTextNoteModel?.data?.id == null) {
      TLoaders.errorSnackBar(context,
          title: 'Error', message: 'Invalid note data');
      return;
    }
    context.read<TextSummaryBloc>().add(
          TextSummaryCreateTextEvent(
            textId: _cachedTextNoteModel!.data!.id.toString(),
            noteId: widget.noteId,
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
          message: 'You do not have permission to edit this note. Please contact the owner to update permissions.');
      return;
    }
    if (_cachedTextNoteModel?.data?.summary?.id == null) {
      TLoaders.errorSnackBar(context,
          title: 'Error', message: 'Invalid summary data');
      return;
    }

    context.read<TextSummaryBloc>().add(
          TextSummaryClickButtonUpdateSummaryTextEvent(
            textId: textId,
            summaryText: _summaryController.text,
            permission: widget.permission,
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
    return BlocConsumer<TextSummaryBloc, TextSummaryState>(
      listenWhen: (previous, current) => current is TextSummaryActionState,
      buildWhen: (previous, current) => current is! TextSummaryActionState,
      listener: (context, state) {
        if (state is TextSummaryErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is TextSummaryCreateTextErrorActionState) {
          TLoaders.errorSnackBar(context,
              title: 'Error', message: state.message);
        } else if (state is TextSummaryUpdateSummaryDetailSuccessActionState) {
          setState(() {
            _isEditing = false;
            _cachedTextNoteModel = null;
            _summaryController.clear();
          });
          context
              .read<TextSummaryBloc>()
              .add(TextSummaryInitialFetchDataEvent(noteId: widget.noteId, permission: widget.permission));
        }
      },
      builder: (context, state) {
        if (state is TextSummaryLoadingState ||
            state is TextSummaryCreateTextLoadingState ||
            state is TextSummaryUpdateSummaryDetailLoadingState) {
          return Scaffold(
            appBar: TAppbar(showBackArrow: true),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Center(child: LoadingSpinkit.loadingPage)],
            ),
          );
        }

        if (state is TextSummarySuccessState) {
          _cachedTextNoteModel = state.textNoteModel;
          final summaryText = _cachedTextNoteModel?.data?.summary?.summaryText;

          return Scaffold(
            appBar: TAppbar(showBackArrow: true),
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
                                  Text('Summary: ${widget.titleSummary}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                  SizedBox(height: TSizes.spaceBtwItems),
                                  Expanded(
                                    child: summaryText == null ||
                                            summaryText.isEmpty
                                        ? SizedBox(
                                            height:
                                                THelperFunctions.screenHeight(
                                                        context) *
                                                    0.6,
                                            child: widget.permission == 'read'
                                                ? Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.lock_outline,
                                                            size: 48,
                                                            color: Colors.grey),
                                                        const SizedBox(
                                                            height: 16),
                                                        Text(
                                                          'Text summary has not been created yet. Please contact the owner to create.',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : const Center(
                                                    child:
                                                        LoadingSpinkit.loadingPage),
                                          )
                                        : SingleChildScrollView(
                                            child: GestureDetector(
                                              onTap: widget.permission == 'read'
                                                  ? null
                                                  : _enterEditMode,
                                              child: Padding(
                                                padding: EdgeInsets.zero,
                                                child: Utils.buildSummaryText(
                                                    context, summaryText),
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
                                        if (state
                                            is TextSummaryCreateTextLoadingState)
                                          Padding(
                                            padding:
                                                const EdgeInsets.all(TSizes.sm),
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
                                  Text('Summary: ${widget.titleSummary}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium),
                                  SizedBox(height: TSizes.spaceBtwItems),
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
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (state is TextSummaryCreateTextLoadingState)
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
                                    _updateSummary(_cachedTextNoteModel!
                                        .data!.summary!.id
                                        .toString());
                                  },
                                  child: state
                                          is TextSummaryUpdateSummaryDetailLoadingState
                                      ? LoadingSpinkit.loadingButton
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: TColors.primary,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: TSizes.md,
                                              vertical: TSizes.sm),
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
              ],
            ),
          );
        } else if (state is TextSummaryErrorActionState) {
          return Scaffold(
            appBar: TAppbar(
              showBackArrow: true,
              title: Text('Text Summary'),
              centerTitle: true,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: TColors.error),
                  SizedBox(height: TSizes.spaceBtwItems),
                  Text(
                    'Failed to load summary',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
