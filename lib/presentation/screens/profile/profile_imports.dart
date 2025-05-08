import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:think_flow/common/widgets/appbar/appbar.dart';
import 'package:think_flow/common/widgets/loading/loading.dart';
import 'package:think_flow/common/widgets/profile/t_circular_image.dart';
import 'package:think_flow/common/widgets/texts/section_heading.dart';
import 'package:think_flow/utils/constants/image_strings.dart';
import 'package:think_flow/utils/constants/sizes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think_flow/presentation/screens/profile/bloc/profile_bloc.dart';
import 'package:think_flow/utils/popups/loaders.dart';
import 'widgets/widget_imports.dart';

part 'profile.dart';
