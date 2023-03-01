import '../../domain/entities/material.dart';
import '../models/material_metadata_model.dart';

extension MaterialDTO on Material {
  static Material fromMap(
    Map<String, dynamic> map,
    MaterialMetadataModel metadata,
  ) {
    return Material(
      groupCode: map['group'],
      groupDescription: metadata.groups[map['group']] ?? '',
      classCode: map['class'],
      classDescription: metadata.classes[map['class']] ?? '',
      standardCode: map['standard'],
      standardDescription: metadata.standards[map['standard']] ?? '',
      code: map['code'],
      description: map['description'],
    );
  }
}
