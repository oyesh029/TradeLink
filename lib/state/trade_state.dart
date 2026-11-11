import 'package:flutter/material.dart';
import '../database/local_database_service.dart';
import '../models/trade_models.dart';
import '../theme/app_colors.dart';

class TradeState extends ChangeNotifier {
  // Current Logged-in User
  UserProfile currentUser = UserProfile(
    userId: 'usr-001',
    fullName: 'Awais Ahmad',
    email: 'awais@tradelink.pk',
    companyName: 'Noor Trader',
    phone: '03226808199',
    role: UserRole.agent,
    accountTier: 'Premium Agent',
  );

  bool isAuthenticated = false;

  bool get isDarkMode => currentUser.darkMode;

  Future<void> initDatabase() async {
    await LocalDatabaseService.instance.initialize();
    final savedDark = await LocalDatabaseService.instance.getThemePreference();
    currentUser.darkMode = savedDark;

    // Load active traders / clients from local DB
    final dbClients = await LocalDatabaseService.instance.getAllClients();
    if (dbClients.isNotEmpty) {
      clients = dbClients;
    }
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    currentUser.darkMode = !currentUser.darkMode;
    notifyListeners();
    await LocalDatabaseService.instance.saveThemePreference(currentUser.darkMode);
  }

  Future<void> setDarkMode(bool value) async {
    currentUser.darkMode = value;
    notifyListeners();
    await LocalDatabaseService.instance.saveThemePreference(value);
  }

  void login({required String email, required String password}) {
    isAuthenticated = true;
    notifyListeners();
  }

