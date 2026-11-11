import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tradelink/database/local_database_service.dart';
import 'package:tradelink/main.dart';
import 'package:tradelink/models/trade_models.dart';
import 'package:tradelink/screens/access/02_login_screen.dart';
import 'package:tradelink/screens/core/05_client_management_screen.dart';
import 'package:tradelink/screens/deal_cycle/26_dispute_arbitration_screen.dart';
import 'package:tradelink/screens/deal_cycle/31_quality_inspection_screen.dart';
import 'package:tradelink/screens/finance/29_letter_of_credit_screen.dart';
import 'package:tradelink/screens/insights/25_settings_profile_screen.dart';
import 'package:tradelink/screens/logistics/27_maritime_weather_radar_screen.dart';
import 'package:tradelink/screens/logistics/28_sanctions_compliance_screen.dart';
import 'package:tradelink/screens/logistics/30_container_freight_screen.dart';
import 'package:tradelink/screens/shell/main_shell.dart';
import 'package:tradelink/state/trade_state.dart';
import 'package:tradelink/widgets/theme_toggle_button.dart';
import 'package:tradelink/widgets/tradelink_brand_logo.dart';

void main() {
  setUp(() async {
    // Ensure local database service is initialized
    await LocalDatabaseService.instance.initialize();
  });

  testWidgets('TradeLink complete onboarding flow: Splash -> Account Type Selection -> Sign In Credentials with Theme Toggle', (WidgetTester tester) async {
    await tester.pumpWidget(const TradeLinkApp());

    // 1. Verify Splash Screen
    expect(find.text('Import Export Commission Agent Platform'), findsOneWidget);
    expect(find.byType(TradeLinkLogo), findsOneWidget);
    expect(find.byType(ThemeToggleButton), findsOneWidget);

    // 2. Advance clock past the splash screen timer (1800ms)
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();

    // 3. Verify Account Type Selection Screen
    expect(find.text('Select Account Type'), findsOneWidget);
    expect(find.text('Commission Agent'), findsOneWidget);
    expect(find.text('Importer (Buyer)'), findsOneWidget);
    expect(find.text('Exporter (Supplier)'), findsOneWidget);
    expect(find.text('STEP 1 OF 2 • SELECT ACCOUNT TYPE'), findsOneWidget);
    expect(find.byType(ThemeToggleButton), findsOneWidget);

    // 4. Test Theme Toggle on Account Type Screen
    final themeToggleFinder = find.byType(ThemeToggleButton);
    expect(themeToggleFinder, findsOneWidget);
    await tester.tap(themeToggleFinder);
    await tester.pumpAndSettle();

    // 5. Select Importer account type and proceed to Sign In Credentials
    final importerOption = find.text('Importer (Buyer)');
    await tester.ensureVisible(importerOption);
    await tester.tap(importerOption);
    await tester.pumpAndSettle();

    final continueButton = find.text('Continue as Importer');
    await tester.ensureVisible(continueButton);
    expect(continueButton, findsOneWidget);
    await tester.tap(continueButton);
    await tester.pumpAndSettle();

    // 6. Verify Sign In Credentials Screen
    expect(find.text('STEP 2 OF 2 • SIGN IN CREDENTIALS'), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Importer (Buyer)'), findsOneWidget);
    expect(find.textContaining('Local Database:'), findsOneWidget);
    expect(find.textContaining('03226808199'), findsWidgets);
    expect(find.byType(ThemeToggleButton), findsOneWidget);

    // 7. Test Theme Toggle on Sign In Credentials Screen
    await tester.tap(find.byType(ThemeToggleButton));
    await tester.pumpAndSettle();
  });

  test('LocalDatabaseService authenticates universal credentials across roles and handles unregistered users', () async {
    final db = LocalDatabaseService.instance;
    await db.initialize();

    expect(db.isConnected, isTrue);

    // 1. Test Agent authentication with universal credentials (03226808199 / awais2284$#@A)
    final agent = await db.authenticateUser(
      email: '03226808199',
      password: 'awais2284\$#@A',
      expectedRole: UserRole.agent,
    );
    expect(agent, isNotNull);
    expect(agent!.fullName, 'Awais Ahmad');
    expect(agent.phone, '03226808199');
    expect(agent.role, UserRole.agent);

    // 2. Test Importer authentication with universal credentials
    final importer = await db.authenticateUser(
      email: '03226808199',
      password: 'awais2284\$#@A',
      expectedRole: UserRole.importer,
    );
    expect(importer, isNotNull);
    expect(importer!.fullName, 'Ahmed Al Noor');
    expect(importer.phone, '03226808199');
    expect(importer.role, UserRole.importer);

    // 3. Test Exporter authentication with universal credentials
    final exporter = await db.authenticateUser(
      email: '03226808199',
      password: 'awais2284\$#@A',
      expectedRole: UserRole.exporter,
    );
    expect(exporter, isNotNull);
    expect(exporter!.fullName, 'Li Wei');
    expect(exporter.role, UserRole.exporter);

    // 4. Test Administrator authentication with universal credentials
    final admin = await db.authenticateUser(
      email: '03226808199',
      password: 'awais2284\$#@A',
      expectedRole: UserRole.admin,
    );
    expect(admin, isNotNull);
    expect(admin!.role, UserRole.admin);

    // 5. Test Unregistered / Non-existent user returns NULL (triggering registration SnackBar)
    final nonExistent = await db.authenticateUser(
      email: '03009999999',
      password: 'randomPassword!',
    );
    expect(nonExistent, isNull);

    // 6. Test Credential Editing / Update in Database
    final updateResult = await db.updateUserCredentials(
      userId: 'usr-001',
      newPhone: '03226808199',
      newEmail: 'awais@tradelink.pk',
      newPassword: 'awais2284\$#@A',
    );
    expect(updateResult, isTrue);

    // 7. Test Clients / Traders DB CRUD (Add and Remove Trader)
    final testTrader = ClientModel(
      clientId: 'cli-test-db-01',
      companyName: 'Test Global Trading Ltd',
      country: 'Tokyo, Japan',
      countryCode: 'JP',
      role: 'Importer',
      status: 'Active',
      contactPerson: 'Kenji Sato',
      email: 'kenji@tokyotrade.jp',
      phone: '+81 3 5555 0199',
      tradeLicense: 'JP-LIC-9988',
      paymentTerms: 'LC 60 days',
      totalDeals: 5,
      tradeVolumeUsd: 120000.0,
      rating: 4.9,
      notes: ['Verified Japanese commodity importer.'],
    );

    // Save trader to DB
    final saved = await db.saveClient(testTrader);
    expect(saved, isTrue);

    final allClients = await db.getAllClients();
    expect(allClients.any((c) => c.clientId == 'cli-test-db-01'), isTrue);

    // Remove trader from DB
    final deleted = await db.deleteClient('cli-test-db-01');
    expect(deleted, isTrue);

    final clientsAfterDelete = await db.getAllClients();
    expect(clientsAfterDelete.any((c) => c.clientId == 'cli-test-db-01'), isFalse);

    // 8. Test Theme Preference Persistence
    await db.saveThemePreference(true);
    expect(await db.getThemePreference(), isTrue);

    await db.saveThemePreference(false);
    expect(await db.getThemePreference(), isFalse);

    // 9. Test Biometric Preference Persistence & Verification
    await db.saveBiometricPreference('awais@tradelink.pk', true);
    expect(await db.getBiometricPreference('awais@tradelink.pk'), isTrue);
    expect(await db.getLastBiometricEmail(), 'awais@tradelink.pk');

    final bioUser = await db.authenticateViaBiometrics(email: 'awais@tradelink.pk');
    expect(bioUser, isNotNull);
    expect(bioUser!.email, 'awais@tradelink.pk');

    await db.saveBiometricPreference('awais@tradelink.pk', false);
    expect(await db.getBiometricPreference('awais@tradelink.pk'), isFalse);
  });

  test('TradeState manages disputes, maritime radar, and sanctions records', () {
    final state = TradeState();

    expect(state.disputes.isNotEmpty, isTrue);
    expect(state.ports.isNotEmpty, isTrue);
    expect(state.sanctionsRecords.isNotEmpty, isTrue);

    // Test adding dispute
    final initialDisputes = state.disputes.length;
    state.fileDispute(TradeDisputeModel(
      disputeId: 'dsp-test',
      disputeCode: 'DISP-TEST-99',
      orderNumber: 'ORD-9999',
      complainant: 'Test Complainant',
      respondent: 'Test Respondent',
      claimAmount: 1000.0,
      reason: 'Specification mismatch',
      status: 'Active',
      filedDate: 'Today',
      escrowFrozenAmount: 1000.0,
      evidenceDocsCount: 2,
    ));
    expect(state.disputes.length, initialDisputes + 1);

    // Test resolving dispute
    state.resolveDispute('dsp-test', 'Resolved');
    expect(state.disputes.first.status, 'Resolved');

    // Test adding sanctions record
    final initialSanctions = state.sanctionsRecords.length;
    state.addSanctionsRecord(SanctionsScreeningRecord(
      recordId: 'scr-test',
      entityName: 'Test Vessel Carrier',
      country: 'Panama',
      entityType: 'Vessel Carrier',
      riskLevel: 'Low Risk (Passed)',
      listsChecked: 'OFAC SDN',
      clearanceToken: 'AML-TEST-001',
      timestamp: 'Today',
    ));
    expect(state.sanctionsRecords.length, initialSanctions + 1);

    // Test Letters of Credit (LC) operations
    expect(state.lettersOfCredit.isNotEmpty, isTrue);
    final initialLcs = state.lettersOfCredit.length;
    state.addLetterOfCredit(LetterOfCreditModel(
      lcId: 'lc-test-01',
      lcNumber: 'LC-TEST-900',
      issuingBank: 'Standard Chartered',
      applicant: 'Test Importer',
      beneficiary: 'Test Exporter',
      amount: 50000.0,
      currency: 'USD',
      expiryDate: '30 Nov 2026',
      latestShipmentDate: '15 Nov 2026',
      status: 'Active / Clean',
      discrepancies: [],
      incoterm: 'CIF Dubai',
    ));
    expect(state.lettersOfCredit.length, initialLcs + 1);
    state.updateLcStatus('lc-test-01', 'Negotiated');
    expect(state.lettersOfCredit.first.status, 'Negotiated');

    // Test Quality Inspections (PSI)
    expect(state.qualityInspections.isNotEmpty, isTrue);
    final initialPsis = state.qualityInspections.length;
    state.addQualityInspection(QualityInspectionModel(
      inspectionId: 'psi-test-01',
      orderNumber: 'ORD-TEST-01',
      factory: 'Karachi Test Factory',
      product: 'Test Cotton Yarn',
      lotQuantity: 10000,
      sampleSize: 200,
      criticalDefects: 0,
      majorDefects: 2,
      minorDefects: 3,
      agency: 'SGS',
      result: 'Passed (AQL 2.5)',
      inspectionDate: 'Today',
      certificateNumber: 'COI-TEST-99',
    ));
    expect(state.qualityInspections.length, initialPsis + 1);

    // Test Freight Benchmarks
    expect(state.freightRoutes.length, greaterThanOrEqualTo(4));
  });

  testWidgets('QA Verification: MainShell renders all navigation tabs in light and dark mode without overflow', (WidgetTester tester) async {
    final state = TradeState();
    await state.initDatabase();

    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(
          home: MainShell(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify Main Dashboard Tab renders
    expect(find.byType(MainShell), findsOneWidget);
    expect(find.text('Quick Actions'), findsOneWidget);

    // Switch to Clients Tab (index 1)
    final clientsTab = find.text('Clients');
    expect(clientsTab, findsOneWidget);
    await tester.tap(clientsTab);
    await tester.pumpAndSettle();
    expect(find.text('Clients & Partners'), findsOneWidget);

    // Switch to Deals / RFQs Tab (index 2)
    final dealsTab = find.text('Deals');
    expect(dealsTab, findsOneWidget);
    await tester.tap(dealsTab);
    await tester.pumpAndSettle();

    // Switch to Logistics Tab (index 3)
    final logisticsTab = find.text('Logistics');
    expect(logisticsTab, findsOneWidget);
    await tester.tap(logisticsTab);
    await tester.pumpAndSettle();

    // Switch to Finance Tab (index 4)
    final financeTab = find.text('Finance');
    expect(financeTab, findsOneWidget);
    await tester.tap(financeTab);
    await tester.pumpAndSettle();

    // Test Theme Toggle into Dark Mode and verify zero crash
    await state.toggleDarkMode();
    await tester.pumpAndSettle();
    expect(state.isDarkMode, isTrue);

    // Toggle back to Light Mode
    await state.toggleDarkMode();
    await tester.pumpAndSettle();
    expect(state.isDarkMode, isFalse);
  });

  testWidgets('QA Verification: Login Screen enforces database authentication and surfaces unregistered user SnackBar', (WidgetTester tester) async {
    final state = TradeState();

    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(
          home: LoginScreen(selectedRole: UserRole.agent),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Verify universal credentials are prefilled
    expect(find.text('03226808199'), findsOneWidget);

    // Type non-existent credentials
    final emailField = find.byType(TextField).first;
    await tester.enterText(emailField, '03999999999');
    await tester.pumpAndSettle();

    // Tap Sign In
    final signInButton = find.text('Sign In as Commission Agent');
    expect(signInButton, findsOneWidget);
    await tester.ensureVisible(signInButton);
    await tester.tap(signInButton);
    await tester.pumpAndSettle();

    // Verify the SnackBar for non-existent user appears
    expect(find.text('No user exists with these credentials. Please register as a new user.'), findsOneWidget);
    expect(find.text('Register Now'), findsOneWidget);
  });

  testWidgets('QA Verification: Enterprise screens (Modules 26-31) render smoothly in both Dark and Light themes', (WidgetTester tester) async {
    final state = TradeState();

    // 1. Module 26: Dispute & Arbitration Screen
    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: DisputeArbitrationScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Trade Dispute & Arbitration Center'), findsOneWidget);

    // 2. Module 27: Maritime Weather Radar Screen
    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: MaritimeWeatherRadarScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Maritime Weather & Port Radar'), findsOneWidget);

    // 3. Module 28: Sanctions Compliance Screen
    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: SanctionsComplianceScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Sanctions & AML Compliance'), findsOneWidget);

    // 4. Module 29: Letter of Credit Screen
    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: LetterOfCreditScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Letters of Credit (LC) Advisor'), findsOneWidget);

    // 5. Module 30: Container Freight Screen
    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: ContainerFreightScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Container Freight & Incoterms 2020'), findsOneWidget);

    // 6. Module 31: PSI Quality Inspection Screen
    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: QualityInspectionScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('PSI Quality Audit & AQL 2.5'), findsOneWidget);

    // 7. Settings Profile Screen
    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: SettingsProfileScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Settings & Profile'), findsOneWidget);
    expect(find.text('Database Login & Credentials'), findsOneWidget);
  });

  testWidgets('QA Verification: Client Management CRUD adds and removes traders seamlessly', (WidgetTester tester) async {
    final state = TradeState();
    await state.initDatabase();

    await tester.pumpWidget(
      TradeStateInherited(
        notifier: state,
        child: const MaterialApp(home: ClientManagementScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Clients & Partners'), findsOneWidget);
    final initialCount = state.clients.length;

    // Add trader
    final testTrader = ClientModel(
      clientId: 'cli-qa-01',
      companyName: 'QA Test Commodity Corp',
      country: 'Muscat, Oman',
      countryCode: 'OM',
      role: 'Importer',
      status: 'Active',
      contactPerson: 'Tariq Al-Said',
      email: 'tariq@qatest.om',
      phone: '+968 9123 4567',
      tradeLicense: 'OM-8831',
      paymentTerms: 'LC at sight',
      totalDeals: 3,
      tradeVolumeUsd: 55000.0,
      rating: 4.8,
      notes: ['Oman dry ports partner.'],
    );

    await state.addClient(testTrader);
    await tester.pumpAndSettle();

    expect(state.clients.length, initialCount + 1);
    expect(find.text('QA Test Commodity Corp'), findsOneWidget);

    // Remove trader
    await state.removeClient('cli-qa-01');
    await tester.pumpAndSettle();

    expect(state.clients.length, initialCount);
    expect(find.text('QA Test Commodity Corp'), findsNothing);
  });
}
