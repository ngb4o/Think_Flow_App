import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:think_flow/common/widgets/appbar/appbar.dart';
import 'package:think_flow/common/widgets/create/create_widget.dart';
import 'package:think_flow/presentation/blocs/audio_transcrip/audio_transcript_bloc.dart';
import 'package:think_flow/utils/constants/sizes.dart';

import '../../../common/widgets/loading/loading.dart';
import '../../../data/models/audio_note_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/popups/loaders.dart';
import '../notes/widgets/audio_notes/widgets/audio_player_controls.dart';

part 'audio_transcript.dart';
