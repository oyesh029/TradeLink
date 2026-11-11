import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  String _selectedCategory = 'All';

  void _showUploadDialog() {
    final isDark = context.isDark;
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload or Scan Trade Document',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: context.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Encrypted SHA-256 cloud storage attached to active deal ORD-5531',
              style: TextStyle(fontSize: 12, color: context.textSecondary),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.tradeTeal.withValues(alpha: 0.2) : AppColors.tealTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.camera_alt_outlined, color: AppColors.tradeTeal),
              ),
              title: Text('Camera Document Scanner', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: context.textPrimary)),
              subtitle: Text('Auto-detect edges & OCR invoice numbers', style: TextStyle(fontSize: 11, color: context.textSecondary)),
              onTap: () {
                Navigator.pop(ctx);
                _simulateUpload('Phytosanitary Certificate PHY-9012.pdf', 'Customs');
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : AppColors.navyTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.upload_file_outlined, color: isDark ? Colors.white : AppColors.deepNavy),
              ),
              title: Text('Upload PDF / JPG File', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: context.textPrimary)),
              subtitle: Text('Up to 25 MB encrypted object file', style: TextStyle(fontSize: 11, color: context.textSecondary)),
              onTap: () {
                Navigator.pop(ctx);
                _simulateUpload('Inspection Certificate PSI-5531.pdf', 'Customs');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _simulateUpload(String title, String category) {
    final state = TradeStateInherited.of(context);
    state.addDocument(
      TradeDocumentModel(
        docId: 'doc-${DateTime.now().millisecondsSinceEpoch}',
        title: title.replaceAll('.pdf', ''),
        fileName: title,
        category: category,
        sizeKb: 340,
        status: 'Pending',
        uploadDate: 'Today',
        orderNumber: 'ORD-5531',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title uploaded and queued for KYC & compliance verification!'),
        backgroundColor: AppColors.successGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);

    final filteredDocs = state.documents.where((doc) {
      if (_selectedCategory == 'All') return true;
      return doc.category == _selectedCategory;
    }).toList();

    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.canvasColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
          tooltip: 'Back to Dashboard',
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Trade Documents Vault'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.cloud_upload_outlined),
            onPressed: _showUploadDialog,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadDialog,
        backgroundColor: AppColors.tradeTeal,
        icon: const Icon(Icons.add_a_photo_outlined, color: Colors.white, size: 20),
        label: const Text('Upload / Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            color: context.cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryChip('All (${state.documents.length})', 'All', isDark),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Invoices', 'Invoices', isDark),
                  const SizedBox(width: 8),
                  _buildCategoryChip('B/L', 'B/L', isDark),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Packing', 'Packing', isDark),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Customs', 'Customs', isDark),
                ],
              ),
            ),
          ),

          // Documents List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredDocs.length,
              itemBuilder: (context, index) {
                final doc = filteredDocs[index];
                return _buildDocumentTile(doc, context, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String key, bool isDark) {
    final isSelected = _selectedCategory == key;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = key),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.tradeTeal : AppColors.deepNavy)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : (isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTile(TradeDocumentModel doc, BuildContext context, bool isDark) {
    Color statusColor;
    Color statusTint;
    if (doc.status == 'Approved') {
      statusColor = AppColors.successGreen;
      statusTint = AppColors.greenTint;
    } else if (doc.status == 'Rejected') {
      statusColor = AppColors.alertRed;
      statusTint = AppColors.redTint;
    } else {
      statusColor = AppColors.gold;
      statusTint = AppColors.goldTint;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.picture_as_pdf, color: AppColors.alertRed, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.fileName,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  '${doc.sizeKb} KB • ${doc.uploadDate} • ${doc.orderNumber}',
                  style: TextStyle(fontSize: 11, color: context.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: statusTint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              doc.status,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: statusColor),
            ),
          ),
        ],
      ),
    );
  }
}
