import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/presentation/router/router_imports.gr.dart';
import 'package:think_flow/presentation/screens/notification/bloc/notification_bloc.dart';
import 'package:think_flow/utils/constants/colors.dart';
import 'package:think_flow/utils/constants/sizes.dart';
import 'package:think_flow/utils/utils.dart';

import '../../../common/widgets/empty/empty_widget.dart';
import '../../../common/widgets/loading/loading.dart';
import '../../../utils/popups/loaders.dart';

part 'notification.dart';
