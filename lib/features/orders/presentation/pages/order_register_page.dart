import 'package:flutter/material.dart';

import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/helpers/input_formatters.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/injection/injector.dart';
import '../../../../core/reactivity/obs_form.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/entities/order.dart';
import '../../domain/errors/failures.dart';
import '../controllers/order_register_controller.dart';

enum _SearchFormFields { number, type }

enum _DataFormFields {
  arrivalDate,
  secretary,
  project,
  description,
  sendDate,
  returnDate,
  situation,
  notes
}

class OrderRegisterPage extends StatefulWidget {
  const OrderRegisterPage({super.key});

  @override
  State<OrderRegisterPage> createState() => _OrderRegisterPageState();
}

class _OrderRegisterPageState extends State<OrderRegisterPage> {
  final reactionDisposers = <ReactionDisposer>[];
  final controller = inject<OrderRegisterController>();
  final searchFormState = ObservableForm(_SearchFormFields.values, {
    _SearchFormFields.type: 'SE',
  });
  final dataFormState = ObservableForm(_DataFormFields.values);

  @override
  void initState() {
    super.initState();
    reactionDisposers.addAll([
      reaction((_) => controller.failure, _onFailure),
      reaction((_) => controller.success, _onSuccess),
      reaction((_) => controller.loadedOrder, _onLoadedOrderChanged),
      reaction((_) => searchFormState.getValues(), _onSearchFormChanged),
    ]);
  }

  @override
  void dispose() {
    searchFormState.dispose();
    dataFormState.dispose();
    for (final dispose in reactionDisposers) {
      dispose();
    }
    super.dispose();
  }

  Future<void> _onSuccess(SuccessfulAction? action) async {
    if (action == SuccessfulAction.save) {
      context.showSuccessSnackbar('Pedido salvo com sucesso.');
    } else if (action == SuccessfulAction.delete) {
      context.showSuccessSnackbar('Pedido excluído com sucesso.');
    }
  }

  Future<void> _onFailure(OrdersFailure? failure) async {
    if (failure != null) {
      context.showErrorSnackbar(failure.message);
    }
  }

  Future<void> _onSearchFormChanged([dynamic _]) async {
    await controller.searchOrder(searchFormState.getValues());
  }

  Future<void> _onLoadedOrderChanged(Order? order) async {
    dataFormState.setFieldValues({
      _DataFormFields.arrivalDate: order?.arrivalDate ?? '',
      _DataFormFields.secretary: order?.secretary ?? '',
      _DataFormFields.project: order?.project ?? '',
      _DataFormFields.description: order?.description ?? '',
      _DataFormFields.sendDate: order?.sendDate ?? '',
      _DataFormFields.returnDate: order?.returnDate ?? '',
      _DataFormFields.situation: order?.situation ?? '',
      _DataFormFields.notes: order?.notes ?? '',
    });
  }

  Future<void> _onSave() async {
    final payload = {
      ...searchFormState.getValues(),
      ...dataFormState.getValues(),
    };
    await controller.saveOrder(payload);
  }

  Future<void> _onDelete() async {
    await showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'Excluir pedido?',
        content: 'Deseja realmente excluir este pedido? '
            'Esta ação é irreversível.',
        onYes: _onConfirmDelete,
      ),
    );
  }

  Future<void> _onConfirmDelete() async {
    final payload = {
      ...searchFormState.getValues(),
      ...dataFormState.getValues(),
    };
    await controller.deleteOrder(payload);
  }

  Future<void> _onClear() async {
    await controller.clearSearch();
    dataFormState.clear();
    searchFormState
      ..clear()
      ..focus(_SearchFormFields.number);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          //* SEARCH FORM

          Observer(
            builder: (context) {
              final isSearching = controller.isSearching;
              final isLoading = controller.isLoading;
              final isBusy = isSearching || isLoading;
              final isEnabled = !isLoading;
              final loadedOrder = controller.loadedOrder;
              final isArchived = loadedOrder?.isArchived ?? false;

              return Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextInput(
                        isEnabled: isEnabled,
                        isLoading: isBusy,
                        focusNode: searchFormState
                            .getFocusNode(_SearchFormFields.number),
                        controller: searchFormState
                            .getController(_SearchFormFields.number),
                        label: 'Número',
                        formatters: [InputFormatters.digitsAndOneHyphenOnly],
                        autofocus: true,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectInput(
                        isEnabled: isEnabled,
                        controller: searchFormState
                            .getController(_SearchFormFields.type),
                        label: 'Tipo',
                        items: const {
                          'SE': 'SE',
                          'RM': 'RM',
                          'MEMORANDO': 'MEMORANDO',
                          'OUTRO': 'OUTRO'
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: isArchived
                          ? const Text(
                              'Este pedido está arquivado e não pode ser '
                              'alterado.',
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                ],
              );
            },
          ),

          //* DATA FORM

          Observer(
            builder: (context) {
              final isSearching = controller.isSearching;
              final isLoading = controller.isLoading;
              final isBusy = isSearching || isLoading;
              final isLoaded = controller.isLoaded;
              final loadedOrder = controller.loadedOrder;
              final isArchived = loadedOrder?.isArchived ?? false;
              final isEnabled = !isBusy && isLoaded && !isArchived;

              return Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.arrivalDate),
                            label: 'Data de Chegada',
                            formatters: [InputFormatters.date],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.secretary),
                            label: 'Secretaria Requisitante',
                            formatters: [InputFormatters.uppercase],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.project),
                            label: 'Projeto',
                            formatters: [InputFormatters.digitsAndOneDotOnly],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextAreaInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.description),
                            label: 'Descrição',
                            formatters: [InputFormatters.uppercase],
                            lines: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.sendDate),
                            label: 'Data de Envio ao Financeiro',
                            formatters: [InputFormatters.date],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.returnDate),
                            label: 'Data de Retorno do Financeiro',
                            formatters: [InputFormatters.date],
                          ),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.situation),
                            label: 'Situação',
                            formatters: [InputFormatters.uppercase],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: TextAreaInput(
                            isEnabled: isEnabled,
                            controller: dataFormState
                                .getController(_DataFormFields.notes),
                            label: 'Observações',
                            formatters: [InputFormatters.uppercase],
                            lines: 5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),

          //* ACTION BUTTONS

          Observer(
            builder: (context) {
              final isSearching = controller.isSearching;
              final isLoading = controller.isLoading;
              final isBusy = isSearching || isLoading;

              final isLoaded = controller.isLoaded;
              final loadedOrder = controller.loadedOrder;
              final isArchived = loadedOrder?.isArchived ?? false;
              final existsOrder = isLoaded && loadedOrder != null;

              final number =
                  searchFormState.getFieldValue(_SearchFormFields.number);
              final type =
                  searchFormState.getFieldValue(_SearchFormFields.type);

              final canSave = !isBusy && isLoaded && !isArchived;
              final canClear = !isBusy && (number.isNotEmpty || type != 'SE');
              final canDelete = !isBusy && existsOrder && !isArchived;

              return Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OutlineButton(
                      isEnabled: canSave,
                      icon: Icons.save_outlined,
                      label: 'Salvar',
                      type: ButtonType.success,
                      onPressed: _onSave,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OutlineButton(
                      isEnabled: canClear,
                      icon: Icons.clear_rounded,
                      label: 'Limpar',
                      type: ButtonType.primary,
                      onPressed: _onClear,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: OutlineButton(
                      isEnabled: canDelete,
                      icon: Icons.delete_outline_rounded,
                      label: 'Excluir',
                      type: ButtonType.error,
                      onPressed: _onDelete,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
