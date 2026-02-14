import 'package:flutter/foundation.dart';
import 'package:resummy_app/core/resources/data_state.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/usecases/get_cv_analysis_history_usecase.dart';
import 'package:resummy_app/features/cv_tools/domain/usecases/save_cv_analysis_history_usecase.dart';
import 'package:resummy_app/features/cv_tools/domain/usecases/delete_cv_analysis_history_usecase.dart';

enum HistoryFilter { all, cvAnalyzer, cvBuilder, cvTranslator }

enum HistorySortOrder { newestFirst, oldestFirst }

class CvHistoryProvider extends ChangeNotifier {
  final SaveCvAnalysisHistoryUseCase _saveHistoryUseCase;
  final GetCvAnalysisHistoryUseCase _getHistoryUseCase;
  final DeleteCvAnalysisHistoryUseCase _deleteHistoryUseCase;

  CvHistoryProvider({
    required SaveCvAnalysisHistoryUseCase saveHistoryUseCase,
    required GetCvAnalysisHistoryUseCase getHistoryUseCase,
    required DeleteCvAnalysisHistoryUseCase deleteHistoryUseCase,
  })  : _saveHistoryUseCase = saveHistoryUseCase,
        _getHistoryUseCase = getHistoryUseCase,
        _deleteHistoryUseCase = deleteHistoryUseCase;

  List<CvAnalysisHistory> _historyList = [];
  bool _isLoading = false;
  String _errorMessage = '';
  HistoryFilter _currentFilter = HistoryFilter.all;
  HistorySortOrder _currentSort = HistorySortOrder.newestFirst;

  List<CvAnalysisHistory> get historyList => _getFilteredAndSortedHistory();
  List<CvAnalysisHistory> get rawHistoryList => _historyList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  HistoryFilter get currentFilter => _currentFilter;
  HistorySortOrder get currentSort => _currentSort;

  List<CvAnalysisHistory> _getFilteredAndSortedHistory() {
    List<CvAnalysisHistory> filtered = _historyList;

    // Apply filter (for now, only CV Analyzer exists, but ready for future)
    switch (_currentFilter) {
      case HistoryFilter.cvAnalyzer:
        // All current history is CV Analyzer
        break;
      case HistoryFilter.cvBuilder:
        // TODO: Filter for CV Builder when implemented
        filtered = [];
        break;
      case HistoryFilter.cvTranslator:
        // TODO: Filter for CV Translator when implemented
        filtered = [];
        break;
      case HistoryFilter.all:
        break;
    }

    // Apply sorting
    List<CvAnalysisHistory> sorted = List.from(filtered);
    switch (_currentSort) {
      case HistorySortOrder.newestFirst:
        sorted.sort((a, b) => b.analyzedAt.compareTo(a.analyzedAt));
        break;
      case HistorySortOrder.oldestFirst:
        sorted.sort((a, b) => a.analyzedAt.compareTo(b.analyzedAt));
        break;
    }

    return sorted;
  }

  void setFilter(HistoryFilter filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  void setSortOrder(HistorySortOrder sort) {
    _currentSort = sort;
    notifyListeners();
  }

  Future<bool> saveCvAnalysisHistory(CvAnalysisHistory history) async {
    _errorMessage = '';

    try {
      final result = await _saveHistoryUseCase.call(
        params: SaveCvAnalysisHistoryParams(history: history),
      );

      if (result is DataSuccess) {
        return true;
      } else if (result is DataFailed) {
        _errorMessage = result.error?.message ?? 'Failed to save history';
        notifyListeners();
        return false;
      }

      return false;
    } catch (e) {
      _errorMessage = 'Failed to save history: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> loadCvAnalysisHistory(String userId) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final result = await _getHistoryUseCase.call(
        params: GetCvAnalysisHistoryParams(userId: userId),
      );

      if (result is DataSuccess) {
        _historyList = result.data ?? [];
      } else if (result is DataFailed) {
        _errorMessage = result.error?.message ?? 'Failed to load history';
      }
    } catch (e) {
      _errorMessage = 'Failed to load history: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCvAnalysisHistory(String id) async {
    _errorMessage = '';

    try {
      final result = await _deleteHistoryUseCase.call(
        params: DeleteCvAnalysisHistoryParams(id: id),
      );

      if (result is DataSuccess) {
        _historyList.removeWhere((history) => history.id == id);
        notifyListeners();
        return true;
      } else if (result is DataFailed) {
        _errorMessage = result.error?.message ?? 'Failed to delete history';
        notifyListeners();
        return false;
      }

      return false;
    } catch (e) {
      _errorMessage = 'Failed to delete history: $e';
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
