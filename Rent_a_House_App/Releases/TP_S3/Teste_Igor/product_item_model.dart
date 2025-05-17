class ProductItemModel {
  final String id;
  final String title;
  final String description;
  final String? imagePath;

  ProductItemModel({
    required this.id,
    required this.title,
    required this.description,
    this.imagePath,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'image_path': imagePath,
  };

  factory ProductItemModel.fromMap(Map<String, dynamic> map) => ProductItemModel(
    id: map['id'],
    title: map['title'],
    description: map['description'],
    imagePath: map['image_path'],
  );
}