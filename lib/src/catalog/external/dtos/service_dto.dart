import '../../domain/entities/service.dart';
import '../models/service_metadata_model.dart';

extension ServiceDTO on Service {
  static Service fromMap(
    Map<String, dynamic> map,
    ServiceMetadataModel metadata,
  ) {
    return Service(
      groupCode: map['group'],
      groupDescription: metadata.groups[map['group']] ?? '',
      classCode: map['class'],
      classDescription: metadata.classes[map['class']] ?? '',
      code: map['code'],
      description: map['description'],
    );
  }
}
