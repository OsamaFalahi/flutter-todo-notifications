import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/locale_controller.dart';
import '../helpera/themes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final ThemeController themeController = Get.find<ThemeController>();
    final LocaleController localeController = Get.find<LocaleController>();

    return Scaffold(
      appBar: AppBar(title: Text('profile'.tr)),
      body: Obx(() {
        final user = authController.currentUser.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    width: 4,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: NetworkImage(user.image),
                  onBackgroundImageError: (_, __) => const Icon(Icons.person),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                user.fullName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                user.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSubtle,
                      letterSpacing: 0.5,
                    ),
              ),
            ),
            const SizedBox(height: 40),
            _buildSection(context, 'settings'.tr),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.palette_outlined,
                        color: Theme.of(context).primaryColor),
                    title: Text('theme'.tr),
                    trailing: Obx(() => Switch(
                          value: themeController.isDark.value,
                          onChanged: (_) => themeController.toggleTheme(),
                        )),
                  ),
                  const Divider(indent: 56, endIndent: 16, height: 1),
                  ListTile(
                    leading: Icon(Icons.language_outlined,
                        color: Theme.of(context).primaryColor),
                    title: Text('language'.tr),
                    trailing: Obx(() => DropdownButton<String>(
                          value: localeController.locale.value.languageCode,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(value: 'en', child: Text('English')),
                            DropdownMenuItem(value: 'ar', child: Text('العربية')),
                          ],
                          onChanged: (val) {
                            if (val == 'en') {
                              localeController.changeToEnglish();
                            } else {
                              localeController.changeToArabic();
                            }
                          },
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => authController.logout(),
              icon: const Icon(Icons.logout_rounded),
              label: Text('logout'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[50],
                foregroundColor: Colors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor.withOpacity(0.7),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
