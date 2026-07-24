class SplitTransaction {
  SplitTransaction(this.sender, this.receiver, this.amount);

  factory SplitTransaction.fromJson(Map<String, dynamic> json) {
    return SplitTransaction(
      json['sender'] as String,
      json['receiver'] as String,
      json['amount'] as num,
    );
  }

  late String sender;
  late String receiver;
  late num amount;

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'receiver': receiver,
    'amount': amount,
  };

  // static FinalTransaction fromJson(Map<String, dynamic> json) {
  //   return FinalTransaction(
  //       sender: json['sender'],
  //       receiver: json["receiver"],
  //       amount: double.parse(json['amount'].toString())
  //   );
  // }
}
