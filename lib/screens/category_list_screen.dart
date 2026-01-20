import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../controllers/task_controller.dart';
import '../helpera/themes.dart';
import '../widgets/add_category_dialog.dart';

class CategoryListScreen extends StatelessWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskController = Get.find<TaskController>();

    return Scaffold(
      appBar: AppBar(title: Text('categories'.tr)),
      body: GetBuilder<CategoryController>(
        builder: (controller) {
          if (controller.categories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.category, size: 64, color: AppColors.iconSubtle),
                  const SizedBox(height: 16),
                  Text('no_categories'.tr,
                      style: TextStyle(color: AppColors.textSubtleDark)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              final taskCount = taskController.tasks
                  .where((t) => t.categoryId == category.id)
                  .length;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  leading: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Color(category.colorValue).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Color(category.colorValue),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ),
                  title: Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  subtitle: Text(
                    '$taskCount ${'tasks'.tr}',
                    style: TextStyle(color: AppColors.textSubtle, fontSize: 13),
                  ),
                  trailing: PopupMenuButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          () =>
                              Get.dialog(AddCategoryDialog(category: category)),
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            const Icon(Icons.delete_outline, size: 18, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text('delete'.tr,
                                style: const TextStyle(color: AppColors.error)),
                          ],
                        ),
                        onTap: () => Future.delayed(
                          const Duration(milliseconds: 100),
                          () => _deleteCategory(category.id),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.dialog(const AddCategoryDialog()),
        label: Text('add_category'.tr),
        icon: const Icon(Icons.add),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _deleteCategory(String id) {
    Get.dialog(
      AlertDialog(
        title: Text('delete'.tr),
        content: Text('delete_confirm'.tr),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              final taskController = Get.find<TaskController>();
              for (var task in taskController.tasks) {
                if (task.categoryId == id) {
                  task.categoryId = null;
                  task.save();
                }
              }
              Get.find<CategoryController>().deleteCategory(id);
              Get.back();
            },
            child: Text('delete'.tr,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
