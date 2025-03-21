class PaymentItem {
    PaymentItem({
        this.id,
        this.name,
        this.price,
        this.quantity,
    });

    int? id;
    String? name;
    int? price;
    int? quantity;

    PaymentItem copyWith({
        int? id,
        String? name,
        int? price,
        int? quantity,
    }) => 
        PaymentItem(
            id: id ?? this.id,
            name: name ?? this.name,
            price: price ?? this.price,
            quantity: quantity ?? this.quantity,
        );

    factory PaymentItem.fromJson(Map<String, dynamic> json) => PaymentItem(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        price: json["price"] == null ? null : json["price"],
        quantity: json["quantity"] == null ? null : json["quantity"],
    );

    Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "price": price == null ? null : price,
        "quantity": quantity == null ? null : quantity,
    };
}