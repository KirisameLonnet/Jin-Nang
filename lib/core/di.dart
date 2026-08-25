import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'auth/token_store.dart';
import 'network/api_client.dart';
import 'audio/audio_cache_manager.dart';
import '../l10n/locale_controller.dart';

class Di {
  Di._();

  static final tokenStore = TokenStore();
  static final api = ApiClient(tokenStore);
  static final audioCache = AudioCacheManager();
  static final localeController = LocaleController();
  static final profileRevision = ValueNotifier<int>(0);

  // Set by main.dart after router is created, used by the 401 interceptor.
  static GoRouter? router;
}
