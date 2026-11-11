import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../theme/app_colors.dart';
import '../deal_cycle/10_quotation_builder_screen.dart';
import '../deal_cycle/11_negotiation_chat_screen.dart';
import '../../widgets/theme_toggle_button.dart';

class ClientProfileScreen extends StatefulWidget {
  final ClientModel client;

  const ClientProfileScreen({super.key, required this.client});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addNote() {
    if (_noteController.text.trim().isEmpty) return;
    setState(() {
      widget.client.notes.insert(0, _noteController.text.trim());
      _noteController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note added to client timeline')),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    final client = widget.client;
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
        title: Text(client.companyName),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                color: context.cardColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Row with Avatar & Status
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : AppColors.deepNavy,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: isDark ? const Color(0xFF38BDF8) : Colors.transparent),
                          ),
                          child: Center(
                            child: Text(
                              client.companyName.substring(0, 2).toUpperCase(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                color: isDark ? const Color(0xFF38BDF8) : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      client.companyName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: context.textPrimary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.verified, color: AppColors.tradeTeal, size: 18),
                                ],
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${client.country} • ${client.role}',
                                style: TextStyle(fontSize: 13, color: context.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.greenTint.withValues(alpha: 0.2) : AppColors.greenTint,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            client.status,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.successGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Quick Stats Row (Deals, Trade Volume, Rating)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: context.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatColumn('Total Deals', '${client.totalDeals} Deals', context),
                          Container(width: 1, height: 28, color: context.borderColor),
                          _buildStatColumn('Trade Volume', '\$${(client.tradeVolumeUsd / 1000).toStringAsFixed(0)}K', context),
                          Container(width: 1, height: 28, color: context.borderColor),
                          _buildStatColumn('Rating', '${client.rating} ★', context),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Call, Message & Create New Deal Shortcuts
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Dialing ${client.phone}...')),
                              );
                            },
                            icon: Icon(Icons.call_outlined, size: 18, color: context.textPrimary),
                            label: Text('Call', style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w700)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              side: BorderSide(color: context.borderColor),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const NegotiationChatScreen()),
                              );
                            },
                            icon: Icon(Icons.chat_bubble_outline, size: 18, color: context.textPrimary),
                            label: Text('Message', style: TextStyle(color: context.textPrimary, fontWeight: FontWeight.w700)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              side: BorderSide(color: context.borderColor),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const QuotationBuilderScreen()),
                              );
                            },
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('New Deal', style: TextStyle(fontWeight: FontWeight.w700)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tradeTeal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 11),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy,
                  unselectedLabelColor: context.textSecondary,
                  indicatorColor: AppColors.tradeTeal,
                  indicatorWeight: 3,
                  tabs: const [
                    Tab(text: 'Details'),
                    Tab(text: 'Deals'),
                    Tab(text: 'Documents'),
                    Tab(text: 'Notes'),
                  ],
                ),
                context.cardColor,
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            // Sub-Tab 1: Details
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildInfoCard(
                  title: 'Primary Contact Person',
                  rows: [
                    {'label': 'Name', 'value': client.contactPerson},
                    {'label': 'Direct Email', 'value': client.email},
                    {'label': 'Phone', 'value': client.phone},
                    {'label': 'Designation', 'value': 'Managing Director'},
                  ],
                  context: context,
                ),
                const SizedBox(height: 12),
                _buildInfoCard(
                  title: 'Regulatory & Trade Terms',
                  rows: [
                    {'label': 'Trade License No.', 'value': client.tradeLicense},
                    {'label': 'Standard Payment Terms', 'value': client.paymentTerms},
                    {'label': 'Preferred Incoterm', 'value': 'CIF Dubai Port'},
                    {'label': 'KYC Verification', 'value': 'Verified • Active'},
                  ],
                  context: context,
                ),
              ],
            ),

            // Sub-Tab 2: Deals
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDealItem('ORD-5531', 'LED Panel Lights 40W (5,000 pcs)', '\$21,000', 'Processing', context),
                _buildDealItem('Q-1042', 'Power Banks & LED Fixtures (Quotation)', '\$42,385', 'Sent', context),
                _buildDealItem('ORD-5512', 'Industrial USB-C Cables (10,000 pcs)', '\$14,500', 'Delivered', context),
              ],
            ),

            // Sub-Tab 3: Documents
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildDocItem('Commercial Invoice INV-2209.pdf', '240 KB • Approved', Icons.picture_as_pdf, context),
                _buildDocItem('Bill of Lading BL-MSKU7781.pdf', '410 KB • Approved', Icons.description, context),
                _buildDocItem('Certificate of Origin COO-5531.pdf', '320 KB • Verified', Icons.verified_user, context),
                _buildDocItem('Trade License DED-882341.pdf', '1.2 MB • Verified', Icons.business, context),
              ],
            ),

            // Sub-Tab 4: Notes
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Add note input
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: context.borderColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _noteController,
                          style: TextStyle(fontSize: 13, color: context.textPrimary),
                          decoration: InputDecoration(
                            hintText: 'Add a private interaction note...',
                            hintStyle: TextStyle(fontSize: 13, color: context.textSecondary),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: AppColors.tradeTeal),
                        onPressed: _addNote,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ...client.notes.map((note) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: context.borderColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes_outlined, color: AppColors.tradeTeal, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              note,
                              style: TextStyle(fontSize: 13, color: context.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: context.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required List<Map<String, String>> rows, required BuildContext context}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimary)),
          const SizedBox(height: 12),
          ...rows.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(row['label']!, style: TextStyle(fontSize: 12, color: context.textSecondary)),
                    Text(row['value']!, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: context.textPrimary)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildDealItem(String code, String summary, String amount, String status, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(code, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: context.textPrimary)),
              const SizedBox(height: 3),
              Text(summary, style: TextStyle(fontSize: 12, color: context.textSecondary)),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.tradeTeal)),
              const SizedBox(height: 3),
              Text(status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.gold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDocItem(String name, String meta, IconData icon, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.borderColor),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.tradeTeal, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary)),
                const SizedBox(height: 2),
                Text(meta, style: TextStyle(fontSize: 11, color: context.textSecondary)),
              ],
            ),
          ),
          Icon(Icons.download_outlined, color: context.textSecondary, size: 20),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar, this.backgroundColor);
  final TabBar _tabBar;
  final Color backgroundColor;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor;
  }
}
