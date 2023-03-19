import '../../domain/entities/service.dart';

extension ServiceDTO on Service {
  static Service fromMapEntry(
    MapEntry<String, List<String>> mapEntry,
    Map<String, String> groups,
  ) {
    return Service(
      groupCode: mapEntry.value[0],
      groupDescription: groups[mapEntry.value[0]] ?? '',
      code: mapEntry.key,
      description: mapEntry.value[1],
    );
  }
}
