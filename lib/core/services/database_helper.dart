import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

/// Database helper for offline storage using SQLite
/// Manages local cache for CVs, analysis history, interviews, etc.
class DatabaseHelper {
  static Database? _database;
  static const String _databaseName = 'resummy_offline.db';
  static const int _databaseVersion = 1;

  // Table names
  static const String tableCVs = 'cvs';
  static const String tableAnalysisHistory = 'analysis_history';
  static const String tableInterviews = 'interviews';
  static const String tableTranslations = 'translations';
  static const String tableSyncQueue = 'sync_queue';

  /// Get database instance (singleton)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize database
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

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    debugPrint('🔨 Creating database tables...');

    // CVs table - stores CV metadata and JSON data
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

    // Analysis History table
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

    // Interviews table
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

    // Translations table
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

    // Sync Queue table - for pending operations when offline
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

    // Create indexes for faster queries
    await db.execute('CREATE INDEX idx_cvs_userId ON $tableCVs(userId)');
    await db.execute('CREATE INDEX idx_analysis_userId ON $tableAnalysisHistory(userId)');
    await db.execute('CREATE INDEX idx_interviews_userId ON $tableInterviews(userId)');
    await db.execute('CREATE INDEX idx_translations_userId ON $tableTranslations(userId)');
    await db.execute('CREATE INDEX idx_sync_queue_recordId ON $tableSyncQueue(recordId)');

    debugPrint('✅ Database tables created successfully');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    debugPrint('⬆️ Upgrading database from v$oldVersion to v$newVersion');
    
    // Add migration logic here when schema changes in future versions
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE $tableCVs ADD COLUMN newColumn TEXT');
    // }
  }

  /// Insert or update a record
  Future<void> upsert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Query records with optional filters
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

  /// Delete a record
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

  /// Clear all data from a table
  Future<void> clearTable(String table) async {
    final db = await database;
    await db.delete(table);
  }

  /// Add operation to sync queue (for offline mode)
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

  /// Get pending sync operations
  Future<List<Map<String, dynamic>>> getPendingSyncOperations() async {
    final db = await database;
    return await db.query(
      tableSyncQueue,
      orderBy: 'createdAt ASC',
    );
  }

  /// Remove from sync queue after successful sync
  Future<void> removeFromSyncQueue(int id) async {
    final db = await database;
    await db.delete(
      tableSyncQueue,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Close database connection
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
    debugPrint('🔒 Database connection closed');
  }
}
