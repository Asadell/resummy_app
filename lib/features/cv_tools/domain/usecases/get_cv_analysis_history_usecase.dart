import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/core/errors/failures.dart';
import 'package:resummy_app/core/resources/data_state.dart';
import 'package:resummy_app/core/resources/use_case.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_history_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_history_repository.dart';

class GetCvAnalysisHistoryParams {
  final String userId;

  GetCvAnalysisHistoryParams({required this.userId});
}

class GetCvAnalysisHistoryUseCase
    implements UseCase<DataState<List<CvAnalysisHistory>>, GetCvAnalysisHistoryParams> {
  final CvHistoryRepository _repository;

  GetCvAnalysisHistoryUseCase(this._repository);

  @override
  Future<DataState<List<CvAnalysisHistory>>> call({GetCvAnalysisHistoryParams? params}) async {
    if (params == null) {
      return const DataFailed(ServerFailure('Params cannot be null'));
    }

    try {
      final historyList = await _repository.getCvAnalysisHistoryList(params.userId);
      return DataSuccess(historyList);
    } on ServerException catch (e) {
      return DataFailed(ServerFailure(e.message));
    } on ConnectionException catch (e) {
      return DataFailed(ConnectionFailure(e.message));
    } catch (e) {
      return DataFailed(ServerFailure('Unknown error: $e'));
    }
  }
}
