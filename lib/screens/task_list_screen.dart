import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/task_controller.dart';
import '../controllers/category_controller.dart';
import '../helpera/routes.dart';
import '../helpera/themes.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_item.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();
    final categoryController = Get.find<CategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('tasks'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => Get.toNamed(AppRoutes.CATEGORIES),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: GetBuilder<TaskController>(
              builder: (controller) => GetBuilder<CategoryController>(
                builder: (_) => Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String?>(
                    value: controller.selectedCategoryId,
                    decoration: InputDecoration(
                      labelText: 'category'.tr,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text('all'.tr)),
                      ...Get.find<CategoryController>()
                          .categories
                          .map((cat) => DropdownMenuItem(
                                value: cat.id,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: Color(cat.colorValue),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(cat.name),
                                  ],
                                ),
                              )),
                    ],
                    onChanged: (value) => controller.setFilter(value),
                  ),
                ),
              ),
            ),
          ),
          GetBuilder<TaskController>(
            builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'all'.tr,
                      taskController.filteredTasks.length,
                      const Color(0xFFE3F2FD),
                      const Color(0xFF1976D2),
                      Icons.list_alt_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'completed'.tr,
                      taskController.completedTasks.length,
                      const Color(0xFFE8F5E9),
                      const Color(0xFF388E3C),
                      Icons.check_circle_outline_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'pending'.tr,
                      taskController.pendingTasks.length,
                      const Color(0xFFFFF3E0),
                      const Color(0xFFF57C00),
                      Icons.pending_actions_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GetBuilder<TaskController>(
              builder: (_) {
                final tasks = taskController.filteredTasks;
                if (tasks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt,
                            size: 64, color: AppColors.iconSubtle),
                        const SizedBox(height: 16),
                        Text('no_tasks'.tr,
                            style: TextStyle(color: AppColors.textSubtleDark)),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    final category =
                        categoryController.getCategory(task.categoryId ?? '');

                    return TaskItem(task: task, category: category);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.dialog(const AddTaskDialog()),
        label: Text('add_task'.tr),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildStatCard(
      String label, int count, Color bgColor, Color textColor, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: textColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _deleteTask(String id) {
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.dialog(
        AlertDialog(
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
