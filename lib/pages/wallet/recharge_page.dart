import 'package:flutter/material.dart';
import 'package:sky/pages/wallet/widgets/recharge_card.dart';
import 'package:sky/pages/wallet/widgets/coupon_selector.dart';

class RechargePage extends StatefulWidget {
  const RechargePage({super.key});

  @override
  State<RechargePage> createState() => _RechargePageState();
}

class _RechargePageState extends State<RechargePage> {
  int _selectedAmount = 0;
  String? _selectedCoupon;

  final List<RechargeOption> _options = [
    RechargeOption(amount: 50, coins: 500, bonus: 50),
    RechargeOption(amount: 100, coins: 1000, bonus: 150),
    RechargeOption(amount: 200, coins: 2000, bonus: 400),
    RechargeOption(amount: 500, coins: 5000, bonus: 1500),
    RechargeOption(amount: 1000, coins: 10000, bonus: 4000),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('充值')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  '选择充值金额',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _options.length,
                  itemBuilder: (context, index) {
                    return RechargeCard(
                      option: _options[index],
                      isSelected: _selectedAmount == _options[index].amount,
                      onTap: () {
                        setState(() {
                          _selectedAmount = _options[index].amount;
                        });
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
                CouponSelector(
                  selectedCoupon: _selectedCoupon,
                  onCouponSelected: (coupon) {
                    setState(() {
                      _selectedCoupon = coupon;
                    });
                  },
                ),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final selectedOption = _options.firstWhere(
      (option) => option.amount == _selectedAmount,
      orElse: () => _options[0],
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.95),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '支付金额：¥${selectedOption.amount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '可获得：${selectedOption.coins + selectedOption.bonus}金币',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed:
                  _selectedAmount == 0
                      ? null
                      : () {
                        // TODO: 处理支付逻辑
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('立即支付'),
            ),
          ],
        ),
      ),
    );
  }
}

class RechargeOption {
  final int amount;
  final int coins;
  final int bonus;

  RechargeOption({
    required this.amount,
    required this.coins,
    required this.bonus,
  });
}
