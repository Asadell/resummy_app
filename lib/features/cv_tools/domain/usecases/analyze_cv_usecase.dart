import 'package:resummy_app/core/errors/exceptions.dart';
import 'package:resummy_app/core/errors/failures.dart';
import 'package:resummy_app/core/resources/data_state.dart';
import 'package:resummy_app/core/resources/use_case.dart';
import 'package:resummy_app/features/cv_tools/domain/entities/cv_analysis_entity.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_repository.dart';

class AnalyzeCvParams {
  final String role;
  final String cvText;
  final String language;

  AnalyzeCvParams({
    required this.role,
    required this.cvText,
    required this.language,
  });
}

class AnalyzeCvUseCase
    implements UseCase<DataState<CvAnalysisEntity>, AnalyzeCvParams> {
  final CvRepository _cvRepository;

  AnalyzeCvUseCase(this._cvRepository);

  @override
  Future<DataState<CvAnalysisEntity>> call({AnalyzeCvParams? params}) async {
    if (params == null) {
      return const DataFailed(ServerFailure('Params cannot be null'));
    }

    try {
      // Use Case bertanggung jawab convert Exception -> Failure
      final result = await _cvRepository.analyzeCv(
        params.cvText,
        params.role,
        params.language,
      );

      return DataSuccess(result);
    } on ServerException catch (e) {
      return DataFailed(ServerFailure(e.message));
    } on ConnectionException catch (e) {
      return DataFailed(ConnectionFailure(e.message));
    } on ParsingException catch (e) {
      return DataFailed(ParsingFailure(e.message));
    } catch (e) {
      return DataFailed(ServerFailure('Unknown error: $e'));
    }
  }
}
