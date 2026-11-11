import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '11_negotiation_chat_screen.dart';
import '../../widgets/theme_toggle_button.dart';

class QuotationBuilderScreen extends StatefulWidget {
  const QuotationBuilderScreen({super.key});

  @override
  State<QuotationBuilderScreen> createState() => _QuotationBuilderScreenState();
}

class _QuotationBuilderScreenState extends State<QuotationBuilderScreen> {
  String _selectedIncoterm = 'CIF Dubai Port';
  int _validityDays = 15;
  double _commissionPct = 3.0;

  void _showPdfPreview(QuotationModel q, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: AppColors.alertRed, size: 24),
            const SizedBox(width: 8),
            Text(
              'Proforma Quotation ${q.quotationNumber}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Client: ${q.clientName}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                ),
              ),
              Text(
                'Terms: ${q.incoterm} • Validity: ${q.validityDays} Days',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              Divider(height: 20, color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
              ...q.items.map((i) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${i.quantity}x ${i.title}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                          ),
                        ),
                        Text(
                          '\$${i.lineTotal.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
                          ),
                        ),
                      ],
                    ),
                  )),
              Divider(height: 16, color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
              _buildCalcRow('Subtotal', '\$${q.subtotal.toStringAsFixed(2)}', isDark: isDark),
              _buildCalcRow('Freight & Marine Insurance', '\$${q.freightInsurance.toStringAsFixed(2)}', isDark: isDark),
              _buildCalcRow('Agent Commission (${_commissionPct.toStringAsFixed(1)}%)', '\$${q.commissionAmount.toStringAsFixed(2)}', highlight: true, isDark: isDark),
              Divider(height: 16, color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
              _buildCalcRow('Grand Total', '\$${q.grandTotal.toStringAsFixed(2)}', bold: true, isDark: isDark),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Edit',
              style: TextStyle(color: isDark ? AppColors.textSecondaryDark : AppColors.deepNavy),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NegotiationChatScreen()));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quotation dispatched to Buyer & Exporter chat!'),
                  backgroundColor: AppColors.successGreen,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tradeTeal,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Dispatch to Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, {bool highlight = false, bool bold = false, bool isDark = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              color: highlight
                  ? AppColors.tradeTeal
                  : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 14 : 12,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              color: highlight
                  ? AppColors.tradeTeal
                  : (isDark ? AppColors.textPrimaryDark : AppColors.deepNavy),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
    final quote = state.currentQuotation;
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
        title: const Text('Quotation Builder'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Preview PDF',
            onPressed: () => _showPdfPreview(quote, isDark),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quotation Reference Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quote.quotationNumber,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
                          ),
                          Text(
                            'Linked to ${quote.rfqNumber}',
                            style: TextStyle(fontSize: 11, color: context.textSecondary),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.tradeTeal.withValues(alpha: 0.2) : AppColors.tealTint,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          quote.clientName,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(height: 1, color: context.borderColor),
                  const SizedBox(height: 14),

                  // Incoterm & Validity Selectors
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedIncoterm,
                          dropdownColor: context.cardColor,
                          style: TextStyle(fontSize: 13, color: context.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Incoterm 2020',
                            labelStyle: TextStyle(fontSize: 12, color: context.textSecondary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: context.borderColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: [
                            DropdownMenuItem(value: 'CIF Dubai Port', child: Text('CIF Dubai', style: TextStyle(color: context.textPrimary))),
                            DropdownMenuItem(value: 'FOB Karachi Port', child: Text('FOB Karachi', style: TextStyle(color: context.textPrimary))),
                            DropdownMenuItem(value: 'CFR Hamburg', child: Text('CFR Hamburg', style: TextStyle(color: context.textPrimary))),
                            DropdownMenuItem(value: 'EXW Shenzhen', child: Text('EXW Shenzhen', style: TextStyle(color: context.textPrimary))),
                            DropdownMenuItem(value: 'DDP Riyadh', child: Text('DDP Riyadh', style: TextStyle(color: context.textPrimary))),
                          ],
                          onChanged: (val) => setState(() => _selectedIncoterm = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _validityDays,
                          dropdownColor: context.cardColor,
                          style: TextStyle(fontSize: 13, color: context.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Offer Validity',
                            labelStyle: TextStyle(fontSize: 12, color: context.textSecondary),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: context.borderColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: [
                            DropdownMenuItem(value: 7, child: Text('7 Days', style: TextStyle(color: context.textPrimary))),
                            DropdownMenuItem(value: 15, child: Text('15 Days', style: TextStyle(color: context.textPrimary))),
                            DropdownMenuItem(value: 30, child: Text('30 Days', style: TextStyle(color: context.textPrimary))),
                          ],
                          onChanged: (val) => setState(() => _validityDays = val!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Editable Line-Items Table
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quotation Line Items',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: context.textPrimary),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      quote.items.add(
                        QuotationItem(title: 'GaN Fast Charger 65W', quantity: 1000, unitPrice: 3.50),
                      );
                    });
                  },
                  icon: const Icon(Icons.add, size: 16, color: AppColors.tradeTeal),
                  label: const Text('Add Row', style: TextStyle(color: AppColors.tradeTeal, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quote.items.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: context.borderColor),
                itemBuilder: (context, index) {
                  final item = quote.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary)),
                              const SizedBox(height: 2),
                              Text('${item.quantity} units @ \$${item.unitPrice.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 11, color: context.textSecondary)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '\$${item.lineTotal.toStringAsFixed(2)}',
                            textAlign: TextAlign.end,
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: context.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // Calculations Summary Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Automatic Financial Computation',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: context.textPrimary)),
                  const SizedBox(height: 12),
                  _buildCalcRow('Subtotal', '\$${quote.subtotal.toStringAsFixed(2)}', isDark: isDark),
                  _buildCalcRow('Freight & Marine Insurance', '\$${quote.freightInsurance.toStringAsFixed(2)}', isDark: isDark),
                  const SizedBox(height: 8),

                  // Commission Slider
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Broker Commission (${_commissionPct.toStringAsFixed(1)}%)',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tradeTeal)),
                      Text('\$${(quote.subtotal * (_commissionPct / 100)).toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.tradeTeal)),
                    ],
                  ),
                  Slider(
                    value: _commissionPct,
                    min: 1.0,
                    max: 10.0,
                    divisions: 18,
                    activeColor: AppColors.tradeTeal,
                    onChanged: (val) {
                      setState(() => _commissionPct = val);
                      state.updateQuotationCommission(val);
                    },
                  ),

                  Divider(height: 18, color: context.borderColor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Grand Total (USD)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary)),
                      Text(
                        '\$${(quote.subtotal + quote.freightInsurance + (quote.subtotal * (_commissionPct / 100))).toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: isDark ? const Color(0xFF38BDF8) : AppColors.deepNavy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Generate PDF Action
            ElevatedButton.icon(
              onPressed: () => _showPdfPreview(quote, isDark),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? AppColors.tradeTeal : AppColors.deepNavy,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
              label: const Text('Preview Proforma PDF & Send', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}
