import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '12_orders_screen.dart';
import '../../widgets/theme_toggle_button.dart';

class NegotiationChatScreen extends StatefulWidget {
  const NegotiationChatScreen({super.key});

  @override
  State<NegotiationChatScreen> createState() => _NegotiationChatScreenState();
}

class _NegotiationChatScreenState extends State<NegotiationChatScreen> {
  final _textController = TextEditingController();

  void _sendMessage() {
    if (_textController.text.trim().isEmpty) return;
    final state = TradeStateInherited.of(context);
    setState(() {
      state.chatMessages.add(
        ChatMessageModel(
          messageId: 'msg-${DateTime.now().millisecondsSinceEpoch}',
          senderName: '${state.currentUser.fullName} (${state.currentUser.role.name})',
          isFromMe: true,
          text: _textController.text.trim(),
          timestamp: DateTime.now(),
        ),
      );
      _textController.clear();
    });
  }

  void _sendQuickReply(String text) {
    _textController.text = text;
    _sendMessage();
  }

  @override
  Widget build(BuildContext context) {
    final state = TradeStateInherited.of(context);
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
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Deal Negotiation Chat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Al Noor Traders • Shenzhen Tech (RFQ-2041)', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
          ],
        ),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Deal context summary strip
          Container(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lock_outline, size: 14, color: AppColors.successGreen),
                    const SizedBox(width: 4),
                    Text(
                      'Incoterm: CIF Dubai Port • Escrow Protected',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: context.textPrimary,
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
                  },
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                  child: const Text('View Orders', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.tradeTeal)),
                ),
              ],
            ),
          ),

          // Message Feed
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.chatMessages.length,
              itemBuilder: (context, index) {
                final msg = state.chatMessages[index];
                return _buildMessageBubble(context, msg, state, isDark);
              },
            ),
          ),

          // Quick Replies Strip
          Container(
            color: context.cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickReplyChip('Confirm CIF Dubai terms', isDark),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Counter at \$4.05/pc', isDark),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Send Proforma Invoice', isDark),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Request Escrow link', isDark),
                ],
              ),
            ),
          ),

          // Chat Input Bar
          Container(
            color: context.cardColor,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: context.textSecondary),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    style: TextStyle(fontSize: 13, color: context.textPrimary),
                    decoration: InputDecoration(
                      hintText: 'Type message or counter-offer...',
                      hintStyle: TextStyle(fontSize: 13, color: context.textSecondary),
                      filled: true,
                      fillColor: context.surfaceColor,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: context.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: context.borderColor),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: AppColors.tradeTeal,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplyChip(String text, bool isDark) {
    return ActionChip(
      label: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: isDark ? AppColors.textPrimaryDark : AppColors.deepNavy,
        ),
      ),
      backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
      side: BorderSide(color: isDark ? const Color(0xFF2E3856) : const Color(0xFFE2E8F0)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () => _sendQuickReply(text),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessageModel msg, TradeState state, bool isDark) {
    final isMe = msg.isFromMe;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Author & Time Label
          Text(
            '${msg.senderName} • ${_formatTime(msg.timestamp)}',
            style: TextStyle(fontSize: 10, color: context.textSecondary),
          ),
          const SizedBox(height: 4),

          // Message Content Container
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe
                  ? (isDark ? AppColors.tradeTeal : AppColors.deepNavy)
                  : context.cardColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(isMe ? 14 : 2),
                bottomRight: Radius.circular(isMe ? 2 : 14),
              ),
              border: isMe ? null : Border.all(color: context.borderColor),
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                fontSize: 13,
                color: isMe ? Colors.white : context.textPrimary,
                height: 1.3,
              ),
            ),
          ),

          // Interactive Counter-Offer Card (if present)
          if (msg.counterOffer != null) ...[
            const SizedBox(height: 8),
            _buildCounterOfferWidget(context, msg.counterOffer!, state, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildCounterOfferWidget(BuildContext context, CounterOfferCard offer, TradeState state, bool isDark) {
    final isAccepted = offer.status == 'Accepted';

    return Container(
      width: 290,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isAccepted ? AppColors.successGreen : AppColors.gold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                  Icon(
                    isAccepted ? Icons.check_circle : Icons.handshake,
                    size: 18,
                    color: isAccepted ? AppColors.successGreen : AppColors.gold,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isAccepted ? 'Counter-Offer Accepted' : 'Active Counter-Offer',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: isAccepted
                          ? AppColors.successGreen
                          : (isDark ? AppColors.textPrimaryDark : AppColors.deepNavy),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isAccepted ? AppColors.greenTint : AppColors.goldTint,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  offer.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isAccepted ? AppColors.successGreen : AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(offer.productName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: context.textPrimary)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revised Quantity:', style: TextStyle(fontSize: 11, color: context.textSecondary)),
              Text('${offer.revisedQuantity} pcs', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revised Unit Price:', style: TextStyle(fontSize: 11, color: context.textSecondary)),
              Text('\$${offer.revisedUnitPrice.toStringAsFixed(2)}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: context.textPrimary)),
            ],
          ),
          Divider(height: 12, color: context.borderColor),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Revised Total (USD):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: context.textPrimary)),
              Text(
                '\$${offer.revisedTotal.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.tradeTeal),
              ),
            ],
          ),
          if (!isAccepted) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Counter proposed at \$4.00/pc')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: Size.zero,
                      side: BorderSide(color: context.borderColor),
                      foregroundColor: context.textPrimary,
                    ),
                    child: const Text('Counter', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => state.acceptCounterOffer(offer.offerId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.successGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Accept', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
