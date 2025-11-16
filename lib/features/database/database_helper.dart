import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('reader_app.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Assigned Areas Table
    await db.execute('''
      CREATE TABLE assigned_areas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meterNumber TEXT,
        ownerName TEXT,
        address TEXT,
        lastReading TEXT,
        status TEXT
      )
    ''');

    // Water Readings Table (Offline & Online)
    await db.execute('''
      CREATE TABLE water_readings(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meterNumber TEXT,
        readerCode TEXT,
        reading TEXT,
        notes TEXT,
        img TEXT, -- Base64 encoded image
        timestamp TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');
  }

  // -------------------- Assigned Areas --------------------

  Future<void> upsertAssignedAreas(List<Map<String, String>> areas) async {
    final db = await database;
    final batch = db.batch();
    for (var area in areas) {
      // Remove lastReading from the update map to preserve existing value
      final updateMap = Map<String, dynamic>.from(area)..remove('lastReading');
      
      batch.insert(
        'assigned_areas',
        updateMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getAssignedAreas() async {
    final db = await database;
    return await db.query('assigned_areas');
  }

  // -------------------- Water Readings --------------------

  Future<void> insertWaterReading(Map<String, dynamic> reading) async {
    final db = await database;
    await db.insert(
      'water_readings',
      reading,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertBatchWaterReadings(
    List<Map<String, dynamic>> readings,
  ) async {
    final db = await database;
    final batch = db.batch();
    for (var reading in readings) {
      batch.insert(
        'water_readings',
        reading,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getQueuedReadings({
    bool onlyUnsynced = true,
  }) async {
    final db = await database;
    if (onlyUnsynced) {
      return await db.query('water_readings', where: 'synced = 0');
    } else {
      return await db.query('water_readings');
    }
  }

  Future<void> markReadingsAsSynced(List<int> ids) async {
    final db = await database;
    final batch = db.batch();
    for (var id in ids) {
      batch.update(
        'water_readings',
        {'synced': 1},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<int> insertPendingReading(Map<String, dynamic> data) async {
    final db = await database;
    return db.insert("pending_readings", data);
  }

  Future<List<Map<String, dynamic>>> getPendingReadings() async {
    final db = await database;
    return db.query("pending_readings");
  }

  Future<int> deletePendingReading(int id) async {
    final db = await database;
    return db.delete("pending_readings", where: "id = ?", whereArgs: [id]);
  }

  // -------------------- Dashboard Stats --------------------
  Future<Map<String, int>> getDashboardStats() async {
    final db = await database;

    final totalAssigned =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM assigned_areas'),
        ) ??
        0;

    final completedAssigned =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM assigned_areas WHERE status = "Completed"',
          ),
        ) ??
        0;

    final unsyncedReadings =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(DISTINCT meterNumber) FROM water_readings WHERE synced = 0',
          ),
        ) ??
        0;

    final totalCompleted = completedAssigned + unsyncedReadings;
    final remaining = totalAssigned - totalCompleted;

    return {
      'assigned': totalAssigned,
      'completed': totalCompleted,
      'remaining': remaining < 0 ? 0 : remaining,
    };
  }

  // -------------------- Clear Database --------------------
  /// Clears all data from the database by deleting all tables
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('assigned_areas');
    await db.delete('water_readings');
  }

  // -------------------- Helpers --------------------
  /// Marks an assigned area as completed and updates its lastReading if provided.
  Future<void> markAreaCompleted(String meterNumber, {String? lastReading}) async {
    final db = await database;
    final values = <String, dynamic>{'status': 'Completed'};
    if (lastReading != null) values['lastReading'] = lastReading;

    await db.update(
      'assigned_areas',
      values,
      where: 'meterNumber = ?',
      whereArgs: [meterNumber],
    );
  }

  /// Returns the latest reading row for a given meterNumber (synced or unsynced)
  Future<Map<String, dynamic>?> getLatestReadingForMeter(String meterNumber) async {
    final db = await database;
    final results = await db.query(
      'water_readings',
      where: 'meterNumber = ?',
      whereArgs: [meterNumber],
      orderBy: 'id DESC',
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Deletes all rows from a specific table
  Future<void> delete(String tableName) async {
    final db = await database;
    await db.delete(tableName);
  }

}
