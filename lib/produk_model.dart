class Product {
  final int id;
  final String name;
  final String price;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'] ?? 'Tanpa Nama',
      price: json['price'].toString(),
      description: json['description'] ?? 'Tidak ada deskripsi',
    );
  }
}
