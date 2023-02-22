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

    onChange() async {
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
        if (state is OrdersReportFailureState) {
          context.showErrorSnackBar(state.failure.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.bar_chart_rounded,
            color: Theme.of(context).colorScheme.primary,
            weight: 2.0,
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
                  const SizedBox(width: 8.0),
                  LogoutButton(),
                ],
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
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
        final isEnabled = state is! OrdersReportLoadingState;
        final isBusy = state is OrdersReportLoadingState;
        final canClear = isEnabled &&
            (state is OrdersReportDirtyState ||
                state is OrdersReportLoadedState ||
                state is OrdersReportFailureState);
        final canPrint = isEnabled &&
            state is OrdersReportLoadedState &&
            state.orders.isNotEmpty;

        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                isEnabled: isEnabled,
                icon: Icons.search_rounded,
                label: 'Buscar',
                type: ButtonType.success,
                onPressed: () => cubit.search(sendDateEC.text),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                isEnabled: canClear,
                icon: Icons.clear_rounded,
                label: 'Limpar',
                type: ButtonType.primary,
                onPressed: clearForm,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlineButton(
                isEnabled: canPrint,
                icon: Icons.print_rounded,
                label: 'Imprimir',
                type: ButtonType.primary,
                onPressed: cubit.printReport,
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
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<OrdersReportCubit, OrdersReportState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is OrdersReportLoadedState) {
            if (state.orders.isEmpty) {
              return Row(
                children: const [
                  Text(
                    'Não foi encontrado nenhum pedido enviado na data informada.',
                  ),
                ],
              );
            }

            return Table(
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.onBackground,
                width: 1.0,
              ),
              columnWidths: const {
                0: FixedColumnWidth(70.0),
                1: FlexColumnWidth(3.0),
                2: FlexColumnWidth(3.0),
                3: FlexColumnWidth(9.0),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
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
                        padding: EdgeInsets.all(8.0),
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
                        padding: EdgeInsets.all(8.0),
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
                        padding: EdgeInsets.all(8.0),
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
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(order.type),
                              Text(order.number),
                            ],
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(order.secretary),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(order.project),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
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
