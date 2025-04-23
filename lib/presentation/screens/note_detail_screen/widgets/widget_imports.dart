import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' show Delta, Document, QuillController, QuillEditor, QuillEditorConfig, QuillSimpleToolbar, QuillSimpleToolbarConfig;
import 'package:flutter_quill/quill_delta.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/common/widgets/empty/t_empty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think_flow/common/widgets/loading/loading.dart';
import 'package:just_audio/just_audio.dart';
import 'package:think_flow/presentation/screens/notes/widgets/audio_notes/widgets/audio_player_controls.dart';
import 'package:flutter_html/flutter_html.dart' as html;

import '../../../../common/widgets/texts/formatted_text.dart';
import '../../../../data/models/text_note_model.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/utils.dart';
import '../../notes/widgets/audio_notes/widgets/recording_list_item.dart';
import '../bloc/note_detail_bloc.dart';
import 'package:auto_route/auto_route.dart';

part 'text_detail_tab.dart';
part 'audio_detail_tab.dart';