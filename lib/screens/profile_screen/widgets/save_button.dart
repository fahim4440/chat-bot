import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/profile/profile_bloc.dart';
import '../../../widgets/custom_button.dart';

Center saveButton(
  BuildContext context,
  TextEditingController gptController,
  TextEditingController grokController,
  TextEditingController geminiController,
) {
  return Center(
    child: CustomButton(
      color: Colors.teal[900]!,
      text: 'Save Settings',
      onPressed: () {
        context.read<ProfileBloc>().add(UpdateProfileEvent({
              'chatGPTKey': gptController.text,
              'grokAIKey': grokController.text,
              'geminiAIKey': geminiController.text
            }));
      },
    ),
  );
}
