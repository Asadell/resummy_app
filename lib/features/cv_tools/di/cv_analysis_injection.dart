import 'package:get_it/get_it.dart';
import 'package:resummy_app/core/services/gemini_pool_manager.dart';
import 'package:resummy_app/core/services/database_helper.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_analysis_local_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_analysis_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/data_sources/cv_conversion_remote_data_source.dart';
import 'package:resummy_app/features/cv_tools/data/repositories/cv_analysis_repository_impl.dart';
import 'package:resummy_app/features/cv_tools/data/repositories/cv_conversion_repository_impl.dart';
import 'package:resummy_app/features/cv_tools/data/services/cv_ats_converter_service.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_analysis_repository.dart';
import 'package:resummy_app/features/cv_tools/domain/repositories/cv_conversion_repository.dart';
import 'package:resummy_app/features/cv_tools/presentation/providers/cv_analyzer_provider.dart';

Future<void> setupCvAnalysisAndConversionDI(GetIt getIt) async {
  getIt.registerLazySingleton<CvAtsConverterService>(
    () => CvAtsConverterService(),
  );

  getIt.registerLazySingleton<CVAnalysisRemoteDataSource>(
    () => CVAnalysisRemoteDataSource(getIt<GeminiPoolManager>()),
  );

  getIt.registerLazySingleton<CVAnalysisLocalDataSource>(
    () => CVAnalysisLocalDataSource(getIt<DatabaseHelper>()),
  );

  getIt.registerLazySingleton<CVConversionRemoteDataSource>(
    () => CVConversionRemoteDataSource(
      getIt<GeminiPoolManager>(),
      getIt<CvAtsConverterService>(),
    ),
  );

  getIt.registerLazySingleton<CVAnalysisRepository>(
    () => CVAnalysisRepositoryImpl(
      getIt<CVAnalysisRemoteDataSource>(),
      getIt<CVAnalysisLocalDataSource>(),
      getIt<CvAtsConverterService>(),
    ),
  );

  getIt.registerLazySingleton<CVConversionRepository>(
    () => CVConversionRepositoryImpl(
      getIt<CVConversionRemoteDataSource>(),
      getIt<CVLocalDataSource>(),
    ),
  );

  getIt.registerLazySingleton<CvAnalyzerProvider>(
    () => CvAnalyzerProvider(
      dataSource: getIt<CVAnalysisRemoteDataSource>(),
      converterService: getIt<CvAtsConverterService>(),
    ),
  );
}
