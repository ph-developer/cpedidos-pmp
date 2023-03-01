class ServiceMetadataModel {
  final String extractionDate;
  final Map<String, String> groups;
  final Map<String, String> classes;
  final List<String> files;

  ServiceMetadataModel({
    required this.extractionDate,
    required this.groups,
    required this.classes,
    required this.files,
  });

  factory ServiceMetadataModel.fromMap(Map<String, dynamic> map) {
    return ServiceMetadataModel(
      extractionDate: map['extraction_date'],
      groups: Map<String, String>.from(map['groups']),
      classes: Map<String, String>.from(map['classes']),
      files: List<String>.from(map['files']),
    );
  }
}
