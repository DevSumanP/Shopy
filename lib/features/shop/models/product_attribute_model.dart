class ProductAttributeModel {
  String? name;
  final List<String> values; // Default to empty list

  ProductAttributeModel({this.name, List<String>? values})
      : values = values ?? []; // Ensure non-null list

  // Json Format
  Map<String, dynamic> toJson() {
    return {'Name': name, 'Values': values};
  }

  // Map Json oriented document snapshot from Firebase to Model
  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return ProductAttributeModel(); // return empty instance if data is empty
    }

    return ProductAttributeModel(
      name: data['Name'] ?? '', // Default to empty string if null
      values: data['Values'] != null
          ? List<String>.from(data['Values']) // Safely convert to List<String>
          : [], // Default to empty list if null
    );
  }
}
