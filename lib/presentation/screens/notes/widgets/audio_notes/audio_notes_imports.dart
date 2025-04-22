import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:think_flow/common/widgets/empty/t_empty.dart';
import 'package:think_flow/presentation/screens/notes/bloc/notes_bloc.dart';
import 'package:think_flow/utils/popups/loaders.dart';

import '../../../../../../utils/constants/colors.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../../../utils/audio_utils.dart';
import '../../../../../data/models/audio_recording_model.dart';
import 'widgets/recording_controls.dart';
import 'widgets/audio_player_controls.dart';
import 'widgets/recording_list_item.dart';

part 'audio_notes.dart';
