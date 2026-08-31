import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MainMenuController extends GetxController {
  final best = 0.obs;

  @override
  void onInit() {
    super.onInit();
    best.value = GetStorage().read<int>('best_score') ?? 0;
  }
}
