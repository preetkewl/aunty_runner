import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/app_colors.dart';
import '../../app/app_text.dart';
import '../../app/routes.dart';
import '../common/pill_button.dart';
import 'menu_controller.dart';

class MenuView extends GetView<MainMenuController> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.surfaceRaised, AppColors.background],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(flex: 2),
                Text('AUNTY', style: AppText.display(size: 56, color: AppColors.accent)),
                Transform.translate(
                  offset: const Offset(0, -8),
                  child: Text(
                    'RUNNER',
                    style: AppText.display(size: 56, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Tap to jump. Grab the coins.\nDon’t argue with the auto driver.',
                  textAlign: TextAlign.center,
                  style: AppText.body(size: 14),
                ),
                const Spacer(flex: 3),
                PillButton(
                  label: 'PLAY',
                  expand: true,
                  onPressed: () => Get.toNamed(Routes.game),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Text(
                    'BEST  ${controller.best.value}',
                    style: AppText.label(size: 12, color: AppColors.textSecondary),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
