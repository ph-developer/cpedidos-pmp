import 'package:universal_io/io.dart';
import 'package:asuka/snackbars/asuka_snack_bar.dart';

void notifySuccess(String message) {
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    AsukaSnackbar.success(message).show();
  }
}

void notifyError(String message) {
  if (!Platform.environment.containsKey('FLUTTER_TEST')) {
    AsukaSnackbar.alert(message).show();
  }
}
