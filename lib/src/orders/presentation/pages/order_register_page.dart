import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../auth/presentation/widgets/logout_button.dart';
import '../../../shared/helpers/debounce.dart';
import '../../../shared/helpers/input_formatters.dart';
import '../../../shared/managers/snackbar_manager.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/dialogs/confirm_dialog.dart';
import '../../../shared/widgets/inputs/select_input.dart';
import '../../../shared/widgets/inputs/text_area_input.dart';
import '../../../shared/widgets/inputs/text_input.dart';
import '../../domain/entities/order.dart';
import '../cubits/order_register_cubit.dart';
import '../cubits/order_register_state.dart';

class OrderRegisterPage extends StatefulWidget {
  const OrderRegisterPage({super.key});

  @override
  State<OrderRegisterPage> createState() => _OrderRegisterPageState();
}

class _OrderRegisterPageState extends State<OrderRegisterPage> {
  final cubit = Modular.get<OrderRegisterCubit>();

  final numberFocus = FocusNode();
  final numberEC = TextEditingController();
  final typeEC = TextEditingController(text: 'SE');
  final arrivalDateEC = TextEditingController();
  final secretaryEC = TextEditingController();
  final projectEC = TextEditingController();
  final descriptionEC = TextEditingController();
  final sendDateEC = TextEditingController();
  final returnDateEC = TextEditingController();
  final situationEC = TextEditingController();
  final notesEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    initSearchForm();
  }

  @override
  void dispose() {
    numberEC.dispose();
    typeEC.dispose();
    arrivalDateEC.dispose();
    secretaryEC.dispose();
    projectEC.dispose();
    descriptionEC.dispose();
    sendDateEC.dispose();
    returnDateEC.dispose();
    situationEC.dispose();
    notesEC.dispose();
    super.dispose();
  }

  void initSearchForm() {
    final debouncedSearch = debounce(
      () => cubit.search(typeEC.text, numberEC.text),
      500,
    );
    Future<void> onChange() async {
      if (numberEC.text.isEmpty || typeEC.text.isEmpty) {
        if (typeEC.text == 'SE') {
          await cubit.reset();
        } else {
          await cubit.setDirty();
        }
      } else {
        await cubit.setDirty();
        debouncedSearch();
      }
    }

    numberEC.addListener(onChange);
    typeEC.addListener(onChange);
  }

  void clearSearchForm() {
    numberEC.text = '';
    typeEC.text = 'SE';
    numberFocus.requestFocus();
  }

  void clearDataForm() {
    arrivalDateEC.text = '';
    secretaryEC.text = '';
    projectEC.text = '';
    descriptionEC.text = '';
    sendDateEC.text = '';
    returnDateEC.text = '';
    situationEC.text = '';
    notesEC.text = '';
  }

  Order get currentOrder => Order(
        number: numberEC.text,
        type: typeEC.text,
        arrivalDate: arrivalDateEC.text,
        secretary: secretaryEC.text,
        project: projectEC.text,
        description: descriptionEC.text,
        sendDate: sendDateEC.text,
        returnDate: returnDateEC.text,
        situation: situationEC.text,
        notes: notesEC.text,
      );

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderRegisterCubit, OrderRegisterState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is DirtyState) {
          clearDataForm();
        } else if (state is LoadedSuccessState) {
          if (numberEC.text != state.loadedOrder.number ||
              typeEC.text != state.loadedOrder.type) return;
          arrivalDateEC.text = state.loadedOrder.arrivalDate;
          secretaryEC.text = state.loadedOrder.secretary;
          projectEC.text = state.loadedOrder.project;
          descriptionEC.text = state.loadedOrder.description;
          sendDateEC.text = state.loadedOrder.sendDate;
          returnDateEC.text = state.loadedOrder.returnDate;
          situationEC.text = state.loadedOrder.situation;
          notesEC.text = state.loadedOrder.notes;
        } else if (state is LoadedEmptyState) {
          if (numberEC.text != state.numberQuery ||
              typeEC.text != state.typeQuery) return;
          clearDataForm();
        } else if (state is SavedState) {
          context.showSuccessSnackBar('Pedido salvo com sucesso.');
          cubit.search(typeEC.text, numberEC.text);
        } else if (state is DeletedState) {
          context.showSuccessSnackBar('Pedido excluído com sucesso.');
          clearDataForm();
          clearSearchForm();
        } else if (state is FailureState) {
          context.showErrorSnackBar(state.failure.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.edit_note_outlined,
            color: Theme.of(context).colorScheme.primary,
            weight: 2,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cadastro de Pedidos',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.bar_chart_rounded),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () =>
                        Modular.to.pushReplacementNamed('/pedidos/relatorio'),
                    tooltip: 'Relatório de Pedidos para Envio',
                  ),
                  const SizedBox(width: 8),
                  LogoutButton(),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width > 1140
                  ? (MediaQuery.of(context).size.width - 1140) / 2
                  : 0,
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildSearchFormRow(context),
                _buildDataFormRows(context),
                _buildActionsFormRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFormRow(BuildContext context) {
    return BlocBuilder<OrderRegisterCubit, OrderRegisterState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is! SavingState && state is! DeletingState;

        final isBusy = state is LoadingState ||
            state is SavingState ||
            state is DeletingState;

        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextInput(
                  isEnabled: isEnabled,
                  focusNode: numberFocus,
                  controller: numberEC,
                  label: 'Número',
                  formatters: [InputFormatters.digitsAndHyphensOnly],
                  autofocus: true,
                  suffixIcon: isBusy
                      ? Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        )
                      : null,
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SelectInput(
                  isEnabled: isEnabled,
                  controller: typeEC,
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
            const Flexible(child: SizedBox()),
          ],
        );
      },
    );
  }

  Widget _buildDataFormRows(BuildContext context) {
    return BlocBuilder<OrderRegisterCubit, OrderRegisterState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is LoadedSuccessState ||
            state is LoadedEmptyState ||
            state is FailureState;

        return Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextInput(
                      isEnabled: isEnabled,
                      controller: arrivalDateEC,
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
                      controller: secretaryEC,
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
                      controller: projectEC,
                      label: 'Projeto',
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
                      controller: descriptionEC,
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
                      controller: sendDateEC,
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
                      controller: returnDateEC,
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
                      controller: situationEC,
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
                      controller: notesEC,
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
    );
  }

  Widget _buildActionsFormRow(BuildContext context) {
    return BlocBuilder<OrderRegisterCubit, OrderRegisterState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is LoadedSuccessState ||
            state is LoadedEmptyState ||
            state is FailureState;

        final canClear = isEnabled || state is DirtyState;
        final canDelete = isEnabled && state is LoadedSuccessState;

        return Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: OutlineButton(
                isEnabled: isEnabled,
                icon: Icons.save_outlined,
                label: 'Salvar',
                type: ButtonType.success,
                onPressed: () => cubit.save(currentOrder),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: OutlineButton(
                isEnabled: canClear,
                icon: Icons.clear_rounded,
                label: 'Limpar',
                type: ButtonType.primary,
                onPressed: () {
                  clearDataForm();
                  clearSearchForm();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: OutlineButton(
                isEnabled: canDelete,
                icon: Icons.delete_outline_rounded,
                label: 'Excluir',
                type: ButtonType.error,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ConfirmDialog(
                      title: 'Excluir pedido?',
                      content: 'Deseja realmente excluir este pedido? '
                          'Esta ação é irreversível.',
                      onYes: () => cubit.delete(currentOrder),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
