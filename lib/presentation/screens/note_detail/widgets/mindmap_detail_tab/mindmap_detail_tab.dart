part of '../widget_imports.dart';

class MindmapNode {
  String text;
  List<MindmapNode> children;
  MindmapNode({required this.text, List<MindmapNode>? children}) : children = children ?? [];
}

class MindmapDetailTab extends StatefulWidget {
  const MindmapDetailTab({super.key});

  @override
  State<MindmapDetailTab> createState() => _MindmapDetailTabState();
}

class _MindmapDetailTabState extends State<MindmapDetailTab> {
  late MindmapNode root;
  final TransformationController _transformationController = TransformationController();
  double _scale = 1.0;
  static const double _defaultZoom = 0.7; // Set default zoom to 80%

  @override
  void initState() {
    super.initState();
    root = MindmapNode(text: 'Main Idea', children: [
      MindmapNode(text: 'Sub Idea 1', children: [
        MindmapNode(text: 'Sub Idea 1.1'),
        MindmapNode(text: 'Sub Idea 1.2'),
      ]),
      MindmapNode(text: 'Sub Idea 2', children: [
        MindmapNode(text: 'Sub Idea 2.1'),
      ]),
      MindmapNode(text: 'Sub Idea 3'),
      MindmapNode(text: 'Sub Idea 4', children: [
        MindmapNode(text: 'Sub Idea 4.1'),
        MindmapNode(text: 'Sub Idea 4.2'),
      ]),
      MindmapNode(text: 'Sub Idea 5'),
      MindmapNode(text: 'Sub Idea 6', children: [
        MindmapNode(text: 'Sub Idea 6.1'),
        MindmapNode(text: 'Sub Idea 6.2'),
        MindmapNode(text: 'Sub Idea 6.3'),
      ]),
    ]);
    // Set initial zoom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scale = _defaultZoom;
      _transformationController.value = Matrix4.identity()..scale(_scale);
    });
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

  void _showNodeOptions({
    required MindmapNode node,
    required VoidCallback onUpdate,
    bool isRoot = false,
    MindmapNode? parent,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Iconsax.edit),
                title: Text('Edit', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () {
                  Navigator.pop(context);
                  _editNodeText(node: node, onUpdate: onUpdate);
                },
              ),
              ListTile(
                leading: Icon(Iconsax.add_square),
                title: Text('Add child', style: Theme.of(context).textTheme.bodyLarge),
                onTap: () async {
                  Navigator.pop(context);
                  final controller = TextEditingController();
                  final result = await showDialog<String>(
                    context: context,
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
                      child: Dialog(
                        insetPadding: EdgeInsets.zero,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(TSizes.defaultSpace),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Text(
                                    'Add child',
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: controller,
                                autofocus: true,
                                maxLines: 5,
                                minLines: 5,
                                decoration: const InputDecoration(
                                  hintText: 'Enter child content',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, controller.text);
                                    },
                                    child: const Text('Save'),
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
                      node.children.add(MindmapNode(text: result.trim()));
                    });
                    onUpdate();
                  }
                },
              ),
              if (!isRoot)
                ListTile(
                  leading: Icon(Iconsax.trash, color: Colors.red),
                  title: Text('Delete', style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red)),
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
        padding: const EdgeInsets.symmetric(horizontal: TSizes.sm),
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding:  EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'Edit Node',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  autofocus: true,
                  maxLines: 5,
                  minLines: 5,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        node.text = controller.text.trim();
                        Navigator.pop(context, controller.text);
                        onUpdate();
                        setState(() {});
                      },
                      child: const Text('Save'),
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
      setState(() {});
      onUpdate();
    }
  }

  Widget _buildMindMapNode(MindmapNode node, {bool isRoot = false, MindmapNode? parent}) {
    return GestureDetector(
      onTap: () => _showNodeOptions(
        node: node,
        onUpdate: () {},
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
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: SizedBox(
          width: 160,
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
    );
  }

  Widget _buildMindMapBranch(MindmapNode node, {bool isRoot = false, MindmapNode? parent}) {
    if (node.children.isEmpty) {
      return _buildMindMapNode(node, isRoot: isRoot, parent: parent);
    }
    return Row(
      children: [
        _buildMindMapNode(node, isRoot: isRoot, parent: parent),
        MindMap(
          padding: const EdgeInsets.only(left: 50),
          dotRadius: 4,
          children: node.children
              .map((child) => _buildMindMapBranch(child, parent: node))
              .toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.1,
              maxScale: 2,
              boundaryMargin: const EdgeInsets.all(800),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    _buildMindMapBranch(root, isRoot: true),
                  ],
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
                IconButton(
                  icon: const Icon(Iconsax.search_zoom_out),
                  onPressed: _zoomOut,
                  tooltip: 'Zoom out',
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: Colors.grey.withOpacity(0.3),
                ),
                IconButton(
                  icon: Icon(Iconsax.search_zoom_in_1),
                  onPressed: _zoomIn,
                  tooltip: 'Zoom in',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}