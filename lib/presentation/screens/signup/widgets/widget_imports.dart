import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/presentation/router/router_imports.gr.dart';
import 'package:think_flow/presentation/screens/signup/bloc/signup_bloc.dart';
import 'package:think_flow/utils/popups/loaders.dart';

import '../../../../common/widgets/loading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/validators/validation.dart';

part 'signup_form.dart';
part 'signup_terms_conditions_checkbox.dart';