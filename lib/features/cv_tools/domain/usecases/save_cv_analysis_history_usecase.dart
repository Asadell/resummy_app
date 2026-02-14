import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/core/errors/failures.dart';
import 'package:resummy_app/core/resources/data_state.dart';
import 'package:resummy_app/core/resources/use_case.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_history_repository.dart';

class SaveCvAnalysisHistoryParams {
  final CvAnalysisHistory history;

  SaveCvAnalysisHistoryParams({required this.history});
}

class SaveCvAnalysisHistoryUseCase
    implements UseCase<DataState<void>, SaveCvAnalysisHistoryParams> {
  final CvHistoryRepository _repository;

  SaveCvAnalysisHistoryUseCase(this._repository);

  @override
  Future<DataState<void>> call({SaveCvAnalysisHistoryParams? params}) async {
    if (params == null) {
      return const DataFailed(ServerFailure('Params cannot be null'));
    }

    try {
      await _repository.saveCvAnalysisHistory(params.history);
      return const DataSuccess(null);
    } on ServerException catch (e) {
      return DataFailed(ServerFailure(e.message));
    } on ConnectionException catch (e) {
      return DataFailed(ConnectionFailure(e.message));
    } catch (e) {
      return DataFailed(ServerFailure('Unknown error: $e'));
    }
  }
}
