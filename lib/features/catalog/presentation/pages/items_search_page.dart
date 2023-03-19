import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/helpers/input_formatters.dart';
import '../../../../core/helpers/snackbar_helper.dart';
import '../../../../core/injection/injector.dart';
import '../../../../core/reactivity/obs_form.dart';
import '../../../../core/theme/theme.dart';
import '../../domain/errors/failures.dart';
import '../controllers/items_search_controller.dart';

enum _FormFields { itemType, searchType, query }

class ItemsSearchPage extends StatefulWidget {
  const ItemsSearchPage({super.key});

  @override
  State<ItemsSearchPage> createState() => _ItemsSearchPageState();
}

class _ItemsSearchPageState extends State<ItemsSearchPage> {
  final reactionDisposers = <ReactionDisposer>[];
  final controller = inject<ItemsSearchController>();
  final formState = ObservableForm(_FormFields.values, {
    _FormFields.itemType: 'material',
    _FormFields.searchType: 'code',
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

  Future<void> _onFailure(CatalogFailure? failure) async {
    if (failure != null) {
      context.showErrorSnackbar(failure.message);
    }
  }

  Future<void> _onSubmit([dynamic _]) async {
    await controller.searchItems(formState.getValues());
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
          final loadedItems = controller.loadedItems;
          final isLoading = controller.isLoading;
          final isLoaded = controller.isLoaded;
          final isEnabled = !isLoading;

          final itemType = formState.getFieldValue(_FormFields.itemType);
          final searchType = formState.getFieldValue(_FormFields.searchType);
          final query = formState.getFieldValue(_FormFields.query);

          final queryLabel = {
            'code': 'Código',
            'description': 'Descrição',
            'groupDescription': 'Grupo'
          }[searchType];

          final canClear = isEnabled &&
              (itemType != 'material' ||
                  searchType != 'code' ||
                  query.isNotEmpty);

          return Column(
            children: [
              //* SEARCH FORM

              Row(
                children: [
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectInput(
                        controller:
                            formState.getController(_FormFields.itemType),
                        label: 'Tipo do Item',
                        items: const {
                          'material': 'Material',
                          'service': 'Serviço',
                        },
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: SelectInput(
                        controller:
                            formState.getController(_FormFields.searchType),
                        label: 'Buscar Por',
                        items: const {
                          'code': 'Código',
                          'description': 'Descrição',
                          'groupDescription': 'Grupo',
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
                              label: queryLabel ?? '',
                              formatters: [InputFormatters.uppercase],
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

              if (isLoaded && loadedItems.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: const [
                      Expanded(
                        child: Text(
                          'Não foram encontrados itens que atendem aos '
                          'critérios de busca informados.',
                        ),
                      ),
                    ],
                  ),
                ),

              //* ITEMS TABLE

              if (isLoaded && loadedItems.isNotEmpty)
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
                          1: FlexColumnWidth(),
                          2: FlexColumnWidth(2),
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
                                      'Código',
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
                                      'Grupo',
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
                          ...loadedItems.paginated.map(
                            (item) => TableRow(
                              children: [
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Center(child: Text(item.code)),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      '${item.groupCode} - '
                                      '${item.groupDescription}',
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(item.description),
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

              if (loadedItems.isNotEmpty)
                Paginator(
                  padding: const EdgeInsets.all(8),
                  currentPage: loadedItems.currentPage,
                  pagesCount: loadedItems.pagesCount,
                  itemsCount: loadedItems.length,
                  previousPageCallback: loadedItems.previousPage,
                  nextPageCallback: loadedItems.nextPage,
                ),
            ],
          );
        },
      ),
    );
  }
}
