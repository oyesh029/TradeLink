import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class QualityInspectionScreen extends StatefulWidget {
  const QualityInspectionScreen({super.key});

  @override
  State<QualityInspectionScreen> createState() => _QualityInspectionScreenState();
}

class _QualityInspectionScreenState extends State<QualityInspectionScreen> {
  double _lotQuantity = 20000;

  void _showBookInspectionSheet() {
    final orderCtrl = TextEditingController(text: 'ORD-5539');
    final factoryCtrl = TextEditingController(text: 'Faisalabad Textile Hub');
    final productCtrl = TextEditingController(text: 'Bedlinen Cotton 300TC');
    String agency = 'SGS';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: context.borderColor, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.successGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.verified_rounded, color: AppColors.successGreen, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Book Pre-Shipment Inspection (PSI)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: orderCtrl,
                style: TextStyle(fontSize: 12, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Order Number',
                  filled: true,
                  fillColor: context.surfaceColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: factoryCtrl,
                style: TextStyle(fontSize: 12, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Factory / Production Site',
                  filled: true,
                  fillColor: context.surfaceColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: productCtrl,
                style: TextStyle(fontSize: 12, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Cargo Product Description',
                  filled: true,
                  fillColor: context.surfaceColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: agency,
                dropdownColor: context.cardColor,
                style: TextStyle(fontSize: 12, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Inspection Agency',
                  filled: true,
                  fillColor: context.surfaceColor,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: const [
                  DropdownMenuItem(value: 'SGS', child: Text('SGS Inspection Services')),
                  DropdownMenuItem(value: 'Bureau Veritas', child: Text('Bureau Veritas Quality')),
                  DropdownMenuItem(value: 'Intertek', child: Text('Intertek Testing')),
                ],
                onChanged: (val) {
                  if (val != null) setSheetState(() => agency = val);
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final newInspection = QualityInspectionModel(
                      inspectionId: 'psi-${DateTime.now().millisecondsSinceEpoch}',
                      orderNumber: orderCtrl.text.trim(),
                      factory: factoryCtrl.text.trim(),
                      product: productCtrl.text.trim(),
                      lotQuantity: 15000,
                      sampleSize: 315,
                      criticalDefects: 0,
                      majorDefects: 1,
                      minorDefects: 4,
                      agency: agency,
                      result: 'Passed (AQL 2.5)',
                      inspectionDate: 'Just Scheduled',
                      certificateNumber: 'COI-PENDING-${DateTime.now().millisecondsSinceEpoch % 1000}',
                    );
                    final state = TradeStateInherited.of(context);
                    state.addQualityInspection(newInspection);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('PSI auditor dispatched for ${orderCtrl.text}.'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                  icon: const Icon(Icons.send, size: 18, color: Colors.white),
                  label: const Text('Confirm PSI Dispatch', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepNavy,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCertificateDialog(QualityInspectionModel psi) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.verified_sharp, color: AppColors.successGreen, size: 24),
            const SizedBox(width: 8),
            Text(
              'Certificate of Inspection (COI)',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
            ),
          ],
        ),
        content: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.borderColor),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'ISO 2859-1 (MIL-STD-105E) VERIFIED',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.tradeTeal),
                ),
              ),
              const Divider(height: 16),
              _buildRow('Certificate #:', psi.certificateNumber),
              _buildRow('Audited Order:', psi.orderNumber),
              _buildRow('Manufacturer:', psi.factory),
              _buildRow('Product Cargo:', psi.product),
              _buildRow('Sample Tested:', '${psi.sampleSize} units from ${psi.lotQuantity} lot'),
              _buildRow('AQL Verdict:', psi.result),
              _buildRow('Agency Seal:', psi.agency),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Clearance granted: Goods ready for container containerization and port dispatch.',
                  style: TextStyle(fontSize: 10, color: AppColors.successGreen, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Close', style: TextStyle(color: context.textSecondary)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Certificate of Inspection saved and attached to Bill of Lading packet.'),
                  backgroundColor: AppColors.deepNavy,
                ),
              );
            },
            icon: const Icon(Icons.download, size: 16, color: Colors.white),
            label: const Text('Download COI', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.deepNavy,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(label, style: TextStyle(fontSize: 11, color: context.textSecondary)),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: context.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final inspections = state.qualityInspections;

    // ISO 2859-1 AQL Calculations
    int sampleSize;
    int maxMajorDefects;
    int maxMinorDefects;

    if (_lotQuantity <= 3200) {
      sampleSize = 125;
      maxMajorDefects = 7;
      maxMinorDefects = 10;
    } else if (_lotQuantity <= 10000) {
      sampleSize = 200;
      maxMajorDefects = 10;
      maxMinorDefects = 14;
    } else if (_lotQuantity <= 35000) {
      sampleSize = 315;
      maxMajorDefects = 14;
      maxMinorDefects = 21;
    } else {
      sampleSize = 500;
      maxMajorDefects = 21;
      maxMinorDefects = 21;
    }

    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        title: const Text('PSI Quality Audit & AQL 2.5'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task, color: Colors.white),
            tooltip: 'Book Inspection',
            onPressed: _showBookInspectionSheet,
          ),
          const ThemeToggleButton(transparentBackground: true),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // AQL 2.5 Calculator Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: context.borderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.successGreen.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.analytics_outlined, color: AppColors.successGreen, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'ISO 2859-1 Sampling Table',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.deepNavy.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'LEVEL II NORMAL',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Production Lot Size:', style: TextStyle(fontSize: 12, color: context.textSecondary)),
                    Text('${_lotQuantity.toInt()} units', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: context.textPrimary)),
                  ],
                ),
                Slider(
                  value: _lotQuantity,
                  min: 1000,
                  max: 50000,
                  divisions: 49,
                  activeColor: AppColors.tradeTeal,
                  onChanged: (v) => setState(() => _lotQuantity = v),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.surfaceColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAqlStat('Sample Pull', '$sampleSize units'),
                      _buildAqlStat('Max Major (2.5)', '$maxMajorDefects defects'),
                      _buildAqlStat('Max Minor (4.0)', '$maxMinorDefects defects'),
                      _buildAqlStat('Critical Max', '0 defects'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Inspections List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pre-Shipment Inspection Dossiers',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
              ),
              TextButton.icon(
                onPressed: _showBookInspectionSheet,
                icon: const Icon(Icons.add, size: 16, color: AppColors.tradeTeal),
                label: const Text('Book Audit', style: TextStyle(fontSize: 12, color: AppColors.tradeTeal)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          ...inspections.map((psi) {
            final isRejected = psi.result.contains('Rejected');
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isRejected ? AppColors.alertRed.withValues(alpha: 0.5) : context.borderColor,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: context.isDark ? 0.2 : 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${psi.orderNumber} • ${psi.agency}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: context.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (isRejected ? AppColors.alertRed : AppColors.successGreen).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          psi.result,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: isRejected ? AppColors.alertRed : AppColors.successGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${psi.product} • ${psi.factory}',
                    style: TextStyle(fontSize: 11, color: context.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sample: ${psi.sampleSize} units | Critical: ${psi.criticalDefects} | Major: ${psi.majorDefects}',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: context.textPrimary),
                      ),
                      InkWell(
                        onTap: () => _showCertificateDialog(psi),
                        child: const Text(
                          'View Certificate',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAqlStat(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 9, color: context.textSecondary)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: context.textPrimary)),
      ],
    );
  }
}
