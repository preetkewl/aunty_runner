import 'package:get/get.dart';

import '../modules/game/game_binding.dart';
import '../modules/game/game_view.dart';
import '../modules/menu/menu_binding.dart';
import '../modules/menu/menu_view.dart';

abstract class Routes {
  static const menu = '/';
  static const game = '/game';
}

class AppPages {
  AppPages._();

  static final pages = <GetPage>[
    GetPage(
      name: Routes.menu,
      page: () => const MenuView(),
      binding: MenuBinding(),
    ),
    GetPage(
      name: Routes.game,
      page: () => const GameView(),
      binding: GameBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
