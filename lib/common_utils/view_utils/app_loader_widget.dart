import 'package:bot_toast/bot_toast.dart';

import 'app_loader.dart';

void showAppLoader() {
  BotToast.showLoading();
}

void closeAppLoader() {
  BotToast.closeAllLoading();
}
