import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../auth/presentation/widgets/logout_button.dart';
import '../../../shared/helpers/input_formatters.dart';
import '../../../shared/managers/snackbar_manager.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/inputs/select_input.dart';
import '../../../shared/widgets/inputs/text_input.dart';
import '../cubits/items_search_cubit.dart';
import '../cubits/items_search_state.dart';

class ItemsSearchPage extends StatefulWidget {
  const ItemsSearchPage({Key? key}) : super(key: key);

  @override
  State<ItemsSearchPage> createState() => _ItemsSearchPageState();
}

class _ItemsSearchPageState extends State<ItemsSearchPage> {
  final cubit = Modular.get<ItemsSearchCubit>();

  int pagination = 1;
  final maxItensByPage = 20;

  final itemTypeEC = TextEditingController(text: 'material');
  final searchTypeEC = TextEditingController(text: 'code');
  final queryEC = TextEditingController();
  final queryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    initSearchForm();
  }

  @override
  void dispose() {
    itemTypeEC.dispose();
    searchTypeEC.dispose();
    queryEC.dispose();
    super.dispose();
  }

  void initSearchForm() {
    var lastItemType = 'material';
    var lastSearchType = 'code';
    var lastQuery = '';

    Future<void> onChange() async {
      if (itemTypeEC.text.isEmpty ||
          searchTypeEC.text.isEmpty ||
          queryEC.text.isEmpty) {
        if (itemTypeEC.text == 'material' && searchTypeEC.text == 'code') {
          await cubit.reset();
        } else {
          await cubit.setDirty();
        }
      } else if (itemTypeEC.text != lastItemType ||
          searchTypeEC.text != lastSearchType ||
          queryEC.text != lastQuery) {
        await cubit.setDirty();
      }
      lastItemType = itemTypeEC.text;
      lastSearchType = searchTypeEC.text;
      lastQuery = queryEC.text;
    }

    itemTypeEC.addListener(onChange);
    searchTypeEC.addListener(onChange);
    queryEC.addListener(onChange);
  }

  void clearForm() {
    itemTypeEC.text = 'material';
    searchTypeEC.text = 'code';
    queryEC.text = '';
    queryFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ItemsSearchCubit, ItemsSearchState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is FailureState) {
          context.showErrorSnackBar(state.failure.message);
        } else if (state is LoadedState) {
          setState(() {
            pagination = 1;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.menu_book_rounded,
            color: Theme.of(context).colorScheme.primary,
            weight: 2,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Busca de Materiais e Serviços',
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
                  IconButton(
                    icon: const Icon(Icons.manage_search_rounded),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () =>
                        Modular.to.pushReplacementNamed('/pedidos/busca'),
                    tooltip: 'Busca de Pedidos',
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
                _buildPagination(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchFormRow(BuildContext context) {
    return BlocBuilder<ItemsSearchCubit, ItemsSearchState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is! LoadingState;
        final isBusy = state is LoadingState;
        final canClear = isEnabled &&
            (state is DirtyState ||
                state is LoadedState ||
                state is FailureState);

        final queryLabel = searchTypeEC.text == 'code' ? 'Código' : 'Descrição';

        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SelectInput(
                  controller: itemTypeEC,
                  label: 'Tipo do Item',
                  items: const {
                    'material': 'Material',
                    'service': 'Serviço',
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SelectInput(
                  controller: searchTypeEC,
                  label: 'Buscar Por',
                  items: const {
                    'code': 'Código',
                    'description': 'Descrição',
                  },
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextInput(
                  isEnabled: isEnabled,
                  focusNode: queryFocus,
                  controller: queryEC,
                  label: queryLabel,
                  formatters: [InputFormatters.uppercase],
                  autofocus: true,
                  onSubmitted: (_) => cubit.search(
                    itemTypeEC.text,
                    searchTypeEC.text,
                    queryEC.text,
                  ),
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
                onPressed: () => cubit.search(
                  itemTypeEC.text,
                  searchTypeEC.text,
                  queryEC.text,
                ),
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
      child: BlocBuilder<ItemsSearchCubit, ItemsSearchState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is LoadedState) {
            if (state.items.isEmpty) {
              return Row(
                children: [
                  Text(
                    (itemTypeEC.text == 'material')
                        ? 'Não foram encontrados materiais que atendem aos '
                            'critérios de busca informados.'
                        : 'Não foram encontrados serviços que atendem aos '
                            'critérios de busca informados.',
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
                1: FlexColumnWidth(),
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
                            'Código',
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
                ...state.items
                    .skip((pagination - 1) * maxItensByPage)
                    .take(maxItensByPage)
                    .map(
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
                              child: Text(item.description),
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

  Widget _buildPagination(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: BlocBuilder<ItemsSearchCubit, ItemsSearchState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is LoadedState && state.items.isNotEmpty) {
            final page = pagination;
            final pages = (state.items.length / maxItensByPage).ceil();
            final itemsCount = state.items.length;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: pagination > 1
                      ? () {
                          setState(() {
                            pagination--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
                Text('Página $page de $pages - $itemsCount '
                    'ite${itemsCount == 1 ? 'm' : 'ns'} encontrados'),
                IconButton(
                  onPressed: page < pages
                      ? () {
                          setState(() {
                            pagination++;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward_rounded),
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
