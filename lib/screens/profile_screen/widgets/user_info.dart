import 'package:flutter/material.dart';

import '../../../blocs/profile/profile_bloc.dart';
import 'styled_text.dart';

Column userInfo(ProfileLoaded state) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      styledText("Name:", state.user.name),
      styledText("Email:", state.user.email),
    ],
  );
}
