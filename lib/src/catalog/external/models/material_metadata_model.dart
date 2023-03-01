class MaterialMetadataModel {
  final String extractionDate;
  final Map<String, String> groups;
  final Map<String, String> classes;
  final Map<String, String> standards;
  final List<String> files;

  MaterialMetadataModel({
    required this.extractionDate,
    required this.groups,
    required this.classes,
    required this.standards,
    required this.files,
  });

  factory MaterialMetadataModel.fromMap(Map<String, dynamic> map) {
    return MaterialMetadataModel(
      extractionDate: map['extraction_date'],
      groups: Map<String, String>.from(map['groups']),
      classes: Map<String, String>.from(map['classes']),
      standards: Map<String, String>.from(map['standards']),
      files: List<String>.from(map['files']),
    );
  }
}