  Future<bool> authenticateWithLocalDb({
    required String email,
    required String password,
    UserRole? role,
  }) async {
    final profile = await LocalDatabaseService.instance.authenticateUser(
      email: email,
      password: password,
      expectedRole: role,
    );
    if (profile != null) {
      currentUser = profile;
      isAuthenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  void setCurrentUser(UserProfile user) {
    currentUser = user;
    isAuthenticated = true;
    notifyListeners();
  }

  void loginAsRole(UserRole role) {
    currentUser = UserProfile(
      userId: 'usr-001',
      fullName: role == UserRole.agent
          ? 'Awais Ahmad'
          : role == UserRole.importer
              ? 'Ahmed Al Noor'
              : role == UserRole.exporter
                  ? 'Li Wei'
                  : 'Platform Admin',
      email: role == UserRole.agent
          ? 'awais@tradelink.pk'
          : role == UserRole.importer
              ? 'ahmed@alnoor.ae'
              : role == UserRole.exporter
                  ? 'sales@shenzhentech.cn'
                  : 'admin@tradelink.pk',
      companyName: role == UserRole.agent
          ? 'Noor Trader'
          : role == UserRole.importer
              ? 'Al Noor Traders LLC'
              : role == UserRole.exporter
                  ? 'Shenzhen Tech Ltd'
                  : 'TradeLink HQ',
      phone: '03226808199',
      role: role,
      accountTier: role == UserRole.agent ? 'Premium Agent' : 'Verified Enterprise',
    );
    isAuthenticated = true;
    notifyListeners();
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String companyName,
    required String phone,
    required String email,
  }) async {
    currentUser = UserProfile(
      userId: currentUser.userId,
      fullName: fullName,
      email: email,
      companyName: companyName,
      phone: phone,
      role: currentUser.role,
      accountTier: currentUser.accountTier,
      pushNotifications: currentUser.pushNotifications,
      faceIdLogin: currentUser.faceIdLogin,
      darkMode: currentUser.darkMode,
      emailReports: currentUser.emailReports,
      preferredLanguage: currentUser.preferredLanguage,
      defaultCurrency: currentUser.defaultCurrency,
    );
    notifyListeners();
    await LocalDatabaseService.instance.updateUserCredentials(
      userId: currentUser.userId,
      newPhone: phone,
      newEmail: email,
      newFullName: fullName,
      newCompanyName: companyName,
    );
  }

  Future<bool> updateCredentials({
    required String newPhone,
    required String newEmail,
    required String newPassword,
  }) async {
    final success = await LocalDatabaseService.instance.updateUserCredentials(
      userId: currentUser.userId,
      newPhone: newPhone,
      newEmail: newEmail,
      newPassword: newPassword,
    );
    if (success) {
      currentUser = UserProfile(
        userId: currentUser.userId,
        fullName: currentUser.fullName,
        email: newEmail,
        companyName: currentUser.companyName,
        phone: newPhone,
        role: currentUser.role,
        accountTier: currentUser.accountTier,
        pushNotifications: currentUser.pushNotifications,
        faceIdLogin: currentUser.faceIdLogin,
        darkMode: currentUser.darkMode,
        emailReports: currentUser.emailReports,
        preferredLanguage: currentUser.preferredLanguage,
        defaultCurrency: currentUser.defaultCurrency,
      );
      notifyListeners();
    }
    return success;
  }

  void logout() {
    isAuthenticated = false;
    notifyListeners();
  }

  // Clients Directory
  List<ClientModel> clients = [
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

  Future<void> addClient(ClientModel client) async {
    clients.insert(0, client);
    notifyListeners();
    await LocalDatabaseService.instance.saveClient(client);
  }

  Future<void> removeClient(String clientId) async {
    clients.removeWhere((c) => c.clientId == clientId);
    notifyListeners();
    await LocalDatabaseService.instance.deleteClient(clientId);
  }

  // Suppliers Directory
  List<SupplierModel> suppliers = [
    SupplierModel(
      supplierId: 'sup-001',
      companyName: 'Shenzhen Tech Ltd',
      country: 'China',
      city: 'Shenzhen',
      category: 'Electronics',
      badge: 'GOLD',
      rating: 5.0,
      reviewsCount: 120,
      mainProducts: 'Electronics, LED Panels, Power Banks, GaN Chargers',
      minOrderValue: 5000,
      leadTimeDays: 12,
      latitude: 22.5431,
      longitude: 114.0579,
    ),
    SupplierModel(
      supplierId: 'sup-002',
      companyName: 'Faisalabad Fabrics Ltd',
      country: 'Pakistan',
      city: 'Faisalabad',
      category: 'Textiles',
      badge: 'VERIFIED',
      rating: 4.0,
      reviewsCount: 85,
      mainProducts: 'Cotton, Raw Denim, Greige Fabric, Twill Yarn',
      minOrderValue: 8000,
      leadTimeDays: 18,
      latitude: 31.4504,
      longitude: 73.1350,
    ),
    SupplierModel(
      supplierId: 'sup-003',
      companyName: 'Istanbul Steel A.S.',
      country: 'Turkey',
      city: 'Istanbul',
      category: 'Steel',
      badge: 'GOLD',
      rating: 4.9,
      reviewsCount: 94,
      mainProducts: 'Steel Rebar 12mm, Wire Rods, Deformed Bars',
      minOrderValue: 20000,
      leadTimeDays: 20,
      latitude: 41.0082,
      longitude: 28.9784,
    ),
    SupplierModel(
      supplierId: 'sup-004',
      companyName: 'Mumbai Spices & Grains Co.',
      country: 'India',
      city: 'Mumbai',
      category: 'Food',
      badge: 'VERIFIED',
      rating: 4.6,
      reviewsCount: 62,
      mainProducts: 'Super Basmati Rice 25kg, Red Chili, Turmeric Finger',
      minOrderValue: 6000,
      leadTimeDays: 14,
      latitude: 19.0760,
      longitude: 72.8777,
    ),
  ];

  // Products Catalog
  List<ProductModel> products = [
    ProductModel(
      productId: 'prd-001',
      productName: 'LED Panel Light 40W (600x600)',
      hsCode: '9405.42',
      category: 'Electronics',
      unit: 'pc',
      indicativePrice: 4.20,
      supplierName: 'Shenzhen Tech Ltd',
      sku: 'ELEC-LED-040',
      cardTint: AppColors.tealTint,
    ),
    ProductModel(
      productId: 'prd-002',
      productName: 'Basmati Rice 25kg Premium Bag',
      hsCode: '1006.30',
      category: 'Food',
      unit: 'bag',
      indicativePrice: 38.00,
      supplierName: 'Mumbai Spices & Grains',
      sku: 'AGRI-RICE-025',
      cardTint: AppColors.goldTint,
    ),
    ProductModel(
      productId: 'prd-003',
      productName: 'Cotton Denim Fabric 12oz Raw',
      hsCode: '5209.42',
      category: 'Textiles',
      unit: 'm',
      indicativePrice: 2.10,
      supplierName: 'Faisalabad Fabrics',
      sku: 'TEX-DNM-012',
      cardTint: AppColors.blueTint,
    ),
    ProductModel(
      productId: 'prd-004',
      productName: 'Steel Rebar 12mm Grade 60 (Ton)',
      hsCode: '7214.20',
      category: 'Steel',
      unit: 'ton',
      indicativePrice: 610.00,
      supplierName: 'Istanbul Steel A.S.',
      sku: 'MET-RBR-012',
      cardTint: AppColors.navyTint,
    ),
    ProductModel(
      productId: 'prd-005',
      productName: 'Power Bank 10,000mAh Dual USB-C',
      hsCode: '8507.60',
      category: 'Electronics',
      unit: 'pc',
      indicativePrice: 6.80,
      supplierName: 'Shenzhen Tech Ltd',
      sku: 'ELEC-PB-010',
      cardTint: AppColors.tealTint,
    ),
  ];

  // Inquiries / RFQ
  List<RfqModel> rfqs = [
    RfqModel(
      rfqId: 'rfq-001',
      rfqNumber: 'RFQ-2041',
      buyerName: 'Al Noor Traders',
      productName: 'LED Panel Lights 40W',
      targetQuantity: '5,000 pcs',
      urgency: 'High',
      deadlineText: 'Due in 2 days',
      status: 'Open',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    RfqModel(
      rfqId: 'rfq-002',
      rfqNumber: 'RFQ-2040',
      buyerName: 'Hamburg Goods GmbH',
      productName: 'Super Basmati Rice',
      targetQuantity: '20 tons',
      urgency: 'Normal',
      deadlineText: 'Due in 4 days',
      status: 'Quoted',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RfqModel(
      rfqId: 'rfq-003',
      rfqNumber: 'RFQ-2039',
      buyerName: 'London Textiles Co.',
      productName: 'Cotton Denim Fabric',
      targetQuantity: '12,000 m',
      urgency: 'Critical',
      deadlineText: 'Due today',
      status: 'Open',
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    RfqModel(
      rfqId: 'rfq-004',
      rfqNumber: 'RFQ-2038',
      buyerName: 'Gulf Builders Corp',
      productName: 'Steel Rebar 12mm',
      targetQuantity: '150 tons',
      urgency: 'Normal',
      deadlineText: 'Closed',
      status: 'Won',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  // Quotation Builder State
  QuotationModel currentQuotation = QuotationModel(
    quotationId: 'q-001',
    quotationNumber: 'Q-1042',
    clientName: 'Al Noor Traders LLC',
    rfqNumber: 'RFQ-2041',
    incoterm: 'CIF Dubai',
    validityDays: 15,
    items: [
      QuotationItem(title: 'LED Panel 40W 600x600', quantity: 5000, unitPrice: 4.20),
      QuotationItem(title: 'Power Bank 10,000mAh', quantity: 2000, unitPrice: 6.80),
      QuotationItem(title: 'USB-C Braided Cable 1m', quantity: 8000, unitPrice: 0.55),
    ],
    freightInsurance: 2150.0,
    commissionRatePct: 3.0,
    status: 'Sent',
  );

  void updateQuotationCommission(double rate) {
    currentQuotation = QuotationModel(
      quotationId: currentQuotation.quotationId,
      quotationNumber: currentQuotation.quotationNumber,
      clientName: currentQuotation.clientName,
      rfqNumber: currentQuotation.rfqNumber,
      incoterm: currentQuotation.incoterm,
      validityDays: currentQuotation.validityDays,
      items: currentQuotation.items,
      freightInsurance: currentQuotation.freightInsurance,
      commissionRatePct: rate,
      status: currentQuotation.status,
    );
    notifyListeners();
  }

  // Negotiation Chat Messages
  List<ChatMessageModel> chatMessages = [
    ChatMessageModel(
      messageId: 'msg-001',
      senderName: 'Ahmed Al Noor (Buyer)',
      isFromMe: false,
      text: 'Hello Awais, we received Q-1042 for the LED panels. Can Shenzhen Tech do \$4.00 per piece if we increase to 8,000 pcs?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    ChatMessageModel(
      messageId: 'msg-002',
      senderName: 'Li Wei (Shenzhen Tech)',
      isFromMe: false,
      text: 'Raw aluminum housing cost increased recently. Best volume price we can support is \$4.05 for 8,000 units on CIF terms.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    ChatMessageModel(
      messageId: 'msg-003',
      senderName: 'Awais Ahmad (Agent)',
      isFromMe: true,
      text: 'I have structured the revised counter-offer card below for both parties to confirm.',
      counterOffer: CounterOfferCard(
        offerId: 'off-001',
        productName: 'LED Panel 40W (CIF Dubai)',
        revisedQuantity: 8000,
        revisedUnitPrice: 4.05,
        revisedTotal: 32400.0,
        status: 'Pending',
      ),
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
    ),
  ];

  void acceptCounterOffer(String offerId) {
    for (var msg in chatMessages) {
      if (msg.counterOffer?.offerId == offerId) {
        msg.counterOffer?.status = 'Accepted';
      }
    }
    chatMessages.add(ChatMessageModel(
      messageId: 'msg-${DateTime.now().millisecondsSinceEpoch}',
      senderName: 'Awais Ahmad (Agent)',
      isFromMe: true,
      text: 'Counter-offer accepted! Generating confirmed Purchase Contract ORD-5531 and escrow deposit link.',
      timestamp: DateTime.now(),
    ));
    notifyListeners();
  }

  // Orders
  List<TradeOrderModel> orders = [
    TradeOrderModel(
      orderId: 'ord-001',
      orderNumber: 'ORD-5531',
      buyerName: 'Al Noor Traders',
      sellerName: 'Shenzhen Tech Ltd',
      productSummary: 'LED Panel Lights • 5,000 pcs',
      orderValue: 21000.0,
      agentCommission: 630.0,
      status: 'Processing',
      progressPct: 50,
      milestones: [
        OrderMilestone(step: 1, title: 'Order Confirmed', dateText: '12 Oct, 10:30 AM', isCompleted: true, remarks: 'Contract signed'),
        OrderMilestone(step: 2, title: 'Advance Payment Received', dateText: '13 Oct, 02:05 PM', isCompleted: true, remarks: 'Escrow 50% funded'),
        OrderMilestone(step: 3, title: 'Production / Packing', dateText: '14 Oct, 09:00 AM', isCompleted: true, remarks: 'Passed factory QC'),
        OrderMilestone(step: 4, title: 'Shipped from Port', dateText: '16 Oct, 06:30 PM', isCompleted: true, remarks: 'Departed Karachi / Shenzhen'),
        OrderMilestone(step: 5, title: 'Customs Clearance', dateText: 'Pending (ETA 18 Oct)', isCompleted: false, remarks: 'PSW declaration submitted'),
        OrderMilestone(step: 6, title: 'Delivered', dateText: 'Pending', isCompleted: false, remarks: 'Jebel Ali warehouse final handover'),
      ],
    ),
    TradeOrderModel(
      orderId: 'ord-002',
      orderNumber: 'ORD-5530',
      buyerName: 'Hamburg Goods GmbH',
      sellerName: 'Mumbai Spices & Grains',
      productSummary: 'Super Basmati Rice • 20 tons',
      orderValue: 22800.0,
      agentCommission: 684.0,
      status: 'Shipped',
      progressPct: 75,
      milestones: [
        OrderMilestone(step: 1, title: 'Order Confirmed', dateText: '05 Oct', isCompleted: true, remarks: 'Done'),
        OrderMilestone(step: 2, title: 'Advance Payment Received', dateText: '06 Oct', isCompleted: true, remarks: 'LC opened'),
        OrderMilestone(step: 3, title: 'Production / Packing', dateText: '08 Oct', isCompleted: true, remarks: 'Bagged'),
        OrderMilestone(step: 4, title: 'Shipped from Port', dateText: '10 Oct', isCompleted: true, remarks: 'En route Hamburg'),
        OrderMilestone(step: 5, title: 'Customs Clearance', dateText: 'Pending', isCompleted: false, remarks: 'Pending arrival'),
        OrderMilestone(step: 6, title: 'Delivered', dateText: 'Pending', isCompleted: false, remarks: 'Pending arrival'),
      ],
    ),
    TradeOrderModel(
      orderId: 'ord-003',
      orderNumber: 'ORD-5524',
      buyerName: 'Gulf Builders Corp',
      sellerName: 'Istanbul Steel A.S.',
      productSummary: 'Steel Rebar 12mm • 150 tons',
      orderValue: 91500.0,
      agentCommission: 2745.0,
      status: 'Delivered',
      progressPct: 100,
      milestones: [
        OrderMilestone(step: 1, title: 'Order Confirmed', dateText: '20 Sep', isCompleted: true, remarks: 'Done'),
        OrderMilestone(step: 2, title: 'Advance Payment Received', dateText: '22 Sep', isCompleted: true, remarks: 'Wire cleared'),
        OrderMilestone(step: 3, title: 'Production / Packing', dateText: '28 Sep', isCompleted: true, remarks: 'Bundled'),
        OrderMilestone(step: 4, title: 'Shipped from Port', dateText: '03 Oct', isCompleted: true, remarks: 'Departed'),
        OrderMilestone(step: 5, title: 'Customs Clearance', dateText: '12 Oct', isCompleted: true, remarks: 'Cleared Dammam'),
        OrderMilestone(step: 6, title: 'Delivered', dateText: '15 Oct', isCompleted: true, remarks: 'Received at site'),
      ],
    ),
  ];

  void advanceOrderMilestone(String orderId) {
    for (var ord in orders) {
      if (ord.orderId == orderId) {
        for (var m in ord.milestones) {
          if (!m.isCompleted) {
            m.isCompleted = true;
            ord.progressPct = ((ord.milestones.where((x) => x.isCompleted).length / ord.milestones.length) * 100).toInt();
            if (ord.progressPct == 100) ord.status = 'Delivered';
            notifyListeners();
            return;
          }
        }
      }
    }
  }

  // Shipment Tracking
  ShipmentModel activeShipment = ShipmentModel(
    shipmentId: 'shp-001',
    containerNumber: 'MSKU-7781452',
    blNumber: 'BL-MSKU7781',
    vesselName: 'MV Ocean Star',
    containerType: '40ft HC',
    originPort: 'Karachi Port (PKKHI)',
    destinationPort: 'Jebel Ali (AEJEA)',
    departedDate: '12 Oct',
    etaDate: '18 Oct',
    status: 'In Transit',
    progressPct: 65,
    routeCheckpoints: [
      'Karachi Seaport (Departed 12 Oct)',
      'Arabian Sea Corridor (At Sea Now)',
      'Strait of Hormuz (Passing 16 Oct)',
      'Jebel Ali Port (Arrival ETA 18 Oct)',
    ],
  );

  // Documents
  List<TradeDocumentModel> documents = [
    TradeDocumentModel(
      docId: 'doc-001',
      title: 'Commercial Invoice',
      fileName: 'INV-2209.pdf',
      category: 'Invoices',
      sizeKb: 240,
      status: 'Approved',
      uploadDate: '12 Oct 2026',
      orderNumber: 'ORD-5531',
    ),
    TradeDocumentModel(
      docId: 'doc-002',
      title: 'Bill of Lading',
      fileName: 'BL-MSKU7781.pdf',
      category: 'B/L',
      sizeKb: 410,
      status: 'Approved',
      uploadDate: '13 Oct 2026',
      orderNumber: 'ORD-5531',
    ),
    TradeDocumentModel(
      docId: 'doc-003',
      title: 'Packing List',
      fileName: 'PL-5531.pdf',
      category: 'Packing',
      sizeKb: 180,
      status: 'Pending',
      uploadDate: '14 Oct 2026',
      orderNumber: 'ORD-5531',
    ),
    TradeDocumentModel(
      docId: 'doc-004',
      title: 'Certificate of Origin',
      fileName: 'COO-5531.pdf',
      category: 'Customs',
      sizeKb: 320,
      status: 'Approved',
      uploadDate: '14 Oct 2026',
      orderNumber: 'ORD-5531',
    ),
    TradeDocumentModel(
      docId: 'doc-005',
      title: 'Letter of Credit',
      fileName: 'LC-88231.pdf',
      category: 'Invoices',
      sizeKb: 520,
      status: 'Rejected',
      uploadDate: '11 Oct 2026',
      orderNumber: 'ORD-5531',
    ),
    TradeDocumentModel(
      docId: 'doc-006',
      title: 'Marine Cargo Insurance Policy',
      fileName: 'INS-4412.pdf',
      category: 'Customs',
      sizeKb: 290,
      status: 'Approved',
      uploadDate: '13 Oct 2026',
      orderNumber: 'ORD-5531',
    ),
  ];

  void addDocument(TradeDocumentModel doc) {
    documents.insert(0, doc);
    notifyListeners();
    LocalDatabaseService.instance.saveDocument(doc);
  }

  void updateDocument(
    String docId, {
    required String title,
    required String fileName,
    required String category,
    required String status,
    String? orderNumber,
    int? sizeKb,
  }) {
    final index = documents.indexWhere((d) => d.docId == docId);
    if (index != -1) {
      final old = documents[index];
      final updated = TradeDocumentModel(
        docId: docId,
        title: title,
        fileName: fileName,
        category: category,
        sizeKb: sizeKb ?? old.sizeKb,
        status: status,
        uploadDate: old.uploadDate,
        orderNumber: orderNumber ?? old.orderNumber,
      );
      documents[index] = updated;
      notifyListeners();
      LocalDatabaseService.instance.saveDocument(updated);
    }
  }

  void deleteDocument(String docId) {
    documents.removeWhere((d) => d.docId == docId);
    notifyListeners();
    LocalDatabaseService.instance.deleteDocument(docId);
  }

  // Customs & HS Codes
  HsCodeModel verifiedHsCode = HsCodeModel(
    hsCode: '9405.42',
    description: 'Electric lamps and lighting fittings - LED panels & luminaires',
    customsDutyPct: 11.0,
    salesTaxPct: 18.0,
    additionalDutyPct: 2.0,
    withholdingTaxPct: 5.5,
  );

  List<ComplianceCheckItem> customsChecklist = [
    ComplianceCheckItem(title: 'Import license / IEC valid', isChecked: true),
    ComplianceCheckItem(title: 'Certificate of origin attached', isChecked: true),
    ComplianceCheckItem(title: 'Commercial invoice & packing list matched', isChecked: true),
    ComplianceCheckItem(title: 'Quality / BIS / CE certification', isChecked: false),
    ComplianceCheckItem(title: 'Pre-shipment inspection report (PSI)', isChecked: false),
  ];

  void toggleComplianceItem(int index) {
    customsChecklist[index].isChecked = !customsChecklist[index].isChecked;
    notifyListeners();
  }

  // Commission Calculator State
  double calcDealValue = 42000.0;
  double calcCommissionRate = 3.0;
  String calcModel = 'Percentage'; // 'Fixed', 'Percentage', 'Tiered'

  double get calcGrossCommission => calcDealValue * (calcCommissionRate / 100);
  double get calcPlatformFee => calcGrossCommission * 0.10;
  double get calcTaxWithheld => 0.0;
  double get calcNetCommission => calcGrossCommission - calcPlatformFee - calcTaxWithheld;

  void updateCalculator({double? dealValue, double? rate, String? model}) {
    if (dealValue != null) calcDealValue = dealValue;
    if (rate != null) calcCommissionRate = rate;
    if (model != null) calcModel = model;
    notifyListeners();
  }

  // Earnings Ledger
  double totalMonthlyEarnings = 12430.0;
  double monthlyGrowthPct = 14.2;
  double totalReceived = 9860.0;
  double totalPending = 2570.0;

  List<LedgerEntryModel> ledgerEntries = [
    LedgerEntryModel(
      entryId: 'led-001',
      orderNumber: 'ORD-5524',
      clientName: 'Gulf Builders Corp',
      commissionAmount: 2745.0,
      status: 'Paid',
      paymentMethod: 'Bank Wire Transfer',
      dateText: '21 Oct 2026',
    ),
    LedgerEntryModel(
      entryId: 'led-002',
      orderNumber: 'ORD-5521',
      clientName: 'Lagos Import Agency',
      commissionAmount: 345.0,
      status: 'Paid',
      paymentMethod: 'Escrow Release',
      dateText: '19 Oct 2026',
    ),
    LedgerEntryModel(
      entryId: 'led-003',
      orderNumber: 'ORD-5530',
      clientName: 'Hamburg Goods GmbH',
      commissionAmount: 684.0,
      status: 'Paid',
      paymentMethod: 'Letter of Credit',
      dateText: '14 Oct 2026',
    ),
    LedgerEntryModel(
      entryId: 'led-004',
      orderNumber: 'ORD-5528',
      clientName: 'Istanbul Trading Co',
      commissionAmount: 756.0,
      status: 'Pending',
      paymentMethod: 'Telegraphic Transfer',
      dateText: 'Due 25 Oct 2026',
    ),
    LedgerEntryModel(
      entryId: 'led-005',
      orderNumber: 'ORD-5531',
      clientName: 'Al Noor Traders',
      commissionAmount: 630.0,
      status: 'Pending',
      paymentMethod: 'Escrow Release',
      dateText: 'Due 05 Nov 2026',
    ),
  ];

  // Invoices
  List<InvoiceModel> invoices = [
    InvoiceModel(
      invoiceId: 'inv-001',
      invoiceNumber: 'INV-2211',
      clientName: 'Al Noor Traders LLC',
      amount: 21000.0,
      issueDate: '12 Oct 2026',
      dueDate: 'Due 28 Oct 2026',
      status: 'Unpaid',
    ),
    InvoiceModel(
      invoiceId: 'inv-002',
      invoiceNumber: 'INV-2210',
      clientName: 'Hamburg Goods GmbH',
      amount: 22800.0,
      issueDate: '06 Oct 2026',
      dueDate: 'Paid 14 Oct 2026',
      status: 'Paid',
    ),
    InvoiceModel(
      invoiceId: 'inv-003',
      invoiceNumber: 'INV-2209',
      clientName: 'London Textiles Co.',
      amount: 6200.0,
      issueDate: '18 Sep 2026',
      dueDate: 'Due 02 Oct 2026',
      status: 'Overdue',
    ),
    InvoiceModel(
      invoiceId: 'inv-004',
      invoiceNumber: 'INV-2208',
      clientName: 'Gulf Builders Corp',
      amount: 91500.0,
      issueDate: '22 Sep 2026',
      dueDate: 'Paid 10 Oct 2026',
      status: 'Paid',
    ),
    InvoiceModel(
      invoiceId: 'inv-005',
      invoiceNumber: 'INV-2207',
      clientName: 'Lagos Import Agency',
      amount: 11500.0,
      issueDate: '25 Sep 2026',
      dueDate: 'Paid 05 Oct 2026',
      status: 'Paid',
    ),
  ];

  void addInvoice(InvoiceModel inv) {
    invoices.insert(0, inv);
    notifyListeners();
  }

  // Payments & Escrow State
  double escrowBalance = 32400.0;
  double escrowReleasedPct = 50.0;
  double escrowHeldPct = 50.0;
  String selectedPaymentMethod = 'Escrow Payment'; // 'Letter of Credit', 'Telegraphic Transfer', 'Escrow Payment'

  void releaseEscrowMilestone() {
    escrowReleasedPct = 100.0;
    escrowHeldPct = 0.0;
    notifyListeners();
  }

  // Currency Rates
  List<CurrencyRateModel> currencyRates = [
    CurrencyRateModel(code: 'PKR', name: 'Pakistani Rupee', rateToUsd: 278.45, dailyChangePct: 0.12, sparkline: [277.8, 278.0, 278.2, 278.1, 278.3, 278.45]),
    CurrencyRateModel(code: 'AED', name: 'UAE Dirham', rateToUsd: 3.6730, dailyChangePct: 0.00, sparkline: [3.673, 3.673, 3.673, 3.673, 3.673, 3.673]),
    CurrencyRateModel(code: 'EUR', name: 'Euro', rateToUsd: 0.9210, dailyChangePct: -0.34, sparkline: [0.925, 0.924, 0.922, 0.923, 0.921, 0.921]),
    CurrencyRateModel(code: 'GBP', name: 'British Pound', rateToUsd: 0.7880, dailyChangePct: 0.08, sparkline: [0.785, 0.786, 0.787, 0.786, 0.787, 0.788]),
    CurrencyRateModel(code: 'CNY', name: 'Chinese Yuan', rateToUsd: 7.2410, dailyChangePct: -0.15, sparkline: [7.255, 7.250, 7.248, 7.245, 7.242, 7.241]),
    CurrencyRateModel(code: 'SAR', name: 'Saudi Riyal', rateToUsd: 3.7500, dailyChangePct: 0.00, sparkline: [3.750, 3.750, 3.750, 3.750, 3.750, 3.750]),
  ];

  // Notifications
  List<NotificationModel> notifications = [
    NotificationModel(
      notificationId: 'notif-001',
      title: 'Quotation accepted Q-1042',
      detail: 'Al Noor Traders accepted Q-1042 for 8,000 pcs LED panels.',
      category: 'Orders',
      group: 'Today',
      timeAgo: '15m ago',
      isRead: false,
    ),
    NotificationModel(
      notificationId: 'notif-002',
      title: 'Payment received \$6,500',
      detail: 'Escrow milestone deposit released for ORD-5530.',
      category: 'Payments',
      group: 'Today',
      timeAgo: '2h ago',
      isRead: false,
    ),
    NotificationModel(
      notificationId: 'notif-003',
      title: 'Shipment update MSKU-7781',
      detail: 'Vessel MV Ocean Star cleared Strait of Hormuz waypoint.',
      category: 'Orders',
      group: 'Today',
      timeAgo: '4h ago',
      isRead: true,
    ),
    NotificationModel(
      notificationId: 'notif-004',
      title: 'Invoice overdue INV-2209',
      detail: 'London Textiles balance of \$6,200 passed 30-day grace period.',
      category: 'Payments',
      group: 'Earlier',
      timeAgo: '2d ago',
      isRead: false,
    ),
    NotificationModel(
      notificationId: 'notif-005',
      title: 'Document rejected LC-88231',
      detail: 'Port name discrepancy in Letter of Credit MT700 requires amendment.',
      category: 'System',
      group: 'Earlier',
      timeAgo: '3d ago',
      isRead: true,
    ),
    NotificationModel(
      notificationId: 'notif-006',
      title: 'New RFQ received',
      detail: 'Gulf Builders submitted RFQ for 150 tons Steel Rebar 12mm.',
      category: 'Orders',
      group: 'Earlier',
      timeAgo: '4d ago',
      isRead: true,
    ),
  ];

  void markAllNotificationsRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  // Calendar & Tasks
  List<TaskItemModel> tasks = [
    TaskItemModel(
      taskId: 'tsk-001',
      title: 'Send quotation to Hamburg Goods',
      scheduledTime: '10:30 AM',
      priority: 'Normal',
      isDone: true,
    ),
    TaskItemModel(
      taskId: 'tsk-002',
      title: 'Follow up: LC amendment for Al Noor',
      scheduledTime: '12:00 PM',
      priority: 'High',
      isDone: false,
    ),
    TaskItemModel(
      taskId: 'tsk-003',
      title: 'Customs clearance call - Karachi PSW',
      scheduledTime: '03:00 PM',
      priority: 'Normal',
      isDone: false,
    ),
    TaskItemModel(
      taskId: 'tsk-004',
      title: 'Review MSKU-7781 documents with carrier',
      scheduledTime: '05:00 PM',
      priority: 'Urgent',
      isDone: false,
    ),
  ];

  void toggleTask(String taskId) {
    for (var t in tasks) {
      if (t.taskId == taskId) {
        t.isDone = !t.isDone;
        notifyListeners();
        return;
      }
    }
  }

  void addTask(TaskItemModel task) {
    tasks.add(task);
    notifyListeners();
  }

  // Trade Disputes Docket
  List<TradeDisputeModel> disputes = [
    TradeDisputeModel(
      disputeId: 'disp-001',
      disputeCode: 'DISP-902',
      orderNumber: 'ORD-5531',
      complainant: 'Al Noor Traders LLC',
      respondent: 'Shenzhen Tech Ltd',
      claimAmount: 8400.0,
      reason: 'Quality Inspection Variance - 500 LED panels defective',
      status: 'Active',
      filedDate: '14 Oct 2026',
      escrowFrozenAmount: 8400.0,
      evidenceDocsCount: 4,
    ),
    TradeDisputeModel(
      disputeId: 'disp-002',
      disputeCode: 'DISP-901',
      orderNumber: 'ORD-5512',
      complainant: 'Hamburg Goods GmbH',
      respondent: 'Shenzhen Tech Ltd',
      claimAmount: 2150.0,
      reason: 'Demurrage & Detention Delay at Karachi Port',
      status: 'In Arbitration',
      filedDate: '08 Oct 2026',
      escrowFrozenAmount: 2150.0,
      evidenceDocsCount: 3,
    ),
    TradeDisputeModel(
      disputeId: 'disp-003',
      disputeCode: 'DISP-899',
      orderNumber: 'ORD-5490',
      complainant: 'Gulf Builders Corp',
      respondent: 'Karachi Mills Ltd',
      claimAmount: 14200.0,
      reason: 'Short Shipment in 40ft Container',
      status: 'Resolved',
      filedDate: '28 Sep 2026',
      escrowFrozenAmount: 0.0,
      evidenceDocsCount: 6,
    ),
  ];

  // Maritime Port Radar & Global Dwell Times
  List<PortCongestionModel> ports = [
    PortCongestionModel(
      portCode: 'PKQAS',
      portName: 'Port Qasim & Karachi',
      country: 'Pakistan',
      dwellDays: 3.2,
      berthQueueCount: 6,
      congestionLevel: 'Normal',
      weatherWarning: 'Clear • Light swell 0.8m',
      bunkerFuelPrice: 590.0,
    ),
    PortCongestionModel(
      portCode: 'AEJEA',
      portName: 'Jebel Ali Port (Dubai)',
      country: 'UAE',
      dwellDays: 1.8,
      berthQueueCount: 2,
      congestionLevel: 'Optimal',
      weatherWarning: 'Calm sea • Visibility 10nm',
      bunkerFuelPrice: 575.0,
    ),
    PortCongestionModel(
      portCode: 'CNSHA',
      portName: 'Port of Shanghai',
      country: 'China',
      dwellDays: 4.5,
      berthQueueCount: 18,
      congestionLevel: 'Moderate',
      weatherWarning: 'Typhoon alert East China Sea',
      bunkerFuelPrice: 620.0,
    ),
    PortCongestionModel(
      portCode: 'CNNGB',
      portName: 'Ningbo-Zhoushan',
      country: 'China',
      dwellDays: 2.9,
      berthQueueCount: 9,
      congestionLevel: 'Normal',
      weatherWarning: 'Moderate gale warning',
      bunkerFuelPrice: 615.0,
    ),
    PortCongestionModel(
      portCode: 'DEHAM',
      portName: 'Port of Hamburg',
      country: 'Germany',
      dwellDays: 5.1,
      berthQueueCount: 14,
      congestionLevel: 'Severe',
      weatherWarning: 'Elbe river tidal delay',
      bunkerFuelPrice: 645.0,
    ),
    PortCongestionModel(
      portCode: 'NLRTM',
      portName: 'Port of Rotterdam',
      country: 'Netherlands',
      dwellDays: 2.1,
      berthQueueCount: 4,
      congestionLevel: 'Optimal',
      weatherWarning: 'North sea moderate swell 1.5m',
      bunkerFuelPrice: 585.0,
    ),
  ];

  // Sanctions & AML Screening Records
  List<SanctionsScreeningRecord> sanctionsRecords = [
    SanctionsScreeningRecord(
      recordId: 'scr-001',
      entityName: 'Al Noor Traders LLC',
      country: 'United Arab Emirates',
      entityType: 'Buyer Company',
      riskLevel: 'Low Risk (Passed)',
      listsChecked: 'OFAC SDN, UN 1267, EU Consolidated, FATF',
      clearanceToken: 'AML-CLR-2026-9041',
      timestamp: 'Today 10:30 AM',
    ),
    SanctionsScreeningRecord(
      recordId: 'scr-002',
      entityName: 'Shenzhen Tech Ltd',
      country: 'China',
      entityType: 'Manufacturer / Exporter',
      riskLevel: 'Low Risk (Passed)',
      listsChecked: 'OFAC, BIS Entity List, UN Sanctions, EU',
      clearanceToken: 'AML-CLR-2026-9042',
      timestamp: 'Yesterday 04:15 PM',
    ),
    SanctionsScreeningRecord(
      recordId: 'scr-003',
      entityName: 'Bank of Dubai Foreign Escrow',
      country: 'UAE',
      entityType: 'Beneficiary Bank',
      riskLevel: 'Low Risk (Passed)',
      listsChecked: 'SWIFT AML, FATF Grey List, Wolfsberg Group',
      clearanceToken: 'AML-CLR-2026-8890',
      timestamp: '12 Oct 2026',
    ),
    SanctionsScreeningRecord(
      recordId: 'scr-004',
      entityName: 'Caspian Heavy Transport LLC',
      country: 'Restricted Region',
      entityType: 'Vessel Carrier',
      riskLevel: 'Flagged (Due Diligence)',
      listsChecked: 'OFAC Maritime Advisory, UN Secondary Sanctions',
      clearanceToken: 'AML-EDD-REQ-4410',
      timestamp: '09 Oct 2026',
    ),
  ];

  void fileDispute(TradeDisputeModel dispute) {
    disputes.insert(0, dispute);
    notifyListeners();
  }

  void resolveDispute(String disputeId, String resolutionStatus) {
    for (var d in disputes) {
      if (d.disputeId == disputeId) {
        d.status = resolutionStatus;
        notifyListeners();
        return;
      }
    }
  }

  void addSanctionsRecord(SanctionsScreeningRecord record) {
    sanctionsRecords.insert(0, record);
    notifyListeners();
  }

  // Letters of Credit (LC) Portfolio
  List<LetterOfCreditModel> lettersOfCredit = [
    LetterOfCreditModel(
      lcId: 'lc-001',
      lcNumber: 'LC-DXB-2026-8812',
      issuingBank: 'Emirates NBD Dubai',
      applicant: 'Al Noor Traders LLC (Dubai)',
      beneficiary: 'Noor Trader / Awais Ahmad (Karachi)',
      amount: 84500.0,
      currency: 'USD',
      expiryDate: '15 Nov 2026',
      latestShipmentDate: '30 Oct 2026',
      status: 'Active / Clean',
      discrepancies: [],
      incoterm: 'CIF Jebel Ali',
    ),
    LetterOfCreditModel(
      lcId: 'lc-002',
      lcNumber: 'LC-FRA-2026-4409',
      issuingBank: 'Deutsche Bank Frankfurt',
      applicant: 'Hamburg Goods GmbH',
      beneficiary: 'Mumbai Spices & Grains',
      amount: 42000.0,
      currency: 'EUR',
      expiryDate: '28 Oct 2026',
      latestShipmentDate: '15 Oct 2026',
      status: 'Discrepancy Detected',
      discrepancies: [
        'Port of Discharge differs: Bremerhaven stated instead of Hamburg',
        'Stale Bill of Lading: presented 24 days after on-board date',
      ],
      incoterm: 'CFR Hamburg',
    ),
    LetterOfCreditModel(
      lcId: 'lc-003',
      lcNumber: 'LC-IST-2026-7731',
      issuingBank: 'Isbank Istanbul',
      applicant: 'Gulf Builders Corp',
      beneficiary: 'Istanbul Steel A.S.',
      amount: 112000.0,
      currency: 'USD',
      expiryDate: '10 Dec 2026',
      latestShipmentDate: '20 Nov 2026',
      status: 'Active / Clean',
      discrepancies: [],
      incoterm: 'FOB Istanbul',
    ),
  ];

  // Freight Route Benchmarks
  List<FreightCalculationModel> freightRoutes = [
    FreightCalculationModel(
      routeId: 'frt-001',
      origin: 'Karachi Port (PKKHI)',
      destination: 'Jebel Ali (AEJEA)',
      ratePerTeu: 650.0,
      transitDays: 4,
      carrier: 'Maersk Line / Hapag-Lloyd',
      mode: 'FCL Sea',
    ),
    FreightCalculationModel(
      routeId: 'frt-002',
      origin: 'Shanghai (CNSHA)',
      destination: 'Karachi Port (PKKHI)',
      ratePerTeu: 1450.0,
      transitDays: 14,
      carrier: 'COSCO Shipping',
      mode: 'FCL Sea',
    ),
    FreightCalculationModel(
      routeId: 'frt-003',
      origin: 'Karachi (PKKHI)',
      destination: 'Hamburg (DEHAM)',
      ratePerTeu: 2150.0,
      transitDays: 24,
      carrier: 'MSC Mediterranean',
      mode: 'FCL Sea',
    ),
    FreightCalculationModel(
      routeId: 'frt-004',
      origin: 'Karachi (KHI)',
      destination: 'Dubai (DXB)',
      ratePerTeu: 1.85,
      transitDays: 1,
      carrier: 'Emirates SkyCargo',
      mode: 'Air Express',
    ),
  ];

  // Quality Inspections & Pre-Shipment Audits
  List<QualityInspectionModel> qualityInspections = [
    QualityInspectionModel(
      inspectionId: 'psi-001',
      orderNumber: 'ORD-5531',
      factory: 'Karachi Weaving Mill No. 4',
      product: '100% Cotton Combed Yarn • Ne 30/1',
      lotQuantity: 24000,
      sampleSize: 315,
      criticalDefects: 0,
      majorDefects: 3,
      minorDefects: 7,
      agency: 'SGS Pakistan (Pvt) Ltd',
      result: 'Passed (AQL 2.5)',
      inspectionDate: '14 Oct 2026',
      certificateNumber: 'SGS-PK-PSI-2026-904',
    ),
    QualityInspectionModel(
      inspectionId: 'psi-002',
      orderNumber: 'ORD-5530',
      factory: 'Punjab Agri Processing Unit',
      product: 'Super Basmati Rice 1121 Sella',
      lotQuantity: 20000,
      sampleSize: 315,
      criticalDefects: 0,
      majorDefects: 2,
      minorDefects: 5,
      agency: 'Bureau Veritas Quality',
      result: 'Passed (AQL 2.5)',
      inspectionDate: '08 Oct 2026',
      certificateNumber: 'BV-AGRI-QC-8812',
    ),
    QualityInspectionModel(
      inspectionId: 'psi-003',
      orderNumber: 'ORD-5538',
      factory: 'Shenzhen Microelectronics Plant',
      product: 'Industrial Pressure Transmitters',
      lotQuantity: 5000,
      sampleSize: 200,
      criticalDefects: 1,
      majorDefects: 8,
      minorDefects: 12,
      agency: 'Intertek Inspection',
      result: 'Rejected / Re-audit',
      inspectionDate: 'Yesterday',
      certificateNumber: 'INTK-REJ-2026-114',
    ),
  ];

  void addLetterOfCredit(LetterOfCreditModel lc) {
    lettersOfCredit.insert(0, lc);
    notifyListeners();
  }

  void updateLcStatus(String lcId, String status) {
    for (var lc in lettersOfCredit) {
      if (lc.lcId == lcId) {
        lc.status = status;
        notifyListeners();
        return;
      }
    }
  }

  void addQualityInspection(QualityInspectionModel psi) {
    qualityInspections.insert(0, psi);
    notifyListeners();
  }
}

class TradeStateInherited extends InheritedNotifier<TradeState> {
  const TradeStateInherited({
    super.key,
    required TradeState notifier,
    required super.child,
  }) : super(notifier: notifier);

  static TradeState of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<TradeStateInherited>();
    assert(inherited != null, 'No TradeStateInherited found in context');
    return inherited!.notifier!;
  }
}

