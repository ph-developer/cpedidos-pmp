import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class PageInfo extends Equatable {
  final String description;
  final String path;
  final IconData icon;

  const PageInfo({
    required this.description,
    required this.path,
    required this.icon,
  });

  @override
  List<Object?> get props => [description, path, icon];
}
