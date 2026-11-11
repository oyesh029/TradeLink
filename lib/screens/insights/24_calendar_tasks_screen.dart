import 'package:flutter/material.dart';
import '../../models/trade_models.dart';
import '../../state/trade_state.dart';
import '../../theme/app_colors.dart';
import '../../widgets/theme_toggle_button.dart';

class CalendarTasksScreen extends StatefulWidget {
  const CalendarTasksScreen({super.key});

  @override
  State<CalendarTasksScreen> createState() => _CalendarTasksScreenState();
}

class _CalendarTasksScreenState extends State<CalendarTasksScreen> {
  int _selectedDay = 14;

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final timeController = TextEditingController(text: '04:00 PM');
    String priority = 'Normal';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: context.cardColor,
          title: Text(
            'Add Daily Broker Task',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                style: TextStyle(fontSize: 13, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Task Title',
                  labelStyle: TextStyle(color: context.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: timeController,
                style: TextStyle(fontSize: 13, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Scheduled Time',
                  labelStyle: TextStyle(color: context.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: priority,
                dropdownColor: context.cardColor,
                style: TextStyle(fontSize: 13, color: context.textPrimary),
                decoration: InputDecoration(
                  labelText: 'Priority',
                  labelStyle: TextStyle(color: context.textSecondary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: context.borderColor),
                  ),
                ),
                items: [
                  DropdownMenuItem(value: 'Normal', child: Text('Normal Priority', style: TextStyle(color: context.textPrimary))),
                  DropdownMenuItem(value: 'High', child: Text('High Priority', style: TextStyle(color: context.textPrimary))),
                  DropdownMenuItem(value: 'Urgent', child: Text('Urgent Deadline', style: TextStyle(color: context.textPrimary))),
                ],
                onChanged: (val) => setDialogState(() => priority = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: context.textSecondary)),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  final state = TradeStateInherited.of(context);
                  state.addTask(
                    TaskItemModel(
                      taskId: 'tsk-${DateTime.now().millisecondsSinceEpoch}',
                      title: titleController.text.trim(),
                      scheduledTime: timeController.text.trim(),
                      priority: priority,
                      isDone: false,
                    ),
                  );
                  Navigator.pop(ctx);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tradeTeal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
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
        title: const Text('Calendar & Tasks'),
        actions: [
          const ThemeToggleButton(transparentBackground: true),
          IconButton(
            icon: const Icon(Icons.add_task),
            onPressed: _showAddTaskDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Month Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: context.borderColor),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'October 2026',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: context.textPrimary),
                      ),
                      Row(
                        children: [
                          IconButton(icon: Icon(Icons.chevron_left, color: context.textPrimary), onPressed: () {}),
                          IconButton(icon: Icon(Icons.chevron_right, color: context.textPrimary), onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Day of week labels
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _DayLabel('M'),
                      _DayLabel('T'),
                      _DayLabel('W'),
                      _DayLabel('T'),
                      _DayLabel('F'),
                      _DayLabel('S'),
                      _DayLabel('S'),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Calendar Grid Sample (2 weeks around 14th)
                  _buildCalendarWeek([5, 6, 7, 8, 9, 10, 11], context, isDark),
                  const SizedBox(height: 8),
                  _buildCalendarWeek([12, 13, 14, 15, 16, 17, 18], context, isDark, isSelectedRow: true),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Color-Coded Event Legend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildLegendItem('Shipment ETA', AppColors.oceanBlue, context),
                _buildLegendItem('LC Expiry', AppColors.alertRed, context),
                _buildLegendItem('Payment Wire', AppColors.successGreen, context),
              ],
            ),
            const SizedBox(height: 20),

            // Today's Agenda Task List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Schedule & Tasks",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: context.textPrimary),
                ),
                Text(
                  '${state.tasks.where((t) => t.isDone).length} of ${state.tasks.length} Completed',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tradeTeal),
                ),
              ],
            ),
            const SizedBox(height: 10),

            Material(
              color: context.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: context.borderColor),
              ),
              clipBehavior: Clip.antiAlias,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.tasks.length,
                separatorBuilder: (_, __) => Divider(height: 1, color: context.borderColor),
                itemBuilder: (context, index) {
                  final task = state.tasks[index];
                  return _buildTaskTile(task, state, context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarWeek(List<int> days, BuildContext context, bool isDark, {bool isSelectedRow = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) {
        final isSelected = day == _selectedDay;
        final hasShipment = day == 12 || day == 18;
        final hasLc = day == 14;
        final hasPayment = day == 13 || day == 16;

        return GestureDetector(
          onTap: () => setState(() => _selectedDay = day),
          child: Container(
            width: 38,
            height: 48,
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? AppColors.tradeTeal : AppColors.deepNavy)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$day',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : context.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (hasShipment) Container(width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.oceanBlue, shape: BoxShape.circle)),
                    if (hasLc) Container(margin: const EdgeInsets.only(left: 2), width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.alertRed, shape: BoxShape.circle)),
                    if (hasPayment) Container(margin: const EdgeInsets.only(left: 2), width: 4, height: 4, decoration: const BoxDecoration(color: AppColors.successGreen, shape: BoxShape.circle)),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(String label, Color color, BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 11, color: context.textSecondary)),
      ],
    );
  }

  Widget _buildTaskTile(TaskItemModel task, TradeState state, BuildContext context) {
    Color priorityColor;
    if (task.priority == 'Urgent') {
      priorityColor = AppColors.alertRed;
    } else if (task.priority == 'High') {
      priorityColor = AppColors.gold;
    } else {
      priorityColor = AppColors.tradeTeal;
    }

    return CheckboxListTile(
      value: task.isDone,
      activeColor: AppColors.tradeTeal,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      title: Text(
        task.title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: task.isDone ? context.textSecondary : context.textPrimary,
          decoration: task.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(Icons.access_time, size: 12, color: context.textSecondary),
          const SizedBox(width: 4),
          Text(task.scheduledTime, style: TextStyle(fontSize: 11, color: context.textSecondary)),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: priorityColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              task.priority,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: priorityColor),
            ),
          ),
        ],
      ),
      onChanged: (_) => state.toggleTask(task.taskId),
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String day;
  const _DayLabel(this.day);

  @override
  Widget build(BuildContext context) {
    return Text(
      day,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.textSecondaryLight),
    );
  }
}
