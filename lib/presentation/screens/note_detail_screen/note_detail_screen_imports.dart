import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/common/widgets/appbar/tabbar.dart';
import 'package:think_flow/presentation/screens/note_detail_screen/widgets/widget_imports.dart';
import 'package:think_flow/utils/constants/colors.dart';
import 'package:think_flow/utils/constants/sizes.dart';
import 'package:think_flow/utils/popups/loaders.dart';
import 'package:think_flow/utils/utils.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/loading/loading.dart';
import '../../../common/widgets/keep_alive_wrapper.dart';
import '../../../utils/constants/text_strings.dart';
import 'bloc/note_detail_bloc.dart';

part 'note_detail_screen.dart';
