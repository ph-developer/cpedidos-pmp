import '../../router/router.dart';

abstract class RouterBoot {
  static Future<void> run() async {
    await setupRouter();
  }
}
