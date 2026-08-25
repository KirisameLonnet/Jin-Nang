import 'package:dio/dio.dart';
import '../auth/token_store.dart';
import '../di.dart';
import '../models/user.dart';
import '../models/scene.dart';
import '../models/vocab.dart';
import '../models/level.dart';
import '../models/phrase.dart';

class ApiClient {
  static const _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://jntest.lonnet.uk',
  );

  final Dio _dio;
  final TokenStore _tokenStore;

  ApiClient(this._tokenStore)
    : _dio = Dio(
        BaseOptions(
          baseUrl: _baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _tokenStore.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await _tokenStore.clearToken();
            Di.router?.go('/login');
          }
          handler.next(error);
        },
      ),
    );
  }

  // ── Auth ─────────────────────────────────────────────

  Future<String> login(String email, String password) async {
    final res = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return res.data['token'] as String;
  }

  Future<String> register(
    String email,
    String password,
    String displayName,
  ) async {
    final res = await _dio.post(
      '/auth/register',
      data: {'email': email, 'password': password, 'display_name': displayName},
    );
    return res.data['token'] as String;
  }

  Future<UserProfile> getMe() async {
    final res = await _dio.get('/auth/me');
    return UserProfile.fromJson(res.data as Map<String, dynamic>);
  }

  // ── Scenes ───────────────────────────────────────────

  Future<List<Scene>> getScenes() async {
    final res = await _dio.get('/scenes');
    return (res.data as List)
        .map((e) => Scene.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Vocab ────────────────────────────────────────────

  Future<List<VocabItem>> getSceneVocab(int sceneId) async {
    final res = await _dio.get('/scenes/$sceneId/vocab');
    return (res.data as List)
        .map((e) => VocabItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<VocabDetail> getVocabDetail(int vocabId) async {
    final res = await _dio.get('/vocab/$vocabId');
    return VocabDetail.fromJson(res.data as Map<String, dynamic>);
  }

  Future<Topic> getScenePhrases(int sceneId) async {
    final res = await _dio.get('/scenes/$sceneId/phrases');
    return Topic.fromJson(res.data as Map<String, dynamic>);
  }

  Future<void> markVocabSeen(Iterable<int> vocabIds) async {
    final ids = vocabIds.toSet().toList();
    if (ids.isEmpty) return;
    await _dio.post('/user/vocab-seen', data: {'vocab_ids': ids});
    Di.profileRevision.value++;
  }

  // ── Levels ───────────────────────────────────────────

  Future<List<Level>> getSceneLevels(int sceneId) async {
    final res = await _dio.get('/scenes/$sceneId/levels');
    return (res.data as List)
        .map((e) => Level.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Progress ─────────────────────────────────────────

  Future<void> submitProgress(int levelId, int score) async {
    await _dio.post(
      '/user/progress',
      data: {'level_id': levelId, 'score': score},
    );
    Di.profileRevision.value++;
  }
}
