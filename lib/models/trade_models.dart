import 'package:flutter/material.dart';

enum UserRole { agent, importer, exporter, admin }

class UserProfile {
  final String userId;
  final String fullName;
  final String email;
  final String companyName;
  final String phone;
  final UserRole role;
  final String accountTier;
  bool pushNotifications;
  bool faceIdLogin;
  bool darkMode;
  bool emailReports;
  String preferredLanguage;
  String defaultCurrency;

  UserProfile({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.companyName,
    required this.phone,
    required this.role,
    this.accountTier = 'Premium Agent',
    this.pushNotifications = true,
    this.faceIdLogin = true,
    this.darkMode = false,
    this.emailReports = true,
    this.preferredLanguage = 'English',
    this.defaultCurrency = 'USD',
  });
}

class ClientModel {
  final String clientId;
  final String companyName;
  final String country;
  final String countryCode;
  final String role; // 'Importer' or 'Exporter'
  final String status; // 'Active', 'Pending', 'Inactive'
  final String contactPerson;
  final String email;
  final String phone;
  final String tradeLicense;
  final String paymentTerms;
  final int totalDeals;
  final double tradeVolumeUsd;
  final double rating;
  final List<String> notes;

  ClientModel({
    required this.clientId,
    required this.companyName,
    required this.country,
    required this.countryCode,
    required this.role,
    required this.status,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.tradeLicense,
    required this.paymentTerms,
    required this.totalDeals,
    required this.tradeVolumeUsd,
    required this.rating,
    required this.notes,
  });
}

class SupplierModel {
  final String supplierId;
  final String companyName;
  final String country;
  final String city;
  final String category; // 'Electronics', 'Textiles', 'Food', 'Steel'
  final String badge; // 'GOLD', 'VERIFIED', 'STANDARD'
  final double rating;
  final int reviewsCount;
  final String mainProducts;
  final double minOrderValue;
  final int leadTimeDays;
  final double latitude;
  final double longitude;

  SupplierModel({
    required this.supplierId,
    required this.companyName,
    required this.country,
    required this.city,
    required this.category,
    required this.badge,
    required this.rating,
    required this.reviewsCount,
    required this.mainProducts,
    required this.minOrderValue,
    required this.leadTimeDays,
    required this.latitude,
    required this.longitude,
  });
}

class ProductModel {
  final String productId;
  final String productName;
  final String hsCode;
  final String category;
  final String unit;
  final double indicativePrice;
  final String supplierName;
  final String sku;
  final Color cardTint;

  ProductModel({
    required this.productId,
    required this.productName,
    required this.hsCode,
    required this.category,
    required this.unit,
    required this.indicativePrice,
    required this.supplierName,
    required this.sku,
    required this.cardTint,
  });
}

class RfqModel {
  final String rfqId;
  final String rfqNumber;
  final String buyerName;
  final String productName;
  final String targetQuantity;
  final String urgency; // 'Low', 'Normal', 'High', 'Critical'
  final String deadlineText;
  String status; // 'Open', 'Quoted', 'Won', 'Closed'
  final DateTime createdAt;

  RfqModel({
    required this.rfqId,
    required this.rfqNumber,
    required this.buyerName,
    required this.productName,
    required this.targetQuantity,
    required this.urgency,
    required this.deadlineText,
    required this.status,
    required this.createdAt,
  });
}

class QuotationItem {
  final String title;
  int quantity;
  double unitPrice;

  QuotationItem({
    required this.title,
    required this.quantity,
    required this.unitPrice,
  });

  double get lineTotal => quantity * unitPrice;
}

class QuotationModel {
  final String quotationId;
  final String quotationNumber;
  final String clientName;
  final String rfqNumber;
  final String incoterm; // 'CIF Dubai', 'FOB Karachi', 'EXW', 'DDP'
  final int validityDays;
  final List<QuotationItem> items;
  final double freightInsurance;
  final double commissionRatePct;
  final String status;

  QuotationModel({
    required this.quotationId,
    required this.quotationNumber,
    required this.clientName,
    required this.rfqNumber,
    required this.incoterm,
    required this.validityDays,
    required this.items,
    required this.freightInsurance,
    required this.commissionRatePct,
    required this.status,
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.lineTotal);
  double get commissionAmount => subtotal * (commissionRatePct / 100);
  double get grandTotal => subtotal + freightInsurance + commissionAmount;
}

class CounterOfferCard {
  final String offerId;
  final String productName;
  final int revisedQuantity;
  final double revisedUnitPrice;
  final double revisedTotal;
  String status; // 'Pending', 'Accepted', 'Countered', 'Rejected'

  CounterOfferCard({
    required this.offerId,
    required this.productName,
    required this.revisedQuantity,
    required this.revisedUnitPrice,
    required this.revisedTotal,
    this.status = 'Pending',
  });
}

class ChatMessageModel {
  final String messageId;
  final String senderName;
  final bool isFromMe;
  final String text;
  final CounterOfferCard? counterOffer;
  final DateTime timestamp;

