import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../models/trade_models.dart';

class LocalDatabaseService {
  LocalDatabaseService._internal();
  static final LocalDatabaseService instance = LocalDatabaseService._internal();

  Database? _db;
  bool _isInitialized = false;
  bool _isUsingSqlite = false;

  // In-memory / file fallback storage for environments without native SQLite binaries
  final Map<String, Map<String, dynamic>> _fallbackUsers = {};
  final Map<String, String> _fallbackPreferences = {};
  final List<Map<String, dynamic>> _fallbackLoginLogs = [];
  final Map<String, Map<String, dynamic>> _fallbackDocuments = {};
  final Map<String, Map<String, dynamic>> _fallbackClients = {};

  bool get isConnected => _isInitialized;
  bool get isSqlite => _isUsingSqlite;
  String get databaseEngine => _isUsingSqlite ? 'SQLite Local DB (sqflite)' : 'Local Secure Key-Value DB';

  /// Initialize the local database connection
  Future<void> initialize() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      _initFallbackStorage();
      _isUsingSqlite = false;
      _isInitialized = true;
      debugPrint('LocalDatabaseService: Web platform detected — running high-speed reactive local engine.');
      return;
    }

    try {
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }

      final docsDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(docsDir.path, 'tradelink_local.db');

      _db = await openDatabase(
        dbPath,
        version: 1,
        onCreate: (Database db, int version) async {
          // Users Table
          await db.execute('''
            CREATE TABLE users (
              user_id TEXT PRIMARY KEY,
              email TEXT UNIQUE NOT NULL,
              password TEXT NOT NULL,
              full_name TEXT NOT NULL,
              company_name TEXT NOT NULL,
              phone TEXT,
              role TEXT NOT NULL,
              account_tier TEXT,
              dark_mode INTEGER DEFAULT 0,
              created_at TEXT,
              last_login TEXT
            )
          ''');

          // App Settings & Preferences Table
          await db.execute('''
            CREATE TABLE app_preferences (
              pref_key TEXT PRIMARY KEY,
              pref_value TEXT NOT NULL
            )
          ''');

          // Login & Audit Logs Table
          await db.execute('''
            CREATE TABLE login_logs (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              email TEXT NOT NULL,
              role TEXT NOT NULL,
              status TEXT NOT NULL,
              timestamp TEXT NOT NULL
            )
          ''');

          // Trade Documents & Compliance Files Table
          await db.execute('''
            CREATE TABLE trade_documents (
              doc_id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              file_name TEXT NOT NULL,
              category TEXT NOT NULL,
              size_kb INTEGER NOT NULL,
              status TEXT NOT NULL,
              upload_date TEXT NOT NULL,
              order_number TEXT NOT NULL
            )
          ''');

          // Clients / Traders Directory Table
          await db.execute('''
            CREATE TABLE clients (
              client_id TEXT PRIMARY KEY,
              company_name TEXT NOT NULL,
              country TEXT NOT NULL,
              country_code TEXT NOT NULL,
              role TEXT NOT NULL,
              status TEXT NOT NULL,
              contact_person TEXT NOT NULL,
              email TEXT NOT NULL,
              phone TEXT NOT NULL,
              trade_license TEXT NOT NULL,
              payment_terms TEXT NOT NULL,
              total_deals INTEGER NOT NULL,
              trade_volume_usd REAL NOT NULL,
              rating REAL NOT NULL,
              notes TEXT
            )
          ''');

          // Seed default user accounts
          await _seedDefaultUsers(db);
          await _seedDefaultClients(db);
        },
      );

      // Ensure tables exist if database was created with an earlier schema
      await _db!.execute('''
        CREATE TABLE IF NOT EXISTS trade_documents (
          doc_id TEXT PRIMARY KEY,
          title TEXT NOT NULL,
          file_name TEXT NOT NULL,
          category TEXT NOT NULL,
          size_kb INTEGER NOT NULL,
          status TEXT NOT NULL,
          upload_date TEXT NOT NULL,
          order_number TEXT NOT NULL
        )
      ''');

      await _db!.execute('''
        CREATE TABLE IF NOT EXISTS clients (
          client_id TEXT PRIMARY KEY,
          company_name TEXT NOT NULL,
          country TEXT NOT NULL,
          country_code TEXT NOT NULL,
          role TEXT NOT NULL,
          status TEXT NOT NULL,
          contact_person TEXT NOT NULL,
          email TEXT NOT NULL,
          phone TEXT NOT NULL,
          trade_license TEXT NOT NULL,
          payment_terms TEXT NOT NULL,
          total_deals INTEGER NOT NULL,
          trade_volume_usd REAL NOT NULL,
          rating REAL NOT NULL,
          notes TEXT
        )
      ''');

      // Ensure default users have latest credentials and tables exist
      await _syncSeededUsers(_db!);
      await _syncSeededClients(_db!);

      _isUsingSqlite = true;
      _isInitialized = true;
      debugPrint('LocalDatabaseService: SQLite connected successfully at $dbPath');
    } catch (e) {
      debugPrint('LocalDatabaseService: SQLite init fallback to local memory/file engine: $e');
      _initFallbackStorage();
      _isUsingSqlite = false;
      _isInitialized = true;
    }
  }

  Future<void> _seedDefaultUsers(Database db) async {
    final now = DateTime.now().toIso8601String();
    final batch = db.batch();

    // 1. Commission Agent
    batch.insert(
      'users',
      {
        'user_id': 'usr-001',
        'email': 'awais@tradelink.pk',
        'password': 'awais2284\$#@A',
        'full_name': 'Awais Ahmad',
        'company_name': 'Noor Trader',
        'phone': '03226808199',
        'role': 'agent',
        'account_tier': 'Premium Agent',
        'dark_mode': 0,
        'created_at': now,
        'last_login': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 2. Importer
    batch.insert(
      'users',
      {
        'user_id': 'usr-002',
        'email': 'ahmed@alnoor.ae',
        'password': 'awais2284\$#@A',
        'full_name': 'Ahmed Al Noor',
        'company_name': 'Al Noor Traders LLC',
        'phone': '03226808199',
        'role': 'importer',
        'account_tier': 'Verified Importer',
        'dark_mode': 0,
        'created_at': now,
        'last_login': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 3. Exporter
    batch.insert(
      'users',
      {
        'user_id': 'usr-003',
        'email': 'sales@shenzhentech.cn',
        'password': 'awais2284\$#@A',
        'full_name': 'Li Wei',
        'company_name': 'Shenzhen Tech Ltd',
        'phone': '03226808199',
        'role': 'exporter',
        'account_tier': 'Verified Exporter',
        'dark_mode': 0,
        'created_at': now,
        'last_login': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 4. Platform Administrator
    batch.insert(
      'users',
      {
        'user_id': 'usr-000',
        'email': 'admin@tradelink.pk',
        'password': 'awais2284\$#@A',
        'full_name': 'Master Administrator',
        'company_name': 'TradeLink Global Authority',
        'phone': '03226808199',
        'role': 'admin',
        'account_tier': 'Superadmin',
        'dark_mode': 0,
        'created_at': now,
        'last_login': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Default theme preference
    batch.insert(
      'app_preferences',
      {'pref_key': 'dark_mode', 'pref_value': 'false'},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    await batch.commit(noResult: true);
  }

  /// Sync seeded users into existing SQLite database if password or phone needs update
  Future<void> _syncSeededUsers(Database db) async {
    final now = DateTime.now().toIso8601String();
    final batch = db.batch();

    final seeded = [
      {
        'user_id': 'usr-001',
        'email': 'awais@tradelink.pk',
        'password': 'awais2284\$#@A',
        'full_name': 'Awais Ahmad',
        'company_name': 'Noor Trader',
        'phone': '03226808199',
        'role': 'agent',
        'account_tier': 'Premium Agent',
      },
      {
        'user_id': 'usr-002',
        'email': 'ahmed@alnoor.ae',
        'password': 'awais2284\$#@A',
        'full_name': 'Ahmed Al Noor',
        'company_name': 'Al Noor Traders LLC',
        'phone': '03226808199',
        'role': 'importer',
        'account_tier': 'Verified Importer',
      },
      {
        'user_id': 'usr-003',
        'email': 'sales@shenzhentech.cn',
        'password': 'awais2284\$#@A',
        'full_name': 'Li Wei',
        'company_name': 'Shenzhen Tech Ltd',
        'phone': '03226808199',
        'role': 'exporter',
        'account_tier': 'Verified Exporter',
      },
      {
        'user_id': 'usr-000',
        'email': 'admin@tradelink.pk',
        'password': 'awais2284\$#@A',
        'full_name': 'Master Administrator',
        'company_name': 'TradeLink Global Authority',
        'phone': '03226808199',
        'role': 'admin',
        'account_tier': 'Superadmin',
      },
    ];

    for (final u in seeded) {
      batch.insert(
        'users',
        {
          ...u,
          'dark_mode': 0,
          'created_at': now,
          'last_login': now,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<void> _seedDefaultClients(Database db) async {
    final batch = db.batch();
    for (final c in _getDefaultSeedClients()) {
      batch.insert(
        'clients',
        {
          'client_id': c.clientId,
          'company_name': c.companyName,
          'country': c.country,
          'country_code': c.countryCode,
          'role': c.role,
          'status': c.status,
          'contact_person': c.contactPerson,
          'email': c.email,
          'phone': c.phone,
          'trade_license': c.tradeLicense,
          'payment_terms': c.paymentTerms,
          'total_deals': c.totalDeals,
          'trade_volume_usd': c.tradeVolumeUsd,
          'rating': c.rating,
          'notes': c.notes.join('||'),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> _syncSeededClients(Database db) async {
    final countResult = await db.rawQuery('SELECT COUNT(*) as cnt FROM clients');
    final count = countResult.isNotEmpty ? (countResult.first['cnt'] as int? ?? 0) : 0;
    if (count == 0) {
      await _seedDefaultClients(db);
    }
  }

  List<ClientModel> _getDefaultSeedClients() {
    return [
      ClientModel(
        clientId: 'cli-001',
        companyName: 'Al Noor Traders LLC',
        country: 'Dubai, UAE',
        countryCode: 'AE',
        role: 'Importer',
        status: 'Active',
        contactPerson: 'Mr. Ahmed Al Noor',
        email: 'ahmed@alnoor.ae',
        phone: '+971 50 123 4567',
        tradeLicense: 'DED-882341',
        paymentTerms: 'LC at sight / 30 days',
        totalDeals: 18,
        tradeVolumeUsd: 240000.0,
        rating: 4.8,
        notes: [
          'Prefers CIF Dubai terms for electronics shipments.',
          'Requested prompt notice on vessel departures.',
          'Solid payment history with Emirates NBD letters of credit.'
        ],
      ),
      ClientModel(
        clientId: 'cli-002',
        companyName: 'Shenzhen Tech Ltd',
        country: 'Shenzhen, China',
        countryCode: 'CN',
        role: 'Exporter',
        status: 'Active',
        contactPerson: 'Mr. Li Wei',
        email: 'sales@shenzhentech.cn',
        phone: '+86 755 8899 1234',
        tradeLicense: 'CN-SZ-90412',
        paymentTerms: 'TT 30% advance, 70% against B/L',
        totalDeals: 24,
        tradeVolumeUsd: 410000.0,
        rating: 5.0,
        notes: ['Gold rated manufacturer for LED fixtures and power banks.'],
      ),
      ClientModel(
        clientId: 'cli-003',
        companyName: 'Hamburg Goods GmbH',
        country: 'Hamburg, Germany',
        countryCode: 'DE',
        role: 'Importer',
        status: 'Active',
        contactPerson: 'Hans Richter',
        email: 'h.richter@hamburggoods.de',
        phone: '+49 40 7654 3210',
        tradeLicense: 'HRB-67219',
        paymentTerms: 'LC at sight',
        totalDeals: 12,
        tradeVolumeUsd: 185000.0,
        rating: 4.9,
        notes: ['Regular buyer of Basmati Rice 25kg packaging.'],
      ),
      ClientModel(
        clientId: 'cli-004',
        companyName: 'Gulf Builders Corp',
        country: 'Riyadh, Saudi Arabia',
        countryCode: 'SA',
        role: 'Importer',
        status: 'Active',
        contactPerson: 'Faisal Al-Otaibi',
        email: 'faisal@gulfbuilders.sa',
        phone: '+966 11 445 6789',
        tradeLicense: 'CR-1010892',
        paymentTerms: 'Telegraphic Transfer',
        totalDeals: 15,
        tradeVolumeUsd: 310000.0,
        rating: 4.7,
        notes: ['Contracts high volume structural steel rebar.'],
      ),
      ClientModel(
        clientId: 'cli-005',
        companyName: 'London Textiles Co.',
        country: 'London, United Kingdom',
        countryCode: 'GB',
        role: 'Importer',
        status: 'Pending',
        contactPerson: 'Oliver Smith',
        email: 'oliver@londontextiles.co.uk',
        phone: '+44 20 7946 0912',
        tradeLicense: 'UK-099412',
        paymentTerms: 'Net 30',
        totalDeals: 6,
        tradeVolumeUsd: 92000.0,
        rating: 4.2,
        notes: ['Overdue invoice reminder dispatched.'],
      ),
    ];
  }

  void _initFallbackStorage() {
    final now = DateTime.now().toIso8601String();
    _fallbackUsers['awais@tradelink.pk'] = {
      'user_id': 'usr-001',
      'email': 'awais@tradelink.pk',
      'password': 'awais2284\$#@A',
      'full_name': 'Awais Ahmad',
      'company_name': 'Noor Trader',
      'phone': '03226808199',
      'role': 'agent',
      'account_tier': 'Premium Agent',
      'dark_mode': 0,
      'created_at': now,
      'last_login': now,
    };
    _fallbackUsers['ahmed@alnoor.ae'] = {
      'user_id': 'usr-002',
      'email': 'ahmed@alnoor.ae',
      'password': 'awais2284\$#@A',
      'full_name': 'Ahmed Al Noor',
      'company_name': 'Al Noor Traders LLC',
      'phone': '03226808199',
      'role': 'importer',
      'account_tier': 'Verified Importer',
      'dark_mode': 0,
      'created_at': now,
      'last_login': now,
    };
    _fallbackUsers['sales@shenzhentech.cn'] = {
      'user_id': 'usr-003',
      'email': 'sales@shenzhentech.cn',
      'password': 'awais2284\$#@A',
      'full_name': 'Li Wei',
      'company_name': 'Shenzhen Tech Ltd',
      'phone': '03226808199',
      'role': 'exporter',
      'account_tier': 'Verified Exporter',
      'dark_mode': 0,
      'created_at': now,
      'last_login': now,
    };
    _fallbackUsers['admin@tradelink.pk'] = {
      'user_id': 'usr-000',
      'email': 'admin@tradelink.pk',
      'password': 'awais2284\$#@A',
      'full_name': 'Master Administrator',
      'company_name': 'TradeLink Global Authority',
      'phone': '03226808199',
      'role': 'admin',
      'account_tier': 'Superadmin',
      'dark_mode': 0,
      'created_at': now,
      'last_login': now,
    };
    _fallbackPreferences['dark_mode'] = 'false';

    // Seed fallback clients
    for (final c in _getDefaultSeedClients()) {
      _fallbackClients[c.clientId] = {
        'client_id': c.clientId,
        'company_name': c.companyName,
        'country': c.country,
        'country_code': c.countryCode,
        'role': c.role,
        'status': c.status,
        'contact_person': c.contactPerson,
        'email': c.email,
        'phone': c.phone,
        'trade_license': c.tradeLicense,
        'payment_terms': c.paymentTerms,
        'total_deals': c.totalDeals,
        'trade_volume_usd': c.tradeVolumeUsd,
        'rating': c.rating,
        'notes': c.notes.join('||'),
      };
    }
  }

  /// Authenticate user credentials against the local database
  Future<UserProfile?> authenticateUser({
    required String email,
    required String password,
    UserRole? expectedRole,
  }) async {
    await initialize();

    final cleanInput = email.trim();
    final cleanEmail = cleanInput.toLowerCase();
    Map<String, dynamic>? userMap;

    if (_isUsingSqlite && _db != null) {
      List<Map<String, dynamic>> results;
      if (expectedRole != null) {
        results = await _db!.query(
          'users',
          where: '(LOWER(email) = ? OR phone = ? OR user_id = ?) AND role = ?',
          whereArgs: [cleanEmail, cleanInput, cleanInput, expectedRole.name],
          limit: 1,
        );
        if (results.isEmpty) {
          results = await _db!.query(
            'users',
            where: 'LOWER(email) = ? OR phone = ? OR user_id = ?',
            whereArgs: [cleanEmail, cleanInput, cleanInput],
            limit: 1,
          );
        }
      } else {
        results = await _db!.query(
          'users',
          where: 'LOWER(email) = ? OR phone = ? OR user_id = ?',
          whereArgs: [cleanEmail, cleanInput, cleanInput],
          limit: 1,
        );
      }
      if (results.isNotEmpty) {
        userMap = results.first;
      }
    } else {
      // In fallback storage
      if (expectedRole != null) {
        for (final u in _fallbackUsers.values) {
          final uEmail = (u['email'] as String? ?? '').toLowerCase();
          final uPhone = u['phone'] as String? ?? '';
          final uId = u['user_id'] as String? ?? '';
          final uRole = u['role'] as String? ?? '';
          if ((uEmail == cleanEmail || uPhone == cleanInput || uId == cleanInput) && uRole == expectedRole.name) {
            userMap = u;
            break;
          }
        }
      }
      if (userMap == null) {
        for (final u in _fallbackUsers.values) {
          final uEmail = (u['email'] as String? ?? '').toLowerCase();
          final uPhone = u['phone'] as String? ?? '';
          final uId = u['user_id'] as String? ?? '';
          if (uEmail == cleanEmail || uPhone == cleanInput || uId == cleanInput) {
            userMap = u;
            break;
          }
        }
      }
    }

    if (userMap == null) {
      await logLoginAttempt(cleanInput, expectedRole?.name ?? 'unknown', false);
      return null;
    }

    // Check password
    final storedPassword = userMap['password'] as String?;
    if (storedPassword != null && storedPassword.isNotEmpty && storedPassword != password.trim()) {
      await logLoginAttempt(cleanInput, userMap['role'] as String? ?? 'unknown', false);
      return null;
    }

    // Success - update last login
    final now = DateTime.now().toIso8601String();
    final matchedUserId = userMap['user_id'] as String?;
    if (_isUsingSqlite && _db != null && matchedUserId != null) {
      await _db!.update(
        'users',
        {'last_login': now},
        where: 'user_id = ?',
        whereArgs: [matchedUserId],
      );
    } else {
      userMap['last_login'] = now;
    }

    await logLoginAttempt(cleanInput, userMap['role'] as String? ?? 'unknown', true);

    return UserProfile(
      userId: userMap['user_id'] as String? ?? 'usr-${DateTime.now().millisecondsSinceEpoch}',
      fullName: userMap['full_name'] as String? ?? 'TradeLink User',
      email: userMap['email'] as String? ?? cleanEmail,
      companyName: userMap['company_name'] as String? ?? 'Trading Co.',
      phone: userMap['phone'] as String? ?? cleanInput,
      role: _parseRole(userMap['role'] as String? ?? 'agent'),
      accountTier: userMap['account_tier'] as String? ?? 'Standard',
      darkMode: (userMap['dark_mode'] as int? ?? 0) == 1,
    );
  }

  /// Update user login credentials (phone/username, email, password) in local database
  Future<bool> updateUserCredentials({
    required String userId,
    String? newPhone,
    String? newEmail,
    String? newPassword,
    String? newFullName,
    String? newCompanyName,
  }) async {
    await initialize();
    try {
      final updateData = <String, dynamic>{};
      if (newPhone != null && newPhone.trim().isNotEmpty) {
        updateData['phone'] = newPhone.trim();
      }
      if (newEmail != null && newEmail.trim().isNotEmpty) {
        updateData['email'] = newEmail.trim().toLowerCase();
      }
      if (newPassword != null && newPassword.trim().isNotEmpty) {
        updateData['password'] = newPassword.trim();
      }
      if (newFullName != null && newFullName.trim().isNotEmpty) {
        updateData['full_name'] = newFullName.trim();
      }
      if (newCompanyName != null && newCompanyName.trim().isNotEmpty) {
        updateData['company_name'] = newCompanyName.trim();
      }

      if (updateData.isEmpty) return true;

      if (_isUsingSqlite && _db != null) {
        await _db!.update(
          'users',
          updateData,
          where: 'user_id = ? OR LOWER(email) = ? OR phone = ?',
          whereArgs: [userId, (newEmail ?? userId).toLowerCase(), newPhone ?? userId],
        );
      }

      // Also update in fallback storage
      for (final key in _fallbackUsers.keys.toList()) {
        final u = _fallbackUsers[key]!;
        if (u['user_id'] == userId || u['email'] == (newEmail ?? '').toLowerCase() || u['phone'] == userId) {
          updateData.forEach((k, v) => u[k] = v);
          if (newEmail != null && newEmail.trim().toLowerCase() != key) {
            _fallbackUsers.remove(key);
            _fallbackUsers[newEmail.trim().toLowerCase()] = u;
          }
          break;
        }
      }
      debugPrint('LocalDatabaseService: updateUserCredentials succeeded for $userId');
      return true;
    } catch (e) {
      debugPrint('LocalDatabaseService: updateUserCredentials error: $e');
      return false;
    }
  }

  /// Register a new user in the local database
  Future<bool> registerUser(UserProfile profile, String password) async {
    await initialize();
    final cleanEmail = profile.email.trim().toLowerCase();
    final now = DateTime.now().toIso8601String();

    final userMap = {
      'user_id': profile.userId,
      'email': cleanEmail,
      'password': password.trim(),
      'full_name': profile.fullName,
      'company_name': profile.companyName,
      'phone': profile.phone,
      'role': profile.role.name,
      'account_tier': profile.accountTier,
      'dark_mode': profile.darkMode ? 1 : 0,
      'created_at': now,
      'last_login': now,
    };

    try {
      if (_isUsingSqlite && _db != null) {
        await _db!.insert(
          'users',
          userMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        _fallbackUsers[cleanEmail] = userMap;
      }
      return true;
    } catch (e) {
      debugPrint('LocalDatabaseService: registerUser error: $e');
      return false;
    }
  }

  /// Get saved theme mode (Dark / Light) from local database
  Future<bool> getThemePreference() async {
    await initialize();
    try {
      if (_isUsingSqlite && _db != null) {
        final results = await _db!.query(
          'app_preferences',
          where: 'pref_key = ?',
          whereArgs: ['dark_mode'],
          limit: 1,
        );
        if (results.isNotEmpty) {
          return results.first['pref_value'] == 'true';
        }
      } else {
        return _fallbackPreferences['dark_mode'] == 'true';
      }
    } catch (e) {
      debugPrint('LocalDatabaseService: getThemePreference error: $e');
    }
    return false;
  }

  /// Save theme mode (Dark / Light) to local database
  Future<void> saveThemePreference(bool isDark) async {
    await initialize();
    try {
      final val = isDark ? 'true' : 'false';
      if (_isUsingSqlite && _db != null) {
        await _db!.insert(
          'app_preferences',
          {'pref_key': 'dark_mode', 'pref_value': val},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        _fallbackPreferences['dark_mode'] = val;
      }
    } catch (e) {
      debugPrint('LocalDatabaseService: saveThemePreference error: $e');
    }
  }

  /// Save last selected account type
  Future<void> saveLastSelectedRole(UserRole role) async {
    await initialize();
    try {
      if (_isUsingSqlite && _db != null) {
        await _db!.insert(
          'app_preferences',
          {'pref_key': 'last_selected_role', 'pref_value': role.name},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      } else {
        _fallbackPreferences['last_selected_role'] = role.name;
      }
    } catch (e) {
      debugPrint('LocalDatabaseService: saveLastSelectedRole error: $e');
    }
  }

  /// Save biometric authentication preference for a user
  Future<void> saveBiometricPreference(String email, bool enabled) async {
    await initialize();
    final cleanEmail = email.trim().toLowerCase();
    final val = enabled ? 'true' : 'false';
    try {
      if (_isUsingSqlite && _db != null) {
        await _db!.insert(
          'app_preferences',
          {'pref_key': 'bio_enabled_$cleanEmail', 'pref_value': val},
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        if (enabled) {
          await _db!.insert(
            'app_preferences',
            {'pref_key': 'last_biometric_email', 'pref_value': cleanEmail},
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
      } else {
        _fallbackPreferences['bio_enabled_$cleanEmail'] = val;
        if (enabled) {
          _fallbackPreferences['last_biometric_email'] = cleanEmail;
        }
      }
      debugPrint('LocalDatabaseService: Biometric preference for $cleanEmail set to $enabled');
    } catch (e) {
      debugPrint('LocalDatabaseService: saveBiometricPreference error: $e');
    }
  }

  /// Get biometric authentication preference for a user (or globally)
  Future<bool> getBiometricPreference(String? email) async {
    await initialize();
    final cleanEmail = email?.trim().toLowerCase();
    try {
      if (cleanEmail != null && cleanEmail.isNotEmpty) {
        if (_isUsingSqlite && _db != null) {
          final results = await _db!.query(
            'app_preferences',
            where: 'pref_key = ?',
            whereArgs: ['bio_enabled_$cleanEmail'],
            limit: 1,
          );
          if (results.isNotEmpty) {
            return results.first['pref_value'] == 'true';
          }
        } else {
          return _fallbackPreferences['bio_enabled_$cleanEmail'] == 'true';
        }
      }
      // Check if any biometric user is registered
      final lastEmail = await getLastBiometricEmail();
      return lastEmail != null;
    } catch (e) {
      debugPrint('LocalDatabaseService: getBiometricPreference error: $e');
    }
    return false;
  }

  /// Get the email of the last user who enrolled biometrics
  Future<String?> getLastBiometricEmail() async {
    await initialize();
    try {
      if (_isUsingSqlite && _db != null) {
        final results = await _db!.query(
          'app_preferences',
          where: 'pref_key = ?',
          whereArgs: ['last_biometric_email'],
          limit: 1,
        );
        if (results.isNotEmpty) {
          return results.first['pref_value'] as String?;
        }
      } else {
        return _fallbackPreferences['last_biometric_email'];
      }
    } catch (e) {
      debugPrint('LocalDatabaseService: getLastBiometricEmail error: $e');
    }
    return null;
  }

  /// Authenticate user directly via verified biometric signature
  Future<UserProfile?> authenticateViaBiometrics({String? email}) async {
    await initialize();
    String? targetEmail = email?.trim().toLowerCase();
    targetEmail ??= await getLastBiometricEmail();
    targetEmail ??= 'awais@tradelink.pk'; // Default fallback to primary broker

    Map<String, dynamic>? userMap;
    if (_isUsingSqlite && _db != null) {
      final results = await _db!.query(
        'users',
        where: 'LOWER(email) = ?',
        whereArgs: [targetEmail],
        limit: 1,
      );
      if (results.isNotEmpty) {
        userMap = results.first;
      }
    } else {
      userMap = _fallbackUsers[targetEmail];
    }

    if (userMap == null) {
      // Fallback to first available user
      if (_fallbackUsers.isNotEmpty) {
        userMap = _fallbackUsers.values.first;
      }
    }

    if (userMap == null) return null;

    final now = DateTime.now().toIso8601String();
    if (_isUsingSqlite && _db != null) {
      await _db!.update(
        'users',
        {'last_login': now},
        where: 'LOWER(email) = ?',
        whereArgs: [targetEmail],
      );
    }

    await logLoginAttempt(targetEmail, userMap['role'] as String? ?? 'agent', true);

    return UserProfile(
      userId: userMap['user_id'] as String? ?? 'usr-${DateTime.now().millisecondsSinceEpoch}',
      fullName: userMap['full_name'] as String? ?? 'Awais Ahmad',
      email: userMap['email'] as String? ?? targetEmail,
      companyName: userMap['company_name'] as String? ?? 'Noor Trader',
      phone: userMap['phone'] as String? ?? '+92 300 1234567',
      role: _parseRole(userMap['role'] as String? ?? 'agent'),
      accountTier: userMap['account_tier'] as String? ?? 'Premium Agent',
      darkMode: (userMap['dark_mode'] as int? ?? 0) == 1,
      faceIdLogin: true,
    );
  }

  /// Get last selected account type
  Future<UserRole?> getLastSelectedRole() async {
    await initialize();
    try {
      String? roleStr;
      if (_isUsingSqlite && _db != null) {
        final results = await _db!.query(
          'app_preferences',
          where: 'pref_key = ?',
          whereArgs: ['last_selected_role'],
          limit: 1,
        );
        if (results.isNotEmpty) {
          roleStr = results.first['pref_value'] as String?;
        }
      } else {
        roleStr = _fallbackPreferences['last_selected_role'];
      }
      if (roleStr != null) {
        return _parseRole(roleStr);
      }
    } catch (e) {
      debugPrint('LocalDatabaseService: getLastSelectedRole error: $e');
    }
    return null;
  }

  /// Log login attempt to audit table
  Future<void> logLoginAttempt(String email, String role, bool success) async {
    try {
      final logEntry = {
        'email': email,
        'role': role,
        'status': success ? 'SUCCESS' : 'FAILED',
        'timestamp': DateTime.now().toIso8601String(),
      };
      if (_isUsingSqlite && _db != null) {
        await _db!.insert('login_logs', logEntry);
      } else {
        _fallbackLoginLogs.add(logEntry);
      }
    } catch (e) {
      debugPrint('LocalDatabaseService: logLoginAttempt error: $e');
    }
  }

  /// Get all registered users in local DB
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    await initialize();
    if (_isUsingSqlite && _db != null) {
      return await _db!.query('users', columns: [
        'user_id',
        'email',
        'full_name',
        'company_name',
        'phone',
        'role',
        'account_tier',
        'last_login'
      ]);
    }
    return _fallbackUsers.values.toList();
  }

  /// Save or update a trade document in local DB
  Future<bool> saveDocument(TradeDocumentModel doc) async {
    await initialize();
    final row = {
      'doc_id': doc.docId,
      'title': doc.title,
      'file_name': doc.fileName,
      'category': doc.category,
      'size_kb': doc.sizeKb,
      'status': doc.status,
      'upload_date': doc.uploadDate,
      'order_number': doc.orderNumber,
    };
    try {
      if (_isUsingSqlite && _db != null) {
        await _db!.insert('trade_documents', row, conflictAlgorithm: ConflictAlgorithm.replace);
      } else {
        _fallbackDocuments[doc.docId] = row;
      }
      return true;
    } catch (e) {
      debugPrint('LocalDatabaseService: saveDocument error: $e');
      return false;
    }
  }

  /// Delete a trade document from local DB
  Future<bool> deleteDocument(String docId) async {
    await initialize();
    try {
      if (_isUsingSqlite && _db != null) {
        await _db!.delete('trade_documents', where: 'doc_id = ?', whereArgs: [docId]);
      } else {
        _fallbackDocuments.remove(docId);
      }
      return true;
    } catch (e) {
      debugPrint('LocalDatabaseService: deleteDocument error: $e');
      return false;
    }
  }

  /// Retrieve all stored documents from local DB
  Future<List<TradeDocumentModel>> getAllDocuments() async {
    await initialize();
    try {
      List<Map<String, dynamic>> records;
      if (_isUsingSqlite && _db != null) {
        records = await _db!.query('trade_documents');
      } else {
        records = _fallbackDocuments.values.toList();
      }
      return records.map((r) => TradeDocumentModel(
        docId: r['doc_id'] as String,
        title: r['title'] as String,
        fileName: r['file_name'] as String,
        category: r['category'] as String,
        sizeKb: r['size_kb'] as int? ?? 300,
        status: r['status'] as String? ?? 'Pending',
        uploadDate: r['upload_date'] as String? ?? 'Recent',
        orderNumber: r['order_number'] as String? ?? 'ORD-5531',
      )).toList();
    } catch (e) {
      debugPrint('LocalDatabaseService: getAllDocuments error: $e');
      return [];
    }
  }

  /// Retrieve all stored clients / traders from local DB
  Future<List<ClientModel>> getAllClients() async {
    await initialize();
    try {
      List<Map<String, dynamic>> records;
      if (_isUsingSqlite && _db != null) {
        records = await _db!.query('clients');
      } else {
        records = _fallbackClients.values.toList();
      }
      if (records.isEmpty) {
        return await seedDefaultClientsIfEmpty();
      }
      return records.map((r) => ClientModel(
        clientId: r['client_id'] as String,
        companyName: r['company_name'] as String,
        country: r['country'] as String,
        countryCode: r['country_code'] as String? ?? 'XX',
        role: r['role'] as String,
        status: r['status'] as String? ?? 'Active',
        contactPerson: r['contact_person'] as String? ?? '',
        email: r['email'] as String? ?? '',
        phone: r['phone'] as String? ?? '',
        tradeLicense: r['trade_license'] as String? ?? '',
        paymentTerms: r['payment_terms'] as String? ?? 'LC at sight',
        totalDeals: r['total_deals'] as int? ?? 1,
        tradeVolumeUsd: (r['trade_volume_usd'] as num?)?.toDouble() ?? 10000.0,
        rating: (r['rating'] as num?)?.toDouble() ?? 5.0,
        notes: (r['notes'] as String?)?.split('||') ?? ['Verified trader organization.'],
      )).toList();
    } catch (e) {
      debugPrint('LocalDatabaseService: getAllClients error: $e');
      return _getDefaultSeedClients();
    }
  }

  /// Seed default clients if empty and return them
  Future<List<ClientModel>> seedDefaultClientsIfEmpty() async {
    final defaultClients = _getDefaultSeedClients();
    for (final c in defaultClients) {
      await saveClient(c);
    }
    return defaultClients;
  }

  /// Save or update a client / trader in local DB
  Future<bool> saveClient(ClientModel client) async {
    await initialize();
    final row = {
      'client_id': client.clientId,
      'company_name': client.companyName,
      'country': client.country,
      'country_code': client.countryCode,
      'role': client.role,
      'status': client.status,
      'contact_person': client.contactPerson,
      'email': client.email,
      'phone': client.phone,
      'trade_license': client.tradeLicense,
      'payment_terms': client.paymentTerms,
      'total_deals': client.totalDeals,
      'trade_volume_usd': client.tradeVolumeUsd,
      'rating': client.rating,
      'notes': client.notes.join('||'),
    };
    try {
      if (_isUsingSqlite && _db != null) {
        await _db!.insert('clients', row, conflictAlgorithm: ConflictAlgorithm.replace);
      } else {
        _fallbackClients[client.clientId] = row;
      }
      debugPrint('LocalDatabaseService: saved trader ${client.companyName} (${client.clientId})');
      return true;
    } catch (e) {
      debugPrint('LocalDatabaseService: saveClient error: $e');
      return false;
    }
  }

  /// Delete a client / trader from local DB
  Future<bool> deleteClient(String clientId) async {
    await initialize();
    try {
      if (_isUsingSqlite && _db != null) {
        await _db!.delete('clients', where: 'client_id = ?', whereArgs: [clientId]);
      } else {
        _fallbackClients.remove(clientId);
      }
      debugPrint('LocalDatabaseService: deleted trader $clientId from database');
      return true;
    } catch (e) {
      debugPrint('LocalDatabaseService: deleteClient error: $e');
      return false;
    }
  }

  UserRole _parseRole(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'importer':
        return UserRole.importer;
      case 'exporter':
        return UserRole.exporter;
      case 'admin':
        return UserRole.admin;
      case 'agent':
      default:
        return UserRole.agent;
    }
  }
}
