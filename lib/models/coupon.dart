class Coupon {
  final String id;
  final String code;
  final String name;
  final String description;
  final double amount;
  final double minSpend;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isUsed;
  final String? usedAt;

  const Coupon({
    required this.id,
    required this.code,
    required this.name,
    required this.description,
    required this.amount,
    required this.minSpend,
    required this.validFrom,
    required this.validUntil,
    required this.isUsed,
    this.usedAt,
  });

  bool get isValid => DateTime.now().isBefore(validUntil) && !isUsed;
}