import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../models/task.dart';
import '../models/category.dart';
import '../controllers/task_controller.dart';
import '../helpera/themes.dart';
import 'add_task_dialog.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Category? category;

  const TaskItem({super.key, required this.task, this.category});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(
                width: 6,
                color: category != null
                    ? Color(category!.colorValue)
                    : Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: task.isCompleted,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          activeColor: AppColors.success,
                          onChanged: (_) =>
                              taskController.toggleComplete(task.id),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: task.isCompleted
                                    ? AppColors.textSubtle
                                    : null,
                              ),
                            ),
                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.color
                                      ?.withOpacity(0.7),
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                if (category != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Color(category!.colorValue)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      category!.name,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Color(category!.colorValue),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 12,
                                  color: AppColors.textSubtle,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  DateFormat.yMMMd().format(task.createdAt),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSubtle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton(
                        icon: const Icon(Icons.more_vert, size: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.edit_outlined, size: 18),
                                const SizedBox(width: 8),
                                Text('edit'.tr),
                              ],
                            ),
                            onTap: () => Future.delayed(
                              const Duration(milliseconds: 100),
                              () => Get.dialog(AddTaskDialog(task: task)),
                            ),
                          ),
                          PopupMenuItem(
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outline,
                                    size: 18, color: AppColors.error),
                                const SizedBox(width: 8),
                                Text('delete'.tr,
                                    style: const TextStyle(
                                        color: AppColors.error)),
                              ],
                            ),
                            onTap: () => _deleteTask(task.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteTask(String id) {
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.dialog(
        AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('delete'.tr),
          content: Text('delete_confirm'.tr),
          actions: [
            TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
            TextButton(
              onPressed: () {
                Get.find<TaskController>().deleteTask(id);
                Get.back();
              },
              child: Text('delete'.tr,
                  style: const TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      );
    });
  }
}
