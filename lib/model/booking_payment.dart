class BookingPayment {
    BookingPayment({
        this.typePayment,
        this.remainingTurn,
        this.turnToPlay,
        this.turnVisa,
        this.totalFeeVisa,
        this.shopFinshAndContinue,
    });

    int? typePayment;
    int? remainingTurn;
    int? turnToPlay;
    int? turnVisa;
    double? totalFeeVisa;
    bool? shopFinshAndContinue;

    BookingPayment copyWith({
        int? typePayment,
        int? remainingTurn,
        int? turnToPlay,
        int? turnVisa,
        double? totalFeeVisa,
        bool? shopFinshAndContinue,
    }) => 
        BookingPayment(
            typePayment: typePayment ?? this.typePayment,
            remainingTurn: remainingTurn ?? this.remainingTurn,
            turnToPlay: turnToPlay ?? this.turnToPlay,
            turnVisa: turnVisa ?? this.turnVisa,
            totalFeeVisa: totalFeeVisa ?? this.totalFeeVisa,
            shopFinshAndContinue: shopFinshAndContinue ?? this.shopFinshAndContinue,
        );

    factory BookingPayment.fromJson(Map<String, dynamic> json) => BookingPayment(
        typePayment: json["TypePayment"] == null ? null : json["TypePayment"],
        remainingTurn: json["RemainingTurn"] == null ? null : json["RemainingTurn"],
        turnToPlay: json["TurnToPlay"] == null ? null : json["TurnToPlay"],
        turnVisa: json["TurnVisa"] == null ? null : json["TurnVisa"],
        totalFeeVisa: json["TotalFeeVisa"] == null ? null : json["TotalFeeVisa"],
        shopFinshAndContinue: json["ShopFinshAndContinue"] == null ? null : json["ShopFinshAndContinue"],
    );

    Map<String, dynamic> toJson() => {
        "TypePayment": typePayment == null ? null : typePayment,
        "RemainingTurn": remainingTurn == null ? null : remainingTurn,
        "TurnToPlay": turnToPlay == null ? null : turnToPlay,
        "TurnVisa": turnVisa == null ? null : turnVisa,
        "TotalFeeVisa": totalFeeVisa == null ? null : totalFeeVisa,
        "ShopFinshAndContinue": shopFinshAndContinue == null ? null : shopFinshAndContinue,
    };
}
