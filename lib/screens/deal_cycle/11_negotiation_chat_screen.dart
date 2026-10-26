import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '12_orders_screen.dart';

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

    return Scaffold(
      backgroundColor: AppColors.canvasLight,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('11. Deal Negotiation Chat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text('Al Noor Traders • Shenzhen Tech (RFQ-2041)', style: TextStyle(fontSize: 11, color: Color(0xFFCBD5E1))),
          ],
        ),
        actions: [
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
            color: const Color(0xFFF1F5F9),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 14, color: AppColors.successGreen),
                    SizedBox(width: 4),
                    Text('Incoterm: CIF Dubai Port • Escrow Protected', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.deepNavy)),
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
                return _buildMessageBubble(context, msg, state);
              },
            ),
          ),

          // Quick Replies Strip
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickReplyChip('Confirm CIF Dubai terms'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Counter at \$4.05/pc'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Send Proforma Invoice'),
                  const SizedBox(width: 8),
                  _buildQuickReplyChip('Request Escrow link'),
                ],
              ),
            ),
          ),

          // Chat Input Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file, color: AppColors.textSecondaryLight),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type message or counter-offer...',
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
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

  Widget _buildQuickReplyChip(String text) {
    return ActionChip(
      label: Text(text, style: const TextStyle(fontSize: 11, color: AppColors.deepNavy)),
      backgroundColor: const Color(0xFFF1F5F9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onPressed: () => _sendQuickReply(text),
    );
  }

  Widget _buildMessageBubble(BuildContext context, ChatMessageModel msg, TradeState state) {
    final isMe = msg.isFromMe;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Author & Time Label
          Text(
            '${msg.senderName} • ${_formatTime(msg.timestamp)}',
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondaryLight),
          ),
          const SizedBox(height: 4),

          // Message Content Container
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? AppColors.deepNavy : Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(14),
                topRight: const Radius.circular(14),
                bottomLeft: Radius.circular(isMe ? 14 : 2),
                bottomRight: Radius.circular(isMe ? 2 : 14),
              ),
              border: isMe ? null : Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                fontSize: 13,
                color: isMe ? Colors.white : AppColors.textPrimaryLight,
                height: 1.3,
              ),
            ),
          ),

          // Interactive Counter-Offer Card (if present)
          if (msg.counterOffer != null) ...[
            const SizedBox(height: 8),
            _buildCounterOfferWidget(context, msg.counterOffer!, state),
          ],
        ],
      ),
    );
  }

  Widget _buildCounterOfferWidget(BuildContext context, CounterOfferCard offer, TradeState state) {
    final isAccepted = offer.status == 'Accepted';

    return Container(
      width: 290,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isAccepted ? AppColors.successGreen : AppColors.gold, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                      color: isAccepted ? AppColors.successGreen : AppColors.deepNavy,
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
          Text(offer.productName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.deepNavy)),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Revised Quantity:', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              Text('${offer.revisedQuantity} pcs', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Revised Unit Price:', style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight)),
              Text('\$${offer.revisedUnitPrice.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const Divider(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Revised Total (USD):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
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
