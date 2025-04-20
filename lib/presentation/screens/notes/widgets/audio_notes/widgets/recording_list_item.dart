import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/constants/sizes.dart';

class RecordingListItem extends StatelessWidget {
  final String name;
  final String duration;
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onDelete;

  const RecordingListItem({
    Key? key,
    required this.name,
    required this.duration,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: TSizes.spaceBtwItems,
      minLeadingWidth: 0,
      leading: Icon(Iconsax.microphone),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: TSizes.xs),
          Text(
            duration,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(isPlaying ? Iconsax.pause : Iconsax.play),
            onPressed: onPlayPause,
          ),
          IconButton(
            icon: const Icon(Iconsax.trash),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
} 