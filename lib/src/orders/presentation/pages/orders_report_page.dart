import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../auth/presentation/widgets/logout_button.dart';
import '../../../shared/helpers/input_formatters.dart';
import '../../../shared/managers/snackbar_manager.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/inputs/text_input.dart';
import '../cubits/orders_report_cubit.dart';
import '../cubits/orders_report_state.dart';

class OrdersReportPage extends StatefulWidget {
  const OrdersReportPage({Key? key}) : super(key: key);

  @override
  State<OrdersReportPage> createState() => _OrdersReportPageState();
}

class _OrdersReportPageState extends State<OrdersReportPage> {
  final cubit = Modular.get<OrdersReportCubit>();

  final sendDateEC = TextEditingController();
  final sendDateFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    initSearchForm();
  }

  @override
  void dispose() {
    sendDateEC.dispose();
    super.dispose();
  }

  void initSearchForm() {
    var lastSendDate = '';

    Future<void> onChange() async {
      if (sendDateEC.text.isEmpty) {
        await cubit.reset();
      } else if (lastSendDate != sendDateEC.text) {
        await cubit.setDirty();
      }
      lastSendDate = sendDateEC.text;
    }

    sendDateEC.addListener(onChange);
  }

  void clearForm() {
    sendDateEC.text = '';
    sendDateFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersReportCubit, OrdersReportState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is FailureState) {
          context.showErrorSnackBar(state.failure.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.bar_chart_rounded,
            color: Theme.of(context).colorScheme.primary,
            weight: 2,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Relatório de Pedidos para Envio',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_note_outlined),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () =>
                        Modular.to.pushReplacementNamed('/pedidos/cadastro'),
                    tooltip: 'Cadastro de Pedidos',
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
                _buildDataTableRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFormRow(BuildContext context) {
    return BlocBuilder<OrdersReportCubit, OrdersReportState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is! LoadingState;
        final isBusy = state is LoadingState;
        final canClear = isEnabled &&
            (state is DirtyState ||
                state is LoadedState ||
                state is FailureState);
        final canPrint =
            isEnabled && state is LoadedState && state.orders.isNotEmpty;

        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextInput(
                  isEnabled: isEnabled,
                  focusNode: sendDateFocus,
                  controller: sendDateEC,
                  label: 'Data de Envio ao Financeiro',
                  formatters: [InputFormatters.date],
                  autofocus: true,
                  onSubmitted: (_) => cubit.search(sendDateEC.text),
                  suffixIcon: isBusy
                      ? Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        )
                      : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: OutlineButton(
                isEnabled: isEnabled,
                icon: Icons.search_rounded,
                label: 'Buscar',
                type: ButtonType.success,
                onPressed: () => cubit.search(sendDateEC.text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: OutlineButton(
                isEnabled: canClear,
                icon: Icons.clear_rounded,
                label: 'Limpar',
                type: ButtonType.primary,
                onPressed: clearForm,
              ),
            ),
            const Flexible(child: SizedBox()),
          ],
        );
      },
    );
  }

  Widget _buildDataTableRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BlocBuilder<OrdersReportCubit, OrdersReportState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is LoadedState) {
            if (state.orders.isEmpty) {
              return Row(
                children: const [
                  Text(
                    'Não foram encontrados pedidos enviados na data informada.',
                  ),
                ],
              );
            }

            return Table(
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.onBackground,
              ),
              columnWidths: const {
                0: FixedColumnWidth(70),
                1: FlexColumnWidth(3),
                2: FlexColumnWidth(3),
                3: FlexColumnWidth(9),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            '#',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            'Secretaria',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            'Projeto',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            'Descrição',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ...state.orders.map(
                  (order) => TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Text(order.type),
                              Text(order.number),
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(order.secretary),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(order.project),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(order.description),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
