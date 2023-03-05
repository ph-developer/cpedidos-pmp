import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../auth/presentation/widgets/logout_button.dart';
import '../../../shared/helpers/input_formatters.dart';
import '../../../shared/managers/snackbar_manager.dart';
import '../../../shared/widgets/buttons/outline_button.dart';
import '../../../shared/widgets/inputs/select_input.dart';
import '../../../shared/widgets/inputs/text_input.dart';
import '../cubits/orders_search_cubit.dart';
import '../cubits/orders_search_state.dart';

class OrdersSearchPage extends StatefulWidget {
  const OrdersSearchPage({Key? key}) : super(key: key);

  @override
  State<OrdersSearchPage> createState() => _OrdersSearchPageState();
}

class _OrdersSearchPageState extends State<OrdersSearchPage> {
  final cubit = Modular.get<OrdersSearchCubit>();

  final searchTypeEC = TextEditingController(text: 'sendDate');
  final queryEC = TextEditingController();
  final queryFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    initSearchForm();
  }

  @override
  void dispose() {
    searchTypeEC.dispose();
    queryEC.dispose();
    super.dispose();
  }

  void initSearchForm() {
    var lastSearchType = 'sendDate';
    var lastQuery = '';

    Future<void> onChange() async {
      if (searchTypeEC.text.isEmpty || queryEC.text.isEmpty) {
        if (searchTypeEC.text == 'sendDate') {
          await cubit.reset();
        } else {
          await cubit.setDirty();
        }
      } else if (searchTypeEC.text != lastSearchType ||
          queryEC.text != lastQuery) {
        await cubit.setDirty();
      }
      lastSearchType = searchTypeEC.text;
      lastQuery = queryEC.text;
    }

    searchTypeEC.addListener(onChange);
    queryEC.addListener(onChange);
  }

  void clearForm() {
    searchTypeEC.text = 'sendDate';
    queryEC.text = '';
    queryFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrdersSearchCubit, OrdersSearchState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is FailureState) {
          context.showErrorSnackBar(state.failure.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(
            Icons.manage_search_rounded,
            color: Theme.of(context).colorScheme.primary,
            weight: 2,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Busca de Pedidos',
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
                    icon: const Icon(Icons.menu_book_rounded),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: () =>
                        Modular.to.pushReplacementNamed('/catalogo/busca'),
                    tooltip: 'Busca de Materiais e Serviços',
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
    return BlocBuilder<OrdersSearchCubit, OrdersSearchState>(
      bloc: cubit,
      builder: (context, state) {
        final isEnabled = state is! LoadingState;
        final isBusy = state is LoadingState;
        final canClear = isEnabled &&
            (state is DirtyState ||
                state is LoadedState ||
                state is FailureState);

        final queryLabel = searchTypeEC.text == 'sendDate'
            ? 'Data de Envio ao Financeiro'
            : 'Data de Chegada';

        return Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SelectInput(
                  controller: searchTypeEC,
                  label: 'Buscar Por',
                  items: const {
                    'sendDate': 'Data de Envio ao Financeiro',
                    'arrivalDate': 'Data de Chegada',
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
                  formatters: [InputFormatters.date],
                  autofocus: true,
                  onSubmitted: (_) => cubit.search(
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
                onPressed: () => cubit.search(searchTypeEC.text, queryEC.text),
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
      child: BlocBuilder<OrdersSearchCubit, OrdersSearchState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is LoadedState) {
            if (state.orders.isEmpty) {
              return Row(
                children: [
                  Text(
                    (searchTypeEC.text == 'sendDate')
                        ? 'Não foram encontrados pedidos enviados na data '
                            'informada.'
                        : 'Não foram encontrados pedidos recebidos na data '
                            'informada.',
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
