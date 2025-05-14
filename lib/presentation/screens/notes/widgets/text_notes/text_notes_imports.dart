import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_quill/flutter_quill.dart' show Document, QuillController, QuillEditor, QuillEditorConfig, QuillSimpleToolbar, QuillSimpleToolbarConfig;
import 'package:iconsax/iconsax.dart';

import '../../../../../services/text_recognizer.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../utils/popups/loaders.dart';
import '../../../../../utils/utils.dart';
import '../../bloc/notes_bloc.dart';

part 'text_notes.dart';
