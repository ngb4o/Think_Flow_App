import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../utils/constants/sizes.dart';

class RecordingListItem extends StatelessWidget {
  final String name;
  final String duration;
  final bool isPlaying;
  final bool showMore;
  final VoidCallback onPlayPause;
  final VoidCallback onDelete;
  final VoidCallback? onMore;

  const RecordingListItem({
    Key? key,
    required this.name,
    required this.duration,
    required this.isPlaying,
    this.showMore = false,
    required this.onPlayPause,
    required this.onDelete,
    this.onMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Iconsax.microphone),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onPlayPause,
            child: Icon(
              isPlaying ? Iconsax.pause : Iconsax.play,
            ),
          ),
          if (showMore) ...[
            SizedBox(width: TSizes.md),
            GestureDetector(
              onTap: onMore,
              child: Icon(
                Icons.auto_awesome_sharp,
              ),
            ),
          ],
          SizedBox(width: TSizes.md),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Iconsax.trash,
            ),
          ),
        ],
      ),
    );
  }
}
