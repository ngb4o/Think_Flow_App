import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/common/widgets/empty/empty_widget.dart';
import 'package:think_flow/common/widgets/loading/loading.dart';
import 'package:think_flow/common/widgets/warning/t_warning_popup.dart';
import 'package:think_flow/presentation/screens/home/widgets/widget_imports.dart';
import 'package:think_flow/utils/constants/colors.dart';
import 'package:think_flow/utils/constants/sizes.dart';
import 'package:think_flow/utils/helpers/helper_functions.dart';

import '../../../common/widgets/appbar/home_appbar.dart';
import '../../../common/widgets/error/error_widget.dart';
import '../../../utils/popups/loaders.dart';
import '../../router/router_imports.gr.dart';
import '../../blocs/home/home_bloc.dart';

part 'home.dart';
