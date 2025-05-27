import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/data/models/text_note_model.dart';
import 'package:think_flow/presentation/screens/text_summary/bloc/bloc/text_summary_bloc.dart';
import 'package:think_flow/utils/constants/colors.dart';
import 'package:think_flow/utils/constants/sizes.dart';
import 'package:think_flow/utils/helpers/helper_functions.dart';
import 'package:think_flow/common/widgets/appbar/appbar.dart';
import 'package:think_flow/common/widgets/loading/loading.dart';

import '../../../common/widgets/create/create_widget.dart';
import '../../../common/widgets/empty/empty_widget.dart';
import '../../../utils/popups/loaders.dart';
import '../../../utils/utils.dart';
part 'text_summary.dart';
