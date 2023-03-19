import 'package:flutter/material.dart';

typedef ChangePageCallback = void Function();

class Paginator extends StatelessWidget {
  final int currentPage;
  final int pagesCount;
  final int itemsCount;
  final ChangePageCallback previousPageCallback;
  final ChangePageCallback nextPageCallback;
  final EdgeInsetsGeometry? padding;

  const Paginator({
    required this.currentPage,
    required this.pagesCount,
    required this.itemsCount,
    required this.previousPageCallback,
    required this.nextPageCallback,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final pageInfoText = 'Página $currentPage de $pagesCount';
    final itemsPluralText = 'ite${itemsCount == 1 ? 'm' : 'ns'}';
    final foundPluralText = 'encontrado${itemsCount == 1 ? '' : 's'}';
    final itemsCountText = '$itemsCount $itemsPluralText $foundPluralText';

    return Container(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: currentPage > 1 ? previousPageCallback : null,
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          Text('$pageInfoText - $itemsCountText'),
          IconButton(
            onPressed: currentPage < pagesCount ? nextPageCallback : null,
            icon: const Icon(Icons.arrow_forward_rounded),
          ),
        ],
      ),
    );
  }
}
