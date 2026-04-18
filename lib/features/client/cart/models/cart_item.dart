class CartItem {
  final String itemId;
  final String restaurantId;
  final String name;
  final double price;
  final String? imageUrl;
  int quantity;

  CartItem({
    required this.itemId,
    required this.restaurantId,
    required this.name,
    required this.price,
    this.imageUrl,
    this.quantity = 1,
  });

  CartItem copyWith({int? quantity}) => CartItem(
        itemId: itemId,
        restaurantId: restaurantId,
        name: name,
        price: price,
        imageUrl: imageUrl,
        quantity: quantity ?? this.quantity,
      );

  double get total => price * quantity;
}
