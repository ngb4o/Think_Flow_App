import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax/iconsax.dart';
import 'package:think_flow/presentation/router/router_imports.gr.dart';
import 'package:think_flow/presentation/screens/login/bloc/login_bloc.dart';
import 'package:think_flow/utils/popups/loaders.dart';
import 'package:think_flow/utils/utils.dart';

import '../../../../common/widgets/loading/loading.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';

part 'login_header.dart';
part 'login_form.dart';