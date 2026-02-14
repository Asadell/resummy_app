import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/core/errors/failures.dart';
import 'package:resummy_app/core/resources/data_state.dart';
import 'package:resummy_app/core/resources/use_case.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_history_repository.dart';

class DeleteCvAnalysisHistoryParams {
  final String id;

  DeleteCvAnalysisHistoryParams({required this.id});
}

class DeleteCvAnalysisHistoryUseCase
    implements UseCase<DataState<void>, DeleteCvAnalysisHistoryParams> {
  final CvHistoryRepository _repository;

  DeleteCvAnalysisHistoryUseCase(this._repository);

  @override
  Future<DataState<void>> call({DeleteCvAnalysisHistoryParams? params}) async {
    if (params == null) {
      return const DataFailed(ServerFailure('Params cannot be null'));
    }

    try {
      await _repository.deleteCvAnalysisHistory(params.id);
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
