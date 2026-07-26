class CartItemModel {
  final int productId;
  final String name;
  final int price;
  final int quantity;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
  });

  int get subtotal => price * quantity;

  CartItemModel copyWith({
    int? productId,
    String? name,
    int? price,
    int? quantity,
  }) {
    return CartItemModel(
      productId: productId ?? this.productId,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'name': name,
      'price': price,
      'quantity': quantity
    };
  }
}