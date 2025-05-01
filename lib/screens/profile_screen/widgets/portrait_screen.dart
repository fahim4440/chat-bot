import 'package:flutter/material.dart';

import '../../../blocs/profile/profile_bloc.dart';
import 'api_keys_form.dart';
import 'logout_button.dart';
import 'profile_picture.dart';
import 'save_button.dart';
import 'styled_card.dart';
import 'user_info.dart';

SingleChildScrollView portraitLayout(ProfileLoaded state, TextEditingController gptController, TextEditingController grokController, TextEditingController geminiController, BuildContext context,) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        profilePicture(state),
        const SizedBox(height: 16),
        styledCard(userInfo(state)),
        const SizedBox(height: 16),
        styledCard(apiKeysForm(
            state, gptController, grokController, geminiController, context)),
        const SizedBox(height: 20),
        saveButton(context, gptController, grokController, geminiController),
        const SizedBox(height: 20),
        logoutButton(context),
      ],
    ),
  );
}
