import 'package:flutter/foundation.dart';
import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repository;
  final AuthProvider _authProvider;
  
  List<ActivityEntity> _activities = [];
  bool _isLoading = false;
  String? _currentUserId;

  HistoryProvider({
    required HistoryRepository repository,
    required AuthProvider authProvider,
  }) : _repository = repository,
       _authProvider = authProvider {
    _authProvider.addListener(_onAuthChanged);
    _onAuthChanged();
  }

  List<ActivityEntity> get activities => _activities;
  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  void _onAuthChanged() {
    final user = _authProvider.currentUser;
    if (user != null) {
      if (_currentUserId != user.id) {
        loadActivities(user.id);
      }
    } else {
      clear();
    }
  }

  Future<void> loadActivities(String userId) async {
    // Avoid reloading if same user and already loaded, unless refresh requested
    if (_currentUserId == userId && _activities.isNotEmpty) return;
    
    _currentUserId = userId;
    await _fetchActivities();
  }

  Future<void> refresh() async {
    if (_currentUserId == null) return;
    await _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    if (_currentUserId == null) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      _activities = await _repository.getActivities(userId: _currentUserId!);
    } catch (e) {
      debugPrint('Error loading history: $e');
      _activities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _activities = [];
    _currentUserId = null;
    notifyListeners();
  }
}

