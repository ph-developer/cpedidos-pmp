import '../../../shared/dialogs/confirm_dialog.dart';

void showOrderDeleteConfirmDialog({
  required Function() onOk,
}) =>
    showConfirmDialog(
      title: 'Excluir pedido?',
      text: 'Deseja realmente excluir este pedido? Esta ação é irreversível.',
      okButtonText: 'Sim',
      onOk: onOk,
    );
