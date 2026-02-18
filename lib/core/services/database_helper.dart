import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'resummy_offline.db';
  static const int _databaseVersion = 1;

  static const String tableCVs = 'cvs';
  static const String tableAnalysisHistory = 'analysis_history';
  static const String tableInterviews = 'interviews';
  static const String tableTranslations = 'translations';
  static const String tableSyncQueue = 'sync_queue';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    debugPrint('📂 Initializing SQLite database at: $path');

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    debugPrint('🔨 Creating database tables...');

    await db.execute('''
      CREATE TABLE $tableCVs (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        title TEXT,
        source TEXT,
        data TEXT NOT NULL,
        pdfUrl TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        syncStatus TEXT DEFAULT 'synced'
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableAnalysisHistory (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        cvId TEXT,
        analysisData TEXT NOT NULL,
        score INTEGER,
        createdAt INTEGER NOT NULL,
        syncStatus TEXT DEFAULT 'synced'
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableInterviews (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        cvId TEXT,
        sessionData TEXT NOT NULL,
        reportData TEXT,
        status TEXT,
        createdAt INTEGER NOT NULL,
        updatedAt INTEGER NOT NULL,
        syncStatus TEXT DEFAULT 'synced'
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableTranslations (
        id TEXT PRIMARY KEY,
        userId TEXT NOT NULL,
        originalCvId TEXT,
        translationData TEXT NOT NULL,
        fromLang TEXT,
        toLang TEXT,
        pdfUrl TEXT,
        createdAt INTEGER NOT NULL,
        syncStatus TEXT DEFAULT 'synced'
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableSyncQueue (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        operation TEXT NOT NULL,
        tableName TEXT NOT NULL,
        recordId TEXT NOT NULL,
        data TEXT NOT NULL,
        createdAt INTEGER NOT NULL,
        retryCount INTEGER DEFAULT 0
      )
    ''');

    await db.execute('CREATE INDEX idx_cvs_userId ON $tableCVs(userId)');
    await db.execute(
        'CREATE INDEX idx_analysis_userId ON $tableAnalysisHistory(userId)');
    await db.execute(
        'CREATE INDEX idx_interviews_userId ON $tableInterviews(userId)');
    await db.execute(
        'CREATE INDEX idx_translations_userId ON $tableTranslations(userId)');
    await db.execute(
        'CREATE INDEX idx_sync_queue_recordId ON $tableSyncQueue(recordId)');

    debugPrint('✅ Database tables created successfully');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('⬆️ Upgrading database from v$oldVersion to v$newVersion');
  }

  Future<void> upsert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> delete(
    String table, {
    required String where,
    required List<Object?> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(
      table,
      where: where,
      whereArgs: whereArgs,
    );
  }

  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  Future<void> addToSyncQueue({
    required String operation,
    required String tableName,
    required String recordId,
    required Map<String, dynamic> data,
  }) async {
    final db = await database;
    await db.insert(tableSyncQueue, {
      'operation': operation,
      'tableName': tableName,
      'recordId': recordId,
      'data': data.toString(),
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'retryCount': 0,
    });
    debugPrint('📝 Added to sync queue: $operation on $tableName/$recordId');
  }

  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    final db = await database;
    return await db.query(
      tableSyncQueue,
      orderBy: 'createdAt ASC',
    );
  }

  Future<void> removeFromSyncQueue(int id) async {
    final db = await database;
    await db.delete(
      tableSyncQueue,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    debugPrint('🔒 Database connection closed');
  }
}
