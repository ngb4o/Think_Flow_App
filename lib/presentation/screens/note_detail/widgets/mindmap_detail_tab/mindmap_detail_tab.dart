part of '../widget_imports.dart';

class MindmapNode {
  String text;
  List<MindmapNode> children;
  String branch;
  bool isExpanded;
  int depth;

  MindmapNode({
    required this.text,
    required this.branch,
    List<MindmapNode>? children,
    this.isExpanded = false,
  })  : children = children ?? [],
        depth = branch.split('.').length;
}

class MindmapDetailTab extends StatefulWidget {
  const MindmapDetailTab({
    super.key,
    required this.noteId,
    required this.permission,
  });

  final String noteId;
  final String permission;
  @override
  State<MindmapDetailTab> createState() => _MindmapDetailTabState();
}

class _MindmapDetailTabState extends State<MindmapDetailTab> {
  late MindmapNode root;
  final TransformationController _transformationController =
      TransformationController();
  double _scale = 1.0;
  static const double _defaultZoom = 0.5; // Set default zoom to 50%
  MindmapNode? _rootNode;
  String? _mindmapId;

  @override
  void initState() {
    super.initState();
    // Initialize with empty root
    root = MindmapNode(text: 'Loading...', branch: 'root');

    // Set initial zoom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scale = _defaultZoom;
      _transformationController.value = Matrix4.identity()..scale(_scale);

      // Fetch mindmap data
      context.read<MindmapNoteDetailBloc>().add(MindmapNoteDetailInitialFetchDataEvent(
          noteId: widget.noteId, permission: widget.permission));
    });
  }

  MindmapNode _convertToMindmapNode(ParentContent content) {
    return MindmapNode(
      text: content.content ?? '',
      branch: content.branch ?? '',
      children: content.children
              ?.map((child) => _convertToMindmapNode(child))
              .toList() ??
          [],
    );
  }

  void _updateMindmapFromData(NoteModel noteData) {
    if (noteData.data?.mindmap?.mindmapData?.parentContent?.isNotEmpty ==
        true) {
      // Create a root node to hold all branches
      final rootNode = MindmapNode(text: 'Root', branch: 'root');

      // Convert all parent content to mindmap nodes
      for (var content in noteData.data!.mindmap!.mindmapData!.parentContent!) {
        rootNode.children.add(_convertToMindmapNode(content));
      }

      setState(() {
        _rootNode = rootNode;
        _mindmapId = noteData.data!.mindmap!.id!;
      });
    }
  }

  void _handleMindmapUpdate(String mindmapId) {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    if (_rootNode != null) {
      final mindmapData = {
        'mindmap_data': {
          'parent_content': [_convertToApiFormat(_rootNode!)],
          'total_branches': _countBranches(_rootNode!)
        }
      };
      context.read<MindmapNoteDetailBloc>().add(
            MindmapNoteDetailUpdateEvent(
              mindmapId: mindmapId,
              mindmapData: mindmapData,
              permission: widget.permission,
            ),
          );
    }
  }

  int _countBranches(MindmapNode node) {
    int count = 1; // Count the current node
    for (var child in node.children) {
      count += _countBranches(child);
    }
    return count;
  }

  Map<String, dynamic> _convertToApiFormat(MindmapNode node) {
    return {
      'content': node.text,
      'children':
          node.children.map((child) => _convertToApiFormat(child)).toList(),
    };
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _scale = (_scale + 0.1).clamp(0.1, 2.0);
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
  }

  void _zoomOut() {
    setState(() {
      _scale = (_scale - 0.1).clamp(0.1, 2.0);
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
  }

  void _resetMindmap() {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message: 'You do not have permission to edit this note');
      return;
    }
    context.read<MindmapNoteDetailBloc>().add(MindmapNoteDetailCreateEvent(
        noteId: widget.noteId, permission: widget.permission));
  }

  void _showNodeOptions({
    required MindmapNode node,
    required VoidCallback onUpdate,
    bool isRoot = false,
    MindmapNode? parent,
  }) {
    if (widget.permission == 'read') {
      TLoaders.errorSnackBar(context,
          title: 'Error',
          message:
              'You do not have permission to edit this note. Please contact the owner to update permissions.');
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Iconsax.edit),
                title:
                    Text('Edit', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _editNodeText(node: node, onUpdate: onUpdate);
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                child: Divider(),
              ),
              ListTile(
                leading: Icon(Iconsax.add_square),
                title: Text('Add child',
                    style: Theme.of(context).textTheme.bodyLarge),
                onTap: () async {
                  Navigator.pop(context);
                  final controller = TextEditingController();
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) => Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: TSizes.md),
                      child: Dialog(
                        insetPadding: EdgeInsets.zero,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          decoration: BoxDecoration(
                            color: TColors.light,
                            borderRadius:
                                BorderRadius.circular(TSizes.borderRadiusLg),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Add child',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineSmall,
                                  ),
                                ],
                              ),
                              SizedBox(height: TSizes.spaceBtwItems),
                              Divider(),
                              SizedBox(height: TSizes.spaceBtwItems),
                              TextField(
                                controller: controller,
                                autofocus: true,
                                maxLines: 8,
                                minLines: 8,
                                decoration: const InputDecoration(
                                  hintText: 'Enter child content',
                                  hintStyle: TextStyle(color: TColors.darkGrey),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              SizedBox(height: TSizes.spaceBtwItems),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    )),
                                    onPressed: () {
                                      Navigator.pop(context, controller.text);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: TSizes.lg),
                                      child: const Text('Save'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  if (result != null && result.trim().isNotEmpty) {
                    setState(() {
                      node.children.add(MindmapNode(
                          text: result.trim(),
                          branch:
                              '${node.branch}.${node.children.length + 1}'));
                    });
                    onUpdate();
                  }
                },
              ),
              if (!isRoot) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: TSizes.md,
                  ),
                  child: Divider(),
                ),
                ListTile(
                  leading: Icon(Iconsax.trash, color: Colors.red),
                  title: Text('Delete',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.red)),
                  onTap: () {
                    if (parent != null) {
                      setState(() {
                        parent.children.remove(node);
                      });
                    }
                    Navigator.pop(context);
                    onUpdate();
                  },
                ),
              ]
            ],
          ),
        );
      },
    );
  }

  void _editNodeText({
    required MindmapNode node,
    required VoidCallback onUpdate,
  }) async {
    final controller = TextEditingController(text: node.text);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            decoration: BoxDecoration(
              color: TColors.light,
              borderRadius: BorderRadius.circular(TSizes.borderRadiusLg),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Edit Node',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                SizedBox(height: TSizes.spaceBtwItems),
                Divider(),
                SizedBox(height: TSizes.spaceBtwItems),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLines: 8,
                  minLines: 8,
                  decoration: const InputDecoration(
                    hintText: 'Enter node content',
                    hintStyle: TextStyle(color: TColors.darkGrey),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                      onPressed: () {
                        node.text = controller.text.trim();
                        Navigator.pop(context, node.text);
                        onUpdate();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 0, horizontal: TSizes.lg),
                        child: const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMindMapNode(MindmapNode node,
      {bool isRoot = false, MindmapNode? parent}) {
    final hasHiddenChildren = node.children.any((child) => child.depth > 4);
    node.children.where((child) => child.depth <= 4).toList();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () => _showNodeOptions(
            node: node,
            onUpdate: () {
              setState(() {});
              if (_mindmapId != null) {
                _handleMindmapUpdate(_mindmapId!);
              }
            },
            isRoot: isRoot,
            parent: parent,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: isRoot ? Colors.deepPurple : Colors.deepPurple.shade100,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(TSizes.md),
            margin: const EdgeInsets.symmetric(
                vertical: TSizes.md, horizontal: TSizes.md),
            child: SizedBox(
              width: 250,
              child: Text(
                node.text,
                style: TextStyle(
                  color: isRoot ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: isRoot ? 20 : 16,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ),
        if (hasHiddenChildren)
          GestureDetector(
            onTap: () {
              setState(() {
                node.isExpanded = !node.isExpanded;
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: isRoot
                    ? Colors.deepPurple.shade200
                    : Colors.deepPurple.shade50,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                node.isExpanded ? Iconsax.arrow_left_3 : Iconsax.arrow_right_2,
                color: isRoot ? Colors.white : Colors.deepPurple,
                size: 30,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildMindMapBranch(MindmapNode node,
      {bool isRoot = false, MindmapNode? parent}) {
    final isDarkMode = THelperFunctions.isDarkMode(context);

    // Filter children based on depth and expansion state
    final visibleChildren = node.children.where((child) {
      if (child.depth <= 4) return true;
      return node.isExpanded;
    }).toList();

    if (visibleChildren.isEmpty) {
      return _buildMindMapNode(node, isRoot: isRoot, parent: parent);
    }

    return Row(
      children: [
        _buildMindMapNode(node, isRoot: isRoot, parent: parent),
        MindMap(
          lineColor: isDarkMode ? TColors.white : TColors.black,
          children: visibleChildren
              .map((child) => _buildMindMapBranch(child, parent: node))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = THelperFunctions.isDarkMode(context);
    return BlocConsumer<MindmapNoteDetailBloc, MindmapNoteDetailState>(
      listener: (context, state) {
        if (state is MindmapNoteDetailSuccessState) {
          _updateMindmapFromData(state.noteModel);
        }
      },
      builder: (context, state) {
        if (state is MindmapNoteDetailLoadingState ||
            state is MindmapNoteDetailUpdateLoadingState) {
          return const Center(child: TLoadingSpinkit.loadingPage);
        }

        if (state is MindmapNoteDetailErrorState) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Failed to load mindmap',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<MindmapNoteDetailBloc>().add(
                        MindmapNoteDetailInitialFetchDataEvent(
                            noteId: widget.noteId,
                            permission: widget.permission));
                  },
                  icon: const Icon(Iconsax.refresh),
                  label: const Text('Reload'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (_rootNode == null) {
          return Center(
            child: (widget.permission == 'read'
                ? TEmptyWidget(
                    title: 'Mindmap note has not been created yet. ',
                    subTitle: 'Please contact the owner to create.',
                  )
                : TCreateWidget(
                    title: 'Creating mindmap note.',
                    subTitle:
                        'You will receive a notification once it\'s done.',
                  )),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: GestureDetector(
                  onScaleUpdate: (details) {
                    setState(() {
                      _scale = (_scale * details.scale).clamp(0.1, 2.0);
                      _transformationController.value = Matrix4.identity()
                        ..scale(_scale);
                    });
                  },
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: 0.1,
                    maxScale: 1.5,
                    scaleEnabled: true,
                    panEnabled: true,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _rootNode!.children
                            .map((node) =>
                                _buildMindMapBranch(node, isRoot: true))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? TColors.darkerGrey : Colors.white,
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
                    if (state is MindmapNoteDetailCreateLoadingState)
                      Padding(
                        padding: const EdgeInsets.all(TSizes.sm),
                        child: TLoadingSpinkit.loadingButton,
                      )
                    else if (widget.permission != 'read') ...[
                      IconButton(
                        icon: Icon(
                          Iconsax.refresh,
                          color: isDarkMode ? TColors.white : TColors.black,
                        ),
                        onPressed: _resetMindmap,
                        tooltip: 'Zoom in',
                      ),
                      Container(
                        width: 1,
                        height: 24,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ],
                    IconButton(
                      icon: Icon(
                        Iconsax.search_zoom_out,
                        color: isDarkMode ? TColors.white : TColors.black,
                      ),
                      onPressed: _zoomOut,
                      tooltip: 'Zoom out',
                    ),
                    Container(
                      width: 1,
                      height: 24,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    IconButton(
                      icon: Icon(
                        Iconsax.search_zoom_in_1,
                        color: isDarkMode ? TColors.white : TColors.black,
                      ),
                      onPressed: _zoomIn,
                      tooltip: 'Zoom in',
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
