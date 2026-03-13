import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/database_helper.dart';
import '../screens/add_product_screen.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback
  onRefresh; // เพิ่มตัวแปรสำหรับสั่งรีเฟรชหน้าจอเมื่อลบหรือแก้ไขเสร็จ

  const ProductCard({
    super.key,
    required this.product,
    required this.onRefresh,
  });

  // ฟังก์ชันแสดงกล่องยืนยันการลบ
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ยืนยันการลบ'),
        content: Text('คุณต้องการลบ "${product.name}" ใช่หรือไม่?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              await DatabaseHelper.instance.deleteProduct(
                product.id!,
              ); // สั่งลบจากฐานข้อมูล
              if (context.mounted) {
                Navigator.pop(context);
                onRefresh(); // รีเฟรชหน้าจอหลัก
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('ลบสินค้าแล้ว')));
              }
            },
            child: const Text('ลบสินค้า'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.eco,
                    size: 40,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.description,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '฿${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // แถบเมนูด้านล่างของการ์ด (เพิ่ม ลบ แก้ไข)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // ปุ่มแก้ไข
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddProductScreen(product: product),
                          ),
                        );
                        if (result == true) onRefresh();
                      },
                    ),
                    // ปุ่มลบ
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => _showDeleteDialog(context),
                    ),
                  ],
                ),
                // ปุ่มใส่ตะกร้า
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text('หยิบ'),
                  onPressed: () {
                    context.read<CartProvider>().addToCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('เพิ่ม ${product.name} ลงตะกร้าแล้ว'),
                        backgroundColor: Colors.green.shade800,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
