import 'package:sky/models/coupon.dart';

class CouponService {
  static Future<List<Coupon>> getCoupons() async {
    await Future.delayed(const Duration(seconds: 1));
    
    // 模拟数据
    return [
      Coupon(
        id: '1',
        code: 'NEW2024',
        name: '新用户专享券',
        description: '新用户首次充值立减10元',
        amount: 10,
        minSpend: 30,
        validFrom: DateTime.now().subtract(const Duration(days: 30)),
        validUntil: DateTime.now().add(const Duration(days: 30)),
        isUsed: false,
      ),
      Coupon(
        id: '2',
        code: 'SPRING50',
        name: '春季特惠券',
        description: '充值满100元立减50元',
        amount: 50,
        minSpend: 100,
        validFrom: DateTime.now().subtract(const Duration(days: 10)),
        validUntil: DateTime.now().add(const Duration(days: 20)),
        isUsed: false,
      ),
      Coupon(
        id: '3',
        code: 'USED100',
        name: '已使用优惠券',
        description: '充值满200元立减100元',
        amount: 100,
        minSpend: 200,
        validFrom: DateTime.now().subtract(const Duration(days: 15)),
        validUntil: DateTime.now().add(const Duration(days: 15)),
        isUsed: true,
        usedAt: '2024-03-25 14:30',
      ),
    ];
  }
}