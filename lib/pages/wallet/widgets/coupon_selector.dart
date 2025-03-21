import 'package:flutter/material.dart';

class CouponSelector extends StatelessWidget {
  final String? selectedCoupon;
  final Function(String?) onCouponSelected;

  const CouponSelector({
    super.key,
    required this.selectedCoupon,
    required this.onCouponSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '选择优惠券',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            _showCouponBottomSheet(context);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.local_offer_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 12),
                Text(
                  selectedCoupon ?? '暂无可用优惠券',
                  style: TextStyle(
                    color:
                        selectedCoupon != null
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                  ),
                ),
                const Spacer(),
                const Icon(Icons.chevron_right, color: Colors.white54),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCouponBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => CouponBottomSheet(
            selectedCoupon: selectedCoupon,
            onCouponSelected: onCouponSelected,
          ),
    );
  }
}

class CouponBottomSheet extends StatelessWidget {
  final String? selectedCoupon;
  final Function(String?) onCouponSelected;

  const CouponBottomSheet({
    super.key,
    required this.selectedCoupon,
    required this.onCouponSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                '选择优惠券',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // TODO: 实现优惠券列表
          const Center(child: Text('暂无可用优惠券')),
        ],
      ),
    );
  }
}
