import '../../domain/entities/material.dart';

extension MaterialDTO on Material {
  static Material fromMapEntry(
    MapEntry<String, List<String>> mapEntry,
    Map<String, String> groups,
  ) {
    return Material(
      groupCode: mapEntry.value[0],
      groupDescription: groups[mapEntry.value[0]] ?? '',
      code: mapEntry.key,
      description: mapEntry.value[1],
    );
  }
}
