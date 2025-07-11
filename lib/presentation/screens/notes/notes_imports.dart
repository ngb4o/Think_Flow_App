import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/presentation/blocs/home/home_bloc.dart';
import 'package:think_flow/presentation/blocs/note/notes_bloc.dart';
import 'package:think_flow/presentation/screens/notes/widgets/audio_notes/audio_notes_imports.dart';
import 'package:think_flow/presentation/screens/notes/widgets/text_notes/text_notes_imports.dart';
import 'package:think_flow/utils/helpers/helper_functions.dart';
import 'package:think_flow/utils/popups/loaders.dart';
import '../../../common/widgets/appbar/appbar.dart';
import '../../../common/widgets/keep_alive_wrapper.dart';
import '../../../common/widgets/loading/loading.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_strings.dart';

part 'notes.dart';
