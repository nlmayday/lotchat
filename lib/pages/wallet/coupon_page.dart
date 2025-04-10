import 'package:flutter/material.dart';
import 'package:sky/models/coupon.dart';
import 'package:sky/api/services/coupon_service.dart';

class CouponPage extends StatefulWidget {
  final bool? isSelecting;
  final double? currentAmount;

  const CouponPage({
    super.key,
    this.isSelecting = false,
    this.currentAmount,
  });

  @override
  State<CouponPage> createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Coupon> _coupons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCoupons();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCoupons() async {
    try {
      final coupons = await CouponService.getCoupons();
      setState(() {
        _coupons = coupons;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载失败: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('我的优惠券'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '未使用'),
            Tab(text: '已使用/已过期'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCouponList(true),
                _buildCouponList(false),
              ],
            ),
    );
  }

  Widget _buildCouponList(bool isValid) {
    final filteredCoupons = _coupons.where((coupon) => 
      isValid ? coupon.isValid : (!coupon.isValid || coupon.isUsed)
    ).toList();

    if (filteredCoupons.isEmpty) {
      return Center(
        child: Text(isValid ? '暂无可用优惠券' : '暂无已使用/过期优惠券'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredCoupons.length,
      itemBuilder: (context, index) {
        final coupon = filteredCoupons[index];
        final canUse = widget.currentAmount == null || 
                      widget.currentAmount! >= coupon.minSpend;
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: widget.isSelecting == true && canUse && coupon.isValid
                ? () => Navigator.pop(context, coupon)
                : null,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '¥${coupon.amount}',
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupon.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              coupon.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[400],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '满${coupon.minSpend}元可用',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        coupon.isUsed
                            ? '已使用于 ${coupon.usedAt}'
                            : '有效期至 ${coupon.validUntil.toString().substring(0, 10)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}