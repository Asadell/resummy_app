import 'package:flutter/foundation.dart';
import 'package:resummy_app/features/history/domain/entities/activity_entity.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repository;
  
  List<ActivityEntity> _activities = [];
  bool _isLoading = false;
  String? _currentUserId;

  HistoryProvider(this._repository);

  List<ActivityEntity> get activities => _activities;
  bool get isLoading => _isLoading;

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

