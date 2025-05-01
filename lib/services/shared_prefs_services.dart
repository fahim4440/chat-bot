import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class SharedPrefsServices {

  Future<void> saveUserInSharedPrefs(UserModel user) async {
    SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
            allowList: <String> {
              'uid',
              'displayName',
              'email',
              'photoUrl',
              'chatGPTKey',
              'grokAIKey',
              'geminiAIKey',
              'isLoggedIn'
            }
        )
    );

    prefsWithCache.setString('uid', user.uid);
    prefsWithCache.setString('displayName', user.name);
    prefsWithCache.setString('email', user.email);
    prefsWithCache.setString('photoUrl', user.photoUrl);
    prefsWithCache.setString('chatGPTKey', user.chatGPTKey ?? '');
    prefsWithCache.setString('grokAIKey', user.grokAIKey ?? '');
    prefsWithCache.setString('geminiAIKey', user.geminiAIKey ?? '');
    prefsWithCache.setBool('isLoggedIn', true);
  }

  Future<void> deleteUserFromSharedPrefs() async {
    SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
            allowList: <String> {
              'uid',
              'displayName',
              'email',
              'photoUrl',
              'chatGPTKey',
              'grokAIKey',
              'geminiAIKey',
              'isLoggedIn'
            }
        )
    );

    prefsWithCache.remove('uid');
    prefsWithCache.remove('displayName');
    prefsWithCache.remove('email');
    prefsWithCache.remove('photoUrl');
    prefsWithCache.remove('chatGPTKey');
    prefsWithCache.remove('grokAIKey');
    prefsWithCache.remove('geminiAIKey');
    prefsWithCache.remove('isLoggedIn');
  }

  Future<String> getUserUidFromSharedPrefs() async {
    SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
            allowList: <String> {
              'uid',
            }
        )
    );
    return prefsWithCache.getString('uid') ?? '';
  }

  Future<bool> getUserLoggedInfoFromSharedPrefs() async {
    SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
            allowList: <String> {
              'isLoggedIn',
            }
        )
    );
    return prefsWithCache.getBool('isLoggedIn') ?? false;
  }

  Future<String> getApiKeyFromSharedPrefs(String aiName) async {
    SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
        cacheOptions: SharedPreferencesWithCacheOptions(
            allowList: <String> {
              aiName,
            }
        )
    );
    return prefsWithCache.getString(aiName) ?? '';
  }

  Future<void> updateApiKeyInSharedPrefs(Map<String, String> apiKeys) async {
    SharedPreferencesWithCache prefsWithCache = await SharedPreferencesWithCache.create(
        cacheOptions: const SharedPreferencesWithCacheOptions(
            allowList: <String> {
              'chatGPTKey',
              'grokAIKey',
              'geminiAIKey',
            }
        )
    );
    prefsWithCache.setString('chatGPTKey', apiKeys['chatGPTKey'] ?? '');
    prefsWithCache.setString('grokAIKey', apiKeys['grokAIKey'] ?? '');
    prefsWithCache.setString('geminiAIKey', apiKeys['geminiAIKey'] ?? '');
  }
}