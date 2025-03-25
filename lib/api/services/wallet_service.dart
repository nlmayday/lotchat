import '../client/http_client.dart';

class WalletService {
  static Future<Map<String, dynamic>> getWalletInfo() async {
    final response = await HttpClient.get('/wallet/info');
    return response;
  }

  static Future<List<Map<String, dynamic>>> getTransactionHistory() async {
    final response = await HttpClient.get('/wallet/transactions');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createRechargeOrder({
    required int amount,
    required String paymentMethod,
    String? couponCode,
  }) async {
    final response = await HttpClient.post(
      '/wallet/recharge',
      body: {
        'amount': amount,
        'paymentMethod': paymentMethod,
        if (couponCode != null) 'couponCode': couponCode,
      },
    );
    return response;
  }

  static Future<List<Map<String, dynamic>>> getCoupons() async {
    final response = await HttpClient.get('/wallet/coupons');
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> checkPaymentStatus(String orderId) async {
    final response = await HttpClient.get('/wallet/payment/status/$orderId');
    return response;
  }
}