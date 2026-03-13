import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/database_helper.dart';

class AddProductScreen extends StatefulWidget {
  // รับค่า product เข้ามา ถ้าเป็น null คือการเพิ่มใหม่ ถ้ามีข้อมูลคือการแก้ไข
  final Product? product;

  const AddProductScreen({super.key, this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  bool get isEditing => widget.product != null; // เช็คว่ากำลังแก้ไขอยู่หรือไม่

  @override
  void initState() {
    super.initState();
    // ถ้าเป็นการแก้ไข ให้นำข้อมูลเดิมมาใส่ในช่องกรอก
    if (isEditing) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descController.text = widget.product!.description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'แก้ไขสินค้า' : 'เพิ่มสินค้าใหม่'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อสินค้า',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกชื่อ' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ราคา',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'กรุณากรอกราคา' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'รายละเอียด',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'กรุณากรอกรายละเอียด' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // สร้างออบเจกต์สินค้า (ถ้าเป็นการแก้ไข ให้ส่ง ID เดิมไปด้วย)
                      final newProduct = Product(
                        id: isEditing ? widget.product!.id : null,
                        name: _nameController.text,
                        price: double.parse(_priceController.text),
                        description: _descController.text,
                      );

                      // เลือกว่าจะ บันทึกใหม่ หรือ อัปเดตข้อมูลเดิม
                      if (isEditing) {
                        await DatabaseHelper.instance.updateProduct(newProduct);
                      } else {
                        await DatabaseHelper.instance.insertProduct(newProduct);
                      }

                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'อัปเดตสินค้าเรียบร้อย'
                                  : 'เพิ่มสินค้าเรียบร้อย',
                            ),
                          ),
                        );
                        Navigator.pop(context, true);
                      }
                    }
                  },
                  child: Text(
                    isEditing ? 'อัปเดตข้อมูล' : 'บันทึกสินค้า',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
