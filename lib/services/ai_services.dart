import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'shared_prefs_services.dart';

class AiServices {
  SharedPrefsServices prefsServices = SharedPrefsServices();

  Future<String> getAIResponse(String message, String aiName) async {
    if (aiName == "ChatGPT") {
      String chatGPTKey =
          await prefsServices.getApiKeyFromSharedPrefs('chatGPTKey');
      return await callChatGPTAPI(message, chatGPTKey);
    }
    if (aiName == "Grok AI") {
      String grokAIKey =
          await prefsServices.getApiKeyFromSharedPrefs('grokAIKey');
      return await callGrokAIAPI(message, grokAIKey);
    }
    if (aiName == "Gemini AI") {
      String geminiAIKey =
          await prefsServices.getApiKeyFromSharedPrefs('geminiAIKey');
      return await callGeminiAPI(message, geminiAIKey);
    }
    if (aiName == "ChatBot") {
      String apiKey = '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';
      return await callHuggingFace(message, apiKey);
    }
    throw Exception("❌ No API key found. Please add an API key in Profile Settings.");
  }

  Future<String> callChatGPTAPI(String message, String apiKey) async {
    final url = Uri.parse("https://api.openai.com/v1/chat/completions");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "messages": [
          {"role": "user", "content": message}
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["choices"][0]["message"]["content"];
    } else {
      throw Exception("⚠️ Error fetching response.");
    }
  }

  Future<String> callGrokAIAPI(String message, String apiKey) async {
    final url = Uri.parse("https://api.x.ai/v1/chat/completions");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'grok-beta', // Use 'grok-2' or others if available
        'messages': [
          {'role': 'user', 'content': message}
        ],
        'temperature': 0.7, // Controls creativity (0.0 to 1.0)
        'max_tokens': 200,  // Max response length
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['message']['content'];
    } else {
      throw Exception('Failed to get response: ${response.statusCode} - ${response.body}');
    }
  }

  Future<String> callGeminiAPI(String message, String apiKey) async {
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "contents": [
          {"parts": [{"text": message}]}
        ]
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      throw Exception("Failed to get response from Gemini API");
    }
  }

  Future<String> callHuggingFace(String message, String apiKey) async {
    const String huggingFaceModel = "tiiuae/falcon-7b-instruct";
    const String baseUrl = "https://api-inference.huggingface.co/models/";

    final url = Uri.parse("$baseUrl$huggingFaceModel");
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $apiKey",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"inputs": message}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      debugPrint(responseData[0]["generated_text"]);
      if (responseData.isNotEmpty) {
        String aiResponse =
            cleanResponse(responseData[0]["generated_text"], message);
        return aiResponse;
      } else {
        throw Exception("No response from AI.");
      }
    } else {
      throw Exception("Error: ${response.statusCode} - ${response.body}");
    }
  }

  String cleanResponse(String aiResponse, String userInput) {
    if (aiResponse.startsWith(userInput)) {
      return aiResponse
          .replaceFirst(userInput, "")
          .replaceFirst('.', '')
          .trim();
    }
    return aiResponse;
  }
}
