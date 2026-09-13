import 'package:casher_pos/features/products/data/dtos/store_product_dto.dart';

class UpdateProductDto extends StoreProductDto {
  final int id;
  const UpdateProductDto({
    required this.id, 
    required super.name, 
    required super.price,
    required super.categoryId,
    required super.image
  });
}