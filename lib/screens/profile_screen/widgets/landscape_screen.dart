import 'package:flutter/material.dart';

import '../../../blocs/profile/profile_bloc.dart';
import 'api_keys_form.dart';
import 'logout_button.dart';
import 'profile_picture.dart';
import 'save_button.dart';
import 'styled_card.dart';
import 'user_info.dart';

Row landscapeLayout(ProfileLoaded state, TextEditingController gptController, TextEditingController grokController, TextEditingController geminiController, BuildContext context,) {
  return Row(
    children: [
      Expanded(
        flex: 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profilePicture(state),
          ],
        ),
      ),

      /// 🎨 Styled Divider
      VerticalDivider(
        thickness: 2,
        width: 40,
        color: Colors.teal[600],
      ),

      Expanded(
        flex: 2,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              styledCard(userInfo(state)),
              const SizedBox(height: 16),
              styledCard(apiKeysForm(state, gptController, grokController,
                  geminiController, context)),
              const SizedBox(height: 20),
              saveButton(
                  context, gptController, grokController, geminiController),
              const SizedBox(height: 20),
              logoutButton(context),
            ],
          ),
        ),
      ),
    ],
  );
}
