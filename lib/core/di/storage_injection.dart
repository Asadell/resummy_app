import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resummy_app/core/services/do_spaces_service.dart';
import 'package:resummy_app/core/services/database_helper.dart';

Future<void> setupStorageDI(GetIt getIt) async {
  getIt.registerLazySingleton<FirebaseFirestore>(
    () => FirebaseFirestore.instance,
  );

  getIt.registerLazySingleton<DOSpacesService>(
    () => DOSpacesService(),
  );

  getIt.registerLazySingleton<DatabaseHelper>(
    () => DatabaseHelper(),
  );
}
