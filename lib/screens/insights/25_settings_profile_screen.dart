import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';
import '../../services/biometric_auth_service.dart';
import '../../database/local_database_service.dart';
import '../access/02_login_screen.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({super.key});

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  String _selectedDocCategory = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      final state = TradeStateInherited.of(context);
      final bioEnabled = await LocalDatabaseService.instance.getBiometricPreference(state.currentUser.email);
      if (mounted && state.currentUser.faceIdLogin != bioEnabled) {
        setState(() {
          state.currentUser.faceIdLogin = bioEnabled;
        });
      }
    });
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('TradeLink Support Desk'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Direct Broker Concierge:', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
            SizedBox(height: 4),
            Text(
              'Email: support@tradelink.pk\nHotline: +92 21 3588 1234\nWhatsApp: +92 300 1234567',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
            SizedBox(height: 12),
            Text('Customs HS & Incoterms 2020 regulatory advisory available 24/7.', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out of TradeLink?'),
        content: const Text(
          'Active JWT and refresh tokens will be revoked from device keychain and server sessions table.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final state = TradeStateInherited.of(context);
              state.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertRed),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  // --- Profile Edit Dialog ---
  void _showEditProfileDialog(BuildContext context, UserProfile user, TradeState state) {
    final nameCtrl = TextEditingController(text: user.fullName);
    final companyCtrl = TextEditingController(text: user.companyName);
    final emailCtrl = TextEditingController(text: user.email);
    final phoneCtrl = TextEditingController(text: user.phone);
    final isDark = state.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.tealTint,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.badge_rounded, color: AppColors.tradeTeal, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Edit Profile Info',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.deepNavy,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: companyCtrl,
                style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                decoration: const InputDecoration(
                  labelText: 'Company / Business Entity',
                  prefixIcon: Icon(Icons.business_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailCtrl,
                style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                decoration: const InputDecoration(
                  labelText: 'Phone / WhatsApp',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty || companyCtrl.text.trim().isEmpty) {
                return;
              }
              state.updateUserProfile(
                fullName: nameCtrl.text.trim(),
                companyName: companyCtrl.text.trim(),
                email: emailCtrl.text.trim(),
                phone: phoneCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Profile for ${nameCtrl.text.trim()} updated successfully!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.tradeTeal),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );
  }

  // --- Database Credentials Edit Dialog ---
  void _showEditCredentialsDialog(BuildContext context, UserProfile user, TradeState state) {
    final phoneCtrl = TextEditingController(text: user.phone);
    final emailCtrl = TextEditingController(text: user.email);
    final passwordCtrl = TextEditingController(text: 'awais2284\$#@A');
    bool obscurePassword = true;
    final isDark = state.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlgState) => AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tealTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.security_rounded, color: AppColors.tradeTeal, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Update Login Credentials',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Changes are immediately saved to the local SQLite database and will be verified on your next sign-in.',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: phoneCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'Username / Phone Number',
                    hintText: 'e.g. 03226808199',
                    prefixIcon: Icon(Icons.phone_android_rounded),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: emailCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'Registered Business Email',
                    hintText: 'e.g. user@tradelink.pk',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: passwordCtrl,
                  obscureText: obscurePassword,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword ? Icons.visibility_off : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () => setDlgState(() => obscurePassword = !obscurePassword),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newPhone = phoneCtrl.text.trim();
                final newEmail = emailCtrl.text.trim();
                final newPassword = passwordCtrl.text.trim();

                if (newPhone.isEmpty || newEmail.isEmpty || newPassword.isEmpty) {
                  return;
                }

                final success = await state.updateCredentials(
                  newPhone: newPhone,
                  newEmail: newEmail,
                  newPassword: newPassword,
                );

                if (!context.mounted) return;
                Navigator.pop(ctx);

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text('Login credentials successfully updated and saved in local database!'),
                          ),
                        ],
                      ),
                      backgroundColor: AppColors.successGreen,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to update credentials in database.'),
                      backgroundColor: AppColors.alertRed,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.tradeTeal),
              child: const Text('Save & Update Database'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Create New File / Document Dialog ---
  void _showCreateFileDialog(BuildContext context, TradeState state) {
    final titleCtrl = TextEditingController(text: 'Commercial Invoice CI-${DateTime.now().year}');
    final fileCtrl = TextEditingController(text: 'INV-${DateTime.now().millisecondsSinceEpoch % 10000}.pdf');
    final orderCtrl = TextEditingController(text: 'ORD-5531');
    String selectedCategory = 'Invoices';
    String selectedStatus = 'Pending';
    final isDark = state.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tealTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.upload_file_rounded, color: AppColors.tradeTeal, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Upload / Create File',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'Document Title',
                    hintText: 'e.g. Phytosanitary Certificate',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fileCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'File Name',
                    hintText: 'e.g. PHY-9012.pdf',
                    prefixIcon: Icon(Icons.attach_file_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Invoices', child: Text('Invoices')),
                    DropdownMenuItem(value: 'B/L', child: Text('Bill of Lading (B/L)')),
                    DropdownMenuItem(value: 'Packing', child: Text('Packing List')),
                    DropdownMenuItem(value: 'Customs', child: Text('Customs & Compliance')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedCategory = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'Related Order / Reference',
                    hintText: 'e.g. ORD-5531',
                    prefixIcon: Icon(Icons.tag_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                  decoration: const InputDecoration(
                    labelText: 'Initial Status',
                    prefixIcon: Icon(Icons.verified_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Approved', child: Text('Approved (Verified)')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending Review')),
                    DropdownMenuItem(value: 'Rejected', child: Text('Rejected / Draft')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedStatus = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty || fileCtrl.text.trim().isEmpty) {
                  return;
                }
                final newDoc = TradeDocumentModel(
                  docId: 'doc-${DateTime.now().millisecondsSinceEpoch}',
                  title: titleCtrl.text.trim(),
                  fileName: fileCtrl.text.trim(),
                  category: selectedCategory,
                  sizeKb: 345,
                  status: selectedStatus,
                  uploadDate: 'Today',
                  orderNumber: orderCtrl.text.trim().isNotEmpty ? orderCtrl.text.trim() : 'ORD-5531',
                );
                state.addDocument(newDoc);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('File "${newDoc.fileName}" created & registered successfully!'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.tradeTeal),
              child: const Text('Create File'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Edit Existing File Dialog ---
  void _showEditFileDialog(BuildContext context, TradeDocumentModel doc, TradeState state) {
    final titleCtrl = TextEditingController(text: doc.title);
    final fileCtrl = TextEditingController(text: doc.fileName);
    final orderCtrl = TextEditingController(text: doc.orderNumber);
    String selectedCategory = doc.category;
    String selectedStatus = doc.status;
    final isDark = state.isDarkMode;

    // Validate category exists in list
    const validCategories = ['Invoices', 'B/L', 'Packing', 'Customs'];
    if (!validCategories.contains(selectedCategory)) {
      selectedCategory = 'Customs';
    }

    const validStatuses = ['Approved', 'Pending', 'Rejected'];
    if (!validStatuses.contains(selectedStatus)) {
      selectedStatus = 'Pending';
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDlgState) => AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.navyTint,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.edit_document, color: AppColors.deepNavy, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Edit File Record',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : AppColors.deepNavy,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'Document Title',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: fileCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'File Name',
                    prefixIcon: Icon(Icons.attach_file_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Invoices', child: Text('Invoices')),
                    DropdownMenuItem(value: 'B/L', child: Text('Bill of Lading (B/L)')),
                    DropdownMenuItem(value: 'Packing', child: Text('Packing List')),
                    DropdownMenuItem(value: 'Customs', child: Text('Customs & Compliance')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedCategory = val);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: orderCtrl,
                  style: TextStyle(color: isDark ? Colors.white : AppColors.deepNavy),
                  decoration: const InputDecoration(
                    labelText: 'Order Number',
                    prefixIcon: Icon(Icons.tag_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedStatus,
                  dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    prefixIcon: Icon(Icons.verified_outlined),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Approved', child: Text('Approved')),
                    DropdownMenuItem(value: 'Pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'Rejected', child: Text('Rejected')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDlgState(() => selectedStatus = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty || fileCtrl.text.trim().isEmpty) {
                  return;
                }
                state.updateDocument(
                  doc.docId,
                  title: titleCtrl.text.trim(),
                  fileName: fileCtrl.text.trim(),
                  category: selectedCategory,
                  status: selectedStatus,
                  orderNumber: orderCtrl.text.trim(),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('File "${fileCtrl.text.trim()}" updated successfully!'),
                    backgroundColor: AppColors.successGreen,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.tradeTeal),
              child: const Text('Save Updates'),
            ),
          ],
        ),
      ),
    );
  }

  // --- Delete File Confirmation Dialog ---
  void _showDeleteFileDialog(BuildContext context, TradeDocumentModel doc, TradeState state) {
    final isDark = state.isDarkMode;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_forever_rounded, color: AppColors.alertRed, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'Delete Trade File?',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.deepNavy,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to permanently delete this document?',
              style: TextStyle(fontSize: 13, color: isDark ? Colors.white70 : AppColors.deepNavy),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundDark : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.title,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'File: ${doc.fileName} • ${doc.sizeKb} KB • ${doc.category}',
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'This record will be permanently purged from your compliance vault.',
              style: TextStyle(fontSize: 11, color: AppColors.alertRed),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              state.deleteDocument(doc.docId);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('File "${doc.fileName}" deleted successfully.'),
                  backgroundColor: AppColors.alertRed,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.alertRed),
            child: const Text('Delete Permanently'),
          ),
        ],
      ),
    );
  }

  // --- Inspect / Preview File Details Dialog ---
  void _showInspectFileDialog(BuildContext context, TradeDocumentModel doc, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.tealTint,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.picture_as_pdf_rounded, color: AppColors.tradeTeal, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.deepNavy,
                        ),
                      ),
                      Text(
                        doc.fileName,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: doc.status == 'Approved'
                        ? const Color(0xFFD1FAE5)
                        : doc.status == 'Pending'
                            ? const Color(0xFFFEF3C7)
                            : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    doc.status,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: doc.status == 'Approved'
                          ? AppColors.successGreen
                          : doc.status == 'Pending'
                              ? AppColors.warningAmber
                              : AppColors.alertRed,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _infoRow('Category', doc.category, isDark),
            _infoRow('Order Number', doc.orderNumber, isDark),
            _infoRow('File Size', '${doc.sizeKb} KB (Encrypted Binary)', isDark),
            _infoRow('Upload Date', doc.uploadDate, isDark),
            _infoRow('SHA-256 Checksum', 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', isDark),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.download_rounded, size: 18),
                    label: const Text('Download Copy'),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading ${doc.fileName}...'),
                          backgroundColor: AppColors.tradeTeal,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    label: const Text('Close'),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.deepNavy,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final user = state.currentUser;
    final isDark = state.isDarkMode;

    final filteredDocs = state.documents.where((doc) {
      if (_selectedDocCategory == 'All') return true;
      return doc.category == _selectedDocCategory;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.canvasDark : AppColors.canvasLight,
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
        title: const Text('Settings & Profile'),
        actions: const [
          ThemeToggleButton(transparentBackground: true),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.deepNavy,
                    child: Text(
                      user.fullName.trim().isNotEmpty
                          ? user.fullName.trim().split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase()
                          : 'AA',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : AppColors.deepNavy,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.tealTint,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${user.companyName} • ${user.accountTier}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.tradeTeal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: AppColors.tradeTeal),
                    tooltip: 'Edit Profile Details',
                    onPressed: () => _showEditProfileDialog(context, user, state),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // --- TRADE FILES & COMPLIANCE VAULT SECTION (CRUD) ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Trade Files & Documents',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Create, update, inspect & delete active files',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showCreateFileDialog(context, state),
                  icon: const Icon(Icons.add_rounded, size: 16),
                  label: const Text('Add File', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tradeTeal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Category Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Invoices', 'B/L', 'Packing', 'Customs'].map((cat) {
                  final isSel = _selectedDocCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSel ? Colors.white : (isDark ? Colors.white70 : AppColors.deepNavy),
                        ),
                      ),
                      selected: isSel,
                      selectedColor: AppColors.deepNavy,
                      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
                      onSelected: (val) {
                        if (val) setState(() => _selectedDocCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Files Container / List
            Material(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              ),
              clipBehavior: Clip.antiAlias,
              child: filteredDocs.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(Icons.folder_open_rounded, size: 48, color: isDark ? Colors.white30 : const Color(0xFFCBD5E1)),
                            const SizedBox(height: 10),
                            Text(
                              'No documents found in "$_selectedDocCategory"',
                              style: TextStyle(fontSize: 13, color: isDark ? Colors.white60 : AppColors.textSecondaryLight),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: () => _showCreateFileDialog(context, state),
                              icon: const Icon(Icons.add, size: 16),
                              label: const Text('Upload First File'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredDocs.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                      ),
                      itemBuilder: (ctx, idx) {
                        final doc = filteredDocs[idx];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: doc.category == 'Invoices'
                                  ? AppColors.tealTint
                                  : doc.category == 'B/L'
                                      ? AppColors.navyTint
                                      : doc.category == 'Packing'
                                          ? const Color(0xFFFEF3C7)
                                          : const Color(0xFFE0E7FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              doc.category == 'Invoices'
                                  ? Icons.receipt_long_rounded
                                  : doc.category == 'B/L'
                                      ? Icons.directions_boat_rounded
                                      : doc.category == 'Packing'
                                          ? Icons.inventory_2_rounded
                                          : Icons.verified_user_rounded,
                              size: 20,
                              color: doc.category == 'Invoices'
                                  ? AppColors.tradeTeal
                                  : doc.category == 'B/L'
                                      ? AppColors.deepNavy
                                      : doc.category == 'Packing'
                                          ? AppColors.warningAmber
                                          : const Color(0xFF4F46E5),
                            ),
                          ),
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  doc.title,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : AppColors.deepNavy,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: doc.status == 'Approved'
                                      ? const Color(0xFFD1FAE5)
                                      : doc.status == 'Pending'
                                          ? const Color(0xFFFEF3C7)
                                          : const Color(0xFFFEE2E2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  doc.status,
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w800,
                                    color: doc.status == 'Approved'
                                        ? AppColors.successGreen
                                        : doc.status == 'Pending'
                                            ? AppColors.warningAmber
                                            : AppColors.alertRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${doc.fileName} • ${doc.sizeKb} KB • ${doc.orderNumber}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_red_eye_outlined, size: 18),
                                color: isDark ? Colors.white70 : AppColors.deepNavy,
                                tooltip: 'Inspect File',
                                onPressed: () => _showInspectFileDialog(context, doc, isDark),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                color: AppColors.tradeTeal,
                                tooltip: 'Edit / Update File',
                                onPressed: () => _showEditFileDialog(context, doc, state),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                                color: AppColors.alertRed,
                                tooltip: 'Delete File',
                                onPressed: () => _showDeleteFileDialog(context, doc, state),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 24),

            // Database Login & Credentials Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Database Login & Credentials',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : AppColors.deepNavy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Persistent in SQLite / Local Storage engine',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _showEditCredentialsDialog(context, user, state),
                  icon: const Icon(Icons.key_rounded, size: 16),
                  label: const Text('Edit Credentials', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.tradeTeal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _infoRow('Active Role', user.role.name.toUpperCase(), isDark),
                  _infoRow('Username / Mobile', user.phone, isDark),
                  _infoRow('Registered Email', user.email, isDark),
                  _infoRow('Database Engine', LocalDatabaseService.instance.databaseEngine, isDark),
                  _infoRow('Password Security', 'Configured in SQLite & Verified (awais2284\$#@A)', isDark),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Preferences Toggles
            Text(
              'App & Security Preferences',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 10),

            Material(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push Notifications', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Real-time deal acceptances & vessel alerts', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.pushNotifications,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) => setState(() => user.pushNotifications = val),
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  SwitchListTile(
                    title: const Text('Fingerprint / Face ID Biometric Login', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Hardware biometric authentication via device sensor', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.faceIdLogin,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) async {
                      if (val) {
                        final result = await BiometricAuthService.instance.enrollBiometricsForUser(user.email);
                        if (result.success) {
                          setState(() => user.faceIdLogin = true);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Row(
                                  children: [
                                    Icon(Icons.verified, color: Colors.white, size: 18),
                                    SizedBox(width: 8),
                                    Text('Biometric sensor enrolled! Fast login active.'),
                                  ],
                                ),
                                backgroundColor: AppColors.successGreen,
                              ),
                            );
                          }
                        } else {
                          setState(() => user.faceIdLogin = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(result.errorMessage ?? 'Biometric verification cancelled.'),
                                backgroundColor: AppColors.alertRed,
                              ),
                            );
                          }
                        }
                      } else {
                        await BiometricAuthService.instance.setBiometricEnabledForUser(user.email, false);
                        setState(() => user.faceIdLogin = false);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Biometric sign-in disabled for this device.'),
                            ),
                          );
                        }
                      }
                    },
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  SwitchListTile(
                    title: const Text('Dark Mode Display', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('High contrast dark theme palette', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.darkMode,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) {
                      setState(() => user.darkMode = val);
                      state.setDarkMode(val);
                    },
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  SwitchListTile(
                    title: const Text('Weekly Email Digest', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    subtitle: const Text('Commission reconciliation report to inbox', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                    value: user.emailReports,
                    activeThumbColor: AppColors.tradeTeal,
                    onChanged: (val) => setState(() => user.emailReports = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Regional & Currency
            Text(
              'Localization & Currency',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Default Base Currency', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      DropdownButton<String>(
                        value: user.defaultCurrency,
                        dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'USD', child: Text('USD (\$)')),
                          DropdownMenuItem(value: 'PKR', child: Text('PKR (₨)')),
                          DropdownMenuItem(value: 'EUR', child: Text('EUR (€)')),
                          DropdownMenuItem(value: 'AED', child: Text('AED (د.إ)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => user.defaultCurrency = val);
                        },
                      ),
                    ],
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Language', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      DropdownButton<String>(
                        value: user.preferredLanguage,
                        dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: 'English', child: Text('English (US)')),
                          DropdownMenuItem(value: 'Urdu', child: Text('اردو (Pakistan)')),
                          DropdownMenuItem(value: 'Arabic', child: Text('العربية (Middle East)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => user.preferredLanguage = val);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Support & Sign Out
            Material(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: AppColors.deepNavy),
                    title: const Text('Help & 24/7 Broker Support', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: _showHelpDialog,
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined, color: AppColors.deepNavy),
                    title: const Text('Cross-Border Compliance & Terms', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () {},
                  ),
                  Divider(height: 1, color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0)),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppColors.alertRed),
                    title: const Text('Log Out Securely', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.alertRed)),
                    onTap: _confirmLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
