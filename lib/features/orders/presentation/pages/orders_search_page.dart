import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/helpers/input_formatters.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/injection/injector.dart';
import '../../../../core/reactivity/obs_form.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/errors/failures.dart';
import '../controllers/orders_search_controller.dart';

enum _FormFields { searchType, query }

class OrdersSearchPage extends StatefulWidget {
  const OrdersSearchPage({super.key});

  @override
  State<OrdersSearchPage> createState() => _OrdersSearchPageState();
}

class _OrdersSearchPageState extends State<OrdersSearchPage> {
  final reactionDisposers = <ReactionDisposer>[];
  final controller = inject<OrdersSearchController>();
  final formState = ObservableForm(_FormFields.values, {
    _FormFields.searchType: 'sendDate',
  });

  @override
  void initState() {
    super.initState();
    reactionDisposers.addAll([
      reaction((_) => controller.failure, _onFailure),
      reaction((_) => formState.getValues(), _onFormChanged)
    ]);
  }

  @override
  void dispose() {
    formState.dispose();
    for (final dispose in reactionDisposers) {
      dispose();
    }
    super.dispose();
  }

  Future<void> _onFailure(OrdersFailure? failure) async {
    if (failure != null) {
      context.showErrorSnackbar(failure.message);
    }
  }

  Future<void> _onSubmit([dynamic _]) async {
    await controller.searchOrders(formState.getValues());
  }

  Future<void> _onFormChanged([dynamic _]) async {
    if (controller.isLoaded) {
      await controller.clearSearch();
    }
  }

  Future<void> _onClear() async {
    await controller.clearSearch();
    formState
      ..clear()
      ..focus(_FormFields.query);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Observer(
        builder: (context) {
          final loadedOrders = controller.loadedOrders;
          final isLoading = controller.isLoading;
          final isLoaded = controller.isLoaded;
          final isEnabled = !isLoading;

          final searchType = formState.getFieldValue(_FormFields.searchType);
          final query = formState.getFieldValue(_FormFields.query);

          final queryLabel = searchType == 'sendDate'
              ? 'Data de Envio ao Financeiro'
              : 'Data de Chegada';

          final canClear =
              isEnabled && (searchType != 'sendDate' || query.isNotEmpty);

          return Column(
            children: [
              //* SEARCH FORM

              Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectInput(
                        controller:
                            formState.getController(_FormFields.searchType),
                        label: 'Buscar Por',
                        items: const {
                          'sendDate': 'Data de Envio ao Financeiro',
                          'arrivalDate': 'Data de Chegada',
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextInput(
                              isEnabled: isEnabled,
                              isLoading: isLoading,
                              focusNode:
                                  formState.getFocusNode(_FormFields.query),
                              controller:
                                  formState.getController(_FormFields.query),
                              label: queryLabel,
                              formatters: [InputFormatters.date],
                              autofocus: true,
                              onSubmitted: _onSubmit,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: OutlineButton(
                              isEnabled: isEnabled,
                              icon: Icons.search_rounded,
                              label: 'Buscar',
                              type: ButtonType.success,
                              onPressed: _onSubmit,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: OutlineButton(
                              isEnabled: canClear,
                              icon: Icons.clear_rounded,
                              label: 'Limpar',
                              type: ButtonType.primary,
                              onPressed: _onClear,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              //* NOT FOUND ITEMS TEXT

              if (isLoaded && loadedOrders.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Não foram encontrados pedidos que atendem aos '
                          'critérios de busca informados.',
                        ),
                      ),
                    ],
                  ),
                ),

              //* ORDERS TABLE

              if (isLoaded && loadedOrders.isNotEmpty)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Table(
                        border: TableBorder.all(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                        columnWidths: const {
                          0: FixedColumnWidth(70),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(3),
                          3: FlexColumnWidth(9),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          const TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Center(
                                    child: Text(
                                      '#',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
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
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ...loadedOrders.paginated.map(
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
                      ),
                    ),
                  ],
                ),

              //* PAGINATION

              if (loadedOrders.isNotEmpty)
                Paginator(
                  padding: const EdgeInsets.all(8),
                  currentPage: loadedOrders.currentPage,
                  pagesCount: loadedOrders.pagesCount,
                  itemsCount: loadedOrders.length,
                  previousPageCallback: loadedOrders.previousPage,
                  nextPageCallback: loadedOrders.nextPage,
                ),
            ],
          );
        },
      ),
    );
  }
}
