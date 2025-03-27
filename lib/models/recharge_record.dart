class RechargeRecord {
  final String id;
  final double amount;
  final int coins;
  final int bonus;
  final String status;
  final String paymentMethod;
  final String createdAt;

  const RechargeRecord({
    required this.id,
    required this.amount,
    required this.coins,
    required this.bonus,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
  });

  factory RechargeRecord.fromJson(Map<String, dynamic> json) {
    return RechargeRecord(
      id: json['id'],
      amount: json['amount'].toDouble(),
      coins: json['coins'],
      bonus: json['bonus'] ?? 0,
      status: json['status'],
      paymentMethod: json['payment_method'],
      createdAt: json['created_at'],
    );
  }
}