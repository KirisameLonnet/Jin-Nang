import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocaleController extends ValueNotifier<Locale?> {
  LocaleController() : super(null);

  static const _storageKey = 'app_locale';
  final _storage = const FlutterSecureStorage();

  Future<void> load() async {
    try {
      final languageCode = await _storage.read(key: _storageKey);
      value = switch (languageCode) {
        'en' => const Locale('en'),
        'zh' => const Locale('zh'),
        _ => null,
      };
    } catch (_) {
      value = null;
    }
  }

  Future<void> setLocale(Locale? locale) async {
    value = locale;
    try {
      if (locale == null) {
        await _storage.delete(key: _storageKey);
      } else {
        await _storage.write(key: _storageKey, value: locale.languageCode);
      }
    } catch (_) {
      // The UI language still changes for this session if storage is unavailable.
    }
  }
}
