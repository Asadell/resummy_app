import 'package:flutter/foundation.dart';
import 'package:resummy_app/features/history/domain/entities/activity_item.dart';
import 'package:resummy_app/features/history/domain/repositories/history_repository.dart';
import 'package:resummy_app/features/auth/presentation/providers/auth_provider.dart';

enum HistoryFilter { all, cv, interview }

class HistoryProvider extends ChangeNotifier {
  final HistoryRepository _repository;
  final AuthProvider _authProvider;

  List<ActivityItem> _allActivities = [];
  List<ActivityItem> _filteredActivities = [];
  HistoryFilter _currentFilter = HistoryFilter.all;
  bool _isLoading = false;
  String? _currentUserId;

  HistoryProvider({
    required HistoryRepository repository,
    required AuthProvider authProvider,
  })  : _repository = repository,
        _authProvider = authProvider {
    _authProvider.addListener(_onAuthChanged);
    
    if (_authProvider.isAuthenticated) {
      _currentUserId = _authProvider.currentUser!.id;
      loadActivities();
    }
  }

  List<ActivityItem> get activities => _filteredActivities;
  HistoryFilter get filter => _currentFilter;
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
        _currentUserId = user.id;
        loadActivities();
      }
    } else {
      clear();
    }
  }

  Future<void> loadActivities() async {
    if (_currentUserId == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _allActivities = await _repository.getActivities(_currentUserId!);
      _applyFilter();
    } catch (e) {
      _allActivities = [];
      _filteredActivities = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(HistoryFilter filter) {
    if (_currentFilter == filter) return;
    _currentFilter = filter;
    _applyFilter();
  }

  void _applyFilter() {
    switch (_currentFilter) {
      case HistoryFilter.all:
        _filteredActivities = List.from(_allActivities);
        break;
      case HistoryFilter.cv:
        _filteredActivities =
            _allActivities.whereType<CvActivityItem>().toList();
        break;
      case HistoryFilter.interview:
        _filteredActivities =
            _allActivities.whereType<InterviewActivityItem>().toList();
        break;
    }
    notifyListeners();
  }

  void clear() {
    _allActivities = [];
    _filteredActivities = [];
    _currentUserId = null;
    notifyListeners();
  }
}
