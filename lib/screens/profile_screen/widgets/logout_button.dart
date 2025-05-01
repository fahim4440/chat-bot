import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/profile/profile_bloc.dart';
import '../../../widgets/custom_button.dart';

Center logoutButton(BuildContext context) {
  return Center(
    child: CustomButton(
      text: 'Logout',
      onPressed: () {
        context.read<ProfileBloc>().add(LogoutEvent());
      },
      color: Colors.redAccent[100]!,
    ),
  );
}
