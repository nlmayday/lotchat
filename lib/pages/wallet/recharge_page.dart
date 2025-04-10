import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sky/models/coupon.dart';
import 'package:sky/providers/user_provider.dart';
import 'package:sky/api/services/wallet_service.dart';
import 'package:sky/pages/wallet/coupon_page.dart';
class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  double _selectedAmount = 30;
  String _selectedPayment = 'wechat';
  bool _isLoading = false;
  Coupon? _selectedCoupon;  // 添加选中的优惠券状态

  final List<Map<String, dynamic>> _amountOptions = [
    {'amount': 6, 'coins': 600, 'bonus': null},
    {'amount': 30, 'coins': 3000, 'bonus': 10},
    {'amount': 68, 'coins': 6800, 'bonus': 15},
    {'amount': 128, 'coins': 12800, 'bonus': 20},
    {'amount': 328, 'coins': 32800, 'bonus': 25},
    {'amount': 648, 'coins': 64800, 'bonus': 30},
  ];

  // 添加选择优惠券的方法
  Future<void> _selectCoupon() async {
    final coupon = await Navigator.push<Coupon>(
      context,
      MaterialPageRoute(
        builder: (context) => CouponPage(
          isSelecting: true,
          currentAmount: _selectedAmount,
        ),
      ),
    );

    if (coupon != null && mounted) {
      setState(() => _selectedCoupon = coupon);
    }
  }

  // 修改支付处理方法，添加优惠券
  Future<void> _handlePay() async {
    setState(() => _isLoading = true);

    try {
      await WalletService.recharge(
        amount: _selectedAmount,
        paymentMethod: _selectedPayment,
        couponId: _selectedCoupon?.id,  // 添加优惠券ID
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('支付成功')),
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('支付失败: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('充值中心'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // 余额卡片
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB938), Color(0xFFFF8C38)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '当前余额',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '🪙 ${user?.coins ?? 0}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // 充值金额选择
                const Text(
                  '选择充值金额',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: _amountOptions.length,
                  itemBuilder: (context, index) {
                    final option = _amountOptions[index];
                    final isSelected = option['amount'] == _selectedAmount;
                    
                    return GestureDetector(
                      onTap: () => setState(() => _selectedAmount = option['amount']),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(15),
                        child: Stack(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '¥${option['amount']}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.black : null,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${option['coins']}金币',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.black.withOpacity(0.8)
                                        : Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                            if (option['bonus'] != null)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    '送${option['bonus']}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // 优惠券选择
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: _selectCoupon,
                    child: Row(
                      children: [
                        const Icon(Icons.local_offer_outlined),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedCoupon != null 
                                    ? '已选择：${_selectedCoupon!.name}'
                                    : '选择优惠券',
                              ),
                              if (_selectedCoupon != null)
                                Text(
                                  '满${_selectedCoupon!.minSpend}元减${_selectedCoupon!.amount}元',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // 支付方式选择
                const Text(
                  '支付方式',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                _buildPaymentMethod(
                  icon: '💳',
                  name: '微信支付',
                  value: 'wechat',
                ),
                const SizedBox(height: 15),
                _buildPaymentMethod(
                  icon: '💳',
                  name: '支付宝',
                  value: 'alipay',
                ),
                const SizedBox(height: 15),
                _buildPaymentMethod(
                  icon: '💳',
                  name: 'Apple Pay',
                  value: 'apple',
                ),
              ],
            ),
          ),
          
          // 底部支付栏
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                const Text('总计'),
                Row(
                  children: [
                    Text(
                      '¥$_selectedAmount',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (_selectedCoupon != null)
                      Text(
                        ' -¥${_selectedCoupon!.amount}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _handlePay,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('立即支付'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod({
    required String icon,
    required String name,
    required String value,
  }) {
    final isSelected = value == _selectedPayment;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = value),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.white.withOpacity(0.2)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 15),
            Text(name),
            const Spacer(),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Theme.of(context).primaryColor : null,
                border: Border.all(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
