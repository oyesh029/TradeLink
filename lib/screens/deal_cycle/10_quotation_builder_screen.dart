import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '11_negotiation_chat_screen.dart';

class QuotationBuilderScreen extends StatefulWidget {
  const QuotationBuilderScreen({super.key});

  @override
  State<QuotationBuilderScreen> createState() => _QuotationBuilderScreenState();
}

class _QuotationBuilderScreenState extends State<QuotationBuilderScreen> {
  String _selectedIncoterm = 'CIF Dubai Port';
  int _validityDays = 15;
  double _commissionPct = 3.0;

  void _showPdfPreview(QuotationModel q) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.picture_as_pdf, color: AppColors.alertRed, size: 24),
            const SizedBox(width: 8),
            Text('Proforma Quotation ${q.quotationNumber}'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Client: ${q.clientName}', style: const TextStyle(fontWeight: FontWeight.w700)),
              Text('Terms: ${q.incoterm} • Validity: ${q.validityDays} Days', style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight)),
              const Divider(height: 20),
              ...q.items.map((i) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${i.quantity}x ${i.title}', style: const TextStyle(fontSize: 12)),
                        Text('\$${i.lineTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )),
              const Divider(height: 16),
              _buildCalcRow('Subtotal', '\$${q.subtotal.toStringAsFixed(2)}'),
              _buildCalcRow('Freight & Marine Insurance', '\$${q.freightInsurance.toStringAsFixed(2)}'),
              _buildCalcRow('Agent Commission (${_commissionPct.toStringAsFixed(1)}%)', '\$${q.commissionAmount.toStringAsFixed(2)}', highlight: true),
              const Divider(height: 16),
              _buildCalcRow('Grand Total', '\$${q.grandTotal.toStringAsFixed(2)}', bold: true),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Edit')),
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
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Dispatch to Chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildCalcRow(String label, String value, {bool highlight = false, bool bold = false}) {
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
              color: highlight ? AppColors.tradeTeal : AppColors.textPrimaryLight,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 14 : 12,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w700,
              color: highlight ? AppColors.tradeTeal : AppColors.deepNavy,
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

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
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
          IconButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            tooltip: 'Preview PDF',
            onPressed: () => _showPdfPreview(quote),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
                          ),
                          Text(
                            'Linked to ${quote.rfqNumber}',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.tealTint,
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
                  const Divider(height: 1),
                  const SizedBox(height: 14),

                  // Incoterm & Validity Selectors
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _selectedIncoterm,
                          decoration: const InputDecoration(
                            labelText: 'Incoterm 2020',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 'CIF Dubai Port', child: Text('CIF Dubai')),
                            DropdownMenuItem(value: 'FOB Karachi Port', child: Text('FOB Karachi')),
                            DropdownMenuItem(value: 'CFR Hamburg', child: Text('CFR Hamburg')),
                            DropdownMenuItem(value: 'EXW Shenzhen', child: Text('EXW Shenzhen')),
                            DropdownMenuItem(value: 'DDP Riyadh', child: Text('DDP Riyadh')),
                          ],
                          onChanged: (val) => setState(() => _selectedIncoterm = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          initialValue: _validityDays,
                          decoration: const InputDecoration(
                            labelText: 'Offer Validity',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          ),
                          items: const [
                            DropdownMenuItem(value: 7, child: Text('7 Days')),
                            DropdownMenuItem(value: 15, child: Text('15 Days')),
                            DropdownMenuItem(value: 30, child: Text('30 Days')),
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
                const Text(
                  'Quotation Line Items',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.deepNavy),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      quote.items.add(
                        QuotationItem(title: 'GaN Fast Charger 65W', quantity: 1000, unitPrice: 3.50),
                      );
                    });
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Row'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quote.items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
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
                              Text(item.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                              const SizedBox(height: 2),
                              Text('${item.quantity} units @ \$${item.unitPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '\$${item.lineTotal.toStringAsFixed(2)}',
                            textAlign: TextAlign.end,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.deepNavy),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Automatic Financial Computation',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
                  const SizedBox(height: 12),
                  _buildCalcRow('Subtotal', '\$${quote.subtotal.toStringAsFixed(2)}'),
                  _buildCalcRow('Freight & Marine Insurance', '\$${quote.freightInsurance.toStringAsFixed(2)}'),
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

                  const Divider(height: 18),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Grand Total (USD)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.deepNavy)),
                      Text(
                        '\$${(quote.subtotal + quote.freightInsurance + (quote.subtotal * (_commissionPct / 100))).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.deepNavy),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Generate PDF Action
            ElevatedButton.icon(
              onPressed: () => _showPdfPreview(quote),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.deepNavy,
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
