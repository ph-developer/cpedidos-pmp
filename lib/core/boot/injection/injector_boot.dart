import '../../injection/injector.dart';

abstract class InjectorBoot {
  static Future<void> run([InjectFn? injectFn]) async {
    await setupInjector(injectFn);
  }
}
