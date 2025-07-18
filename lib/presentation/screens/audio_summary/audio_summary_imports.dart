import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';
import 'package:think_flow/common/widgets/appbar/appbar.dart';
import 'package:think_flow/presentation/blocs/audio_summary/audio_summary_bloc.dart';
import 'package:think_flow/utils/constants/sizes.dart';

import '../../../common/widgets/create/create_widget.dart';
import '../../../common/widgets/loading/loading.dart';
import '../../../data/models/audio_note_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/utils.dart';
import '../notes/widgets/audio_notes/widgets/audio_player_controls.dart';

part 'audio_summary.dart';