  ChatMessageModel({
    required this.messageId,
    required this.senderName,
    required this.isFromMe,
    required this.text,
    this.counterOffer,
    required this.timestamp,
  });
}

class OrderMilestone {
  final int step;
  final String title;
  final String dateText;
  bool isCompleted;
  final String remarks;

  OrderMilestone({
    required this.step,
    required this.title,
    required this.dateText,
    required this.isCompleted,
    required this.remarks,
  });
}

class TradeOrderModel {
  final String orderId;
  final String orderNumber;
  final String buyerName;
  final String sellerName;
  final String productSummary;
  final double orderValue;
  final double agentCommission;
  String status; // 'Processing', 'Shipped', 'Delivered', 'Cancelled'
  int progressPct;
  final List<OrderMilestone> milestones;

  TradeOrderModel({
    required this.orderId,
    required this.orderNumber,
    required this.buyerName,
    required this.sellerName,
    required this.productSummary,
    required this.orderValue,
    required this.agentCommission,
    required this.status,
    required this.progressPct,
    required this.milestones,
  });
}

class ShipmentModel {
  final String shipmentId;
  final String containerNumber;
  final String blNumber;
  final String vesselName;
  final String containerType;
  final String originPort;
  final String destinationPort;
  final String departedDate;
  final String etaDate;
  final String status; // 'In Transit', 'At Sea', 'Delivered'
  final int progressPct;
  final List<String> routeCheckpoints;

  ShipmentModel({
    required this.shipmentId,
    required this.containerNumber,
    required this.blNumber,
    required this.vesselName,
    required this.containerType,
    required this.originPort,
    required this.destinationPort,
    required this.departedDate,
    required this.etaDate,
    required this.status,
    required this.progressPct,
    required this.routeCheckpoints,
  });
}

class TradeDocumentModel {
  final String docId;
  final String title;
  final String fileName;
  final String category; // 'Invoices', 'B/L', 'Packing', 'Customs'
  final int sizeKb;
  String status; // 'Approved', 'Pending', 'Rejected'
  final String uploadDate;
  final String orderNumber;

  TradeDocumentModel({
    required this.docId,
    required this.title,
    required this.fileName,
    required this.category,
    required this.sizeKb,
    required this.status,
    required this.uploadDate,
    required this.orderNumber,
  });
}

class HsCodeModel {
  final String hsCode;
  final String description;
  final double customsDutyPct;
  final double salesTaxPct;
  final double additionalDutyPct;
  final double withholdingTaxPct;

  HsCodeModel({
    required this.hsCode,
    required this.description,
    required this.customsDutyPct,
    required this.salesTaxPct,
    required this.additionalDutyPct,
    required this.withholdingTaxPct,
  });

  double get totalDutyPct =>
      customsDutyPct + salesTaxPct + additionalDutyPct + withholdingTaxPct;
}

class ComplianceCheckItem {
  final String title;
  bool isChecked;

  ComplianceCheckItem({required this.title, this.isChecked = false});
}

class LedgerEntryModel {
  final String entryId;
  final String orderNumber;
  final String clientName;
  final double commissionAmount;
  final String status; // 'Paid', 'Pending'
  final String paymentMethod;
  final String dateText;

  LedgerEntryModel({
    required this.entryId,
    required this.orderNumber,
    required this.clientName,
    required this.commissionAmount,
    required this.status,
    required this.paymentMethod,
    required this.dateText,
  });
}

class InvoiceModel {
  final String invoiceId;
  final String invoiceNumber;
  final String clientName;
  final double amount;
  final String issueDate;
  final String dueDate;
  String status; // 'Paid', 'Unpaid', 'Overdue'

  InvoiceModel({
    required this.invoiceId,
    required this.invoiceNumber,
    required this.clientName,
    required this.amount,
    required this.issueDate,
    required this.dueDate,
    required this.status,
  });
}

class CurrencyRateModel {
  final String code;
  final String name;
  final double rateToUsd;
  final double dailyChangePct;
  final List<double> sparkline;

  CurrencyRateModel({
    required this.code,
    required this.name,
    required this.rateToUsd,
    required this.dailyChangePct,
    required this.sparkline,
  });
}

class NotificationModel {
  final String notificationId;
  final String title;
  final String detail;
  final String category; // 'Orders', 'Payments', 'System'
  final String group; // 'Today', 'Earlier'
  final String timeAgo;
  bool isRead;

  NotificationModel({
    required this.notificationId,
    required this.title,
    required this.detail,
    required this.category,
    required this.group,
    required this.timeAgo,
    this.isRead = false,
  });
}

class TaskItemModel {
  final String taskId;
  final String title;
  final String scheduledTime;
  final String priority; // 'Urgent', 'High', 'Normal'
  bool isDone;

  TaskItemModel({
    required this.taskId,
    required this.title,
    required this.scheduledTime,
    required this.priority,
    this.isDone = false,
  });
}
