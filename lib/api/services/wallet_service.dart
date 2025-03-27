import 'package:sky/models/recharge_record.dart';

class WalletService {
  static Future<void> recharge({
    required int amount,
    required String paymentMethod,
  }) async {
    // TODO: 实现真实的API调用
    // final response = await HttpClient.post('/wallet/recharge', body: {
    //   'amount': amount,
    //   'payment_method': paymentMethod,
    // });
    
    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 2));
    return;
  }

  static Future<List<RechargeRecord>> getRechargeHistory({
    int page = 1,
    String sortOrder = 'desc',
    String? status,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    
    List<RechargeRecord> mockData = List.generate(
      10,
      (index) => RechargeRecord(
        id: '${page}_$index',
        amount: [6.0, 30.0, 68.0, 128.0, 328.0, 648.0][index % 6],
        coins: [600, 3000, 6800, 12800, 32800, 64800][index % 6],
        bonus: [0, 300, 1020, 2560, 8200, 19440][index % 6],
        // 修改状态生成逻辑，确保 pending 状态正确显示
        status: ['success', 'success', 'pending', 'pending', 'failed'][index % 5],
        paymentMethod: index % 2 == 0 ? '微信支付' : '支付宝',
        createdAt: DateTime.now()
            .subtract(Duration(days: index + ((page - 1) * 10)))
            .toString()
            .substring(0, 16),
      ),
    );

    // 应用状态过滤
    if (status != null && status != 'all') {  // 添加 all 判断
      mockData = mockData.where((record) => record.status == status).toList();
    }

    // 应用排序
    if (sortOrder == 'asc') {
      mockData = mockData.reversed.toList();
    }

    return page <= 3 ? mockData : [];
  }
}