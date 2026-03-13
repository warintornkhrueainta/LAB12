class Product {
  final int? id;
  final String name;
  final double price;
  final String description;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.description,
  });

  factory Product.fromMap(Map<String, dynamic> json) => Product(
    id: json['id'],
    name: json['name'],
    price: json['price'],
    description: json['description'],
  );

  // เพิ่มฟังก์ชันนี้สำหรับแปลงเป็น Map ส่งให้ SQLite
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'price': price,
      'description': description,
    };
  }
}
