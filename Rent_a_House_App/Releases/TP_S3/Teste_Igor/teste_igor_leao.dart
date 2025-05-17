class CategoryModel {
  final String id;
  final String name;
  final List<ProductItemModel> productItems;

  CategoryModel({required this.id, required this.name, required this.productItems});

  Map<String, dynamic> toMap() => {'id': id, 'name': name};

  factory CategoryModel.fromMap(Map<String, dynamic> map, List<ProductItemModel> items) =>
      CategoryModel(id: map['id'], name: map['name'], productItems: items);
}


