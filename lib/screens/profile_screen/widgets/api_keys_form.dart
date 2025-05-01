import 'package:flutter/material.dart';

import '../../../blocs/profile/profile_bloc.dart';
import 'api_key_field.dart';

Column apiKeysForm(ProfileLoaded state, TextEditingController gptController, TextEditingController grokController, TextEditingController geminiController, BuildContext context,) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        apiKeyField(context, 'ChatGPT API Key', state.user.chatGPTKey ?? '', gptController),
        apiKeyField(context, 'GrokAI API Key', state.user.grokAIKey, grokController),
        apiKeyField(context, 'Gemini API Key', state.user.geminiAIKey, geminiController),
      ],
    );
  }