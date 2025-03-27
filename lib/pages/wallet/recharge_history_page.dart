import 'package:flutter/material.dart';
import 'package:sky/api/services/wallet_service.dart';
import 'package:sky/models/recharge_record.dart';

class RechargeHistoryPage extends StatefulWidget {
  const RechargeHistoryPage({super.key});

  @override
  State<RechargeHistoryPage> createState() => _RechargeHistoryPageState();
}

class _RechargeHistoryPageState extends State<RechargeHistoryPage> {
  final List<RechargeRecord> _records = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  final ScrollController _scrollController = ScrollController();
  
  // 添加排序和过滤状态
  String _sortOrder = 'desc'; // 'desc' 或 'asc'
  String? _statusFilter; // null 表示全部，'pending'，'success' 或 'failed'

  @override
  void initState() {
    super.initState();
    _loadRecords();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('充值记录'),
        actions: [
          IconButton(
            icon: Icon(_sortOrder == 'desc' 
                ? Icons.arrow_downward 
                : Icons.arrow_upward),
            onPressed: () {
              setState(() {
                _sortOrder = _sortOrder == 'desc' ? 'asc' : 'desc';
                _loadRecords();
              });
            },
          ),
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                // 修改过滤器逻辑
                _statusFilter = value == 'all' ? null : value;
                _loadRecords();
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'all',  // 修改为 'all'
                child: Text('全部'),
              ),
              const PopupMenuItem(
                value: 'pending',
                child: Text('充值中'),
              ),
              const PopupMenuItem(
                value: 'success',
                child: Text('充值成功'),
              ),
              const PopupMenuItem(
                value: 'failed',
                child: Text('充值失败'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // 添加过滤器提示条
          if (_statusFilter != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Row(
                children: [
                  Text('状态: ${_getStatusText(_statusFilter!)}'),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _statusFilter = null;
                        _loadRecords();
                      });
                    },
                    child: const Text('清除筛选'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _records.isEmpty
                    ? const Center(child: Text('暂无充值记录'))
                    : RefreshIndicator(
                        onRefresh: _loadRecords,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: _records.length + (_hasMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index == _records.length) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: _isLoadingMore
                                      ? const CircularProgressIndicator()
                                      : const Text('没有更多数据了'),
                                ),
                              );
                            }

                            final record = _records[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(record.status).withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _getStatusIcon(record.status),
                                    color: _getStatusColor(record.status),
                                  ),
                                ),
                                title: Text('充值 ¥${record.amount}'),
                                subtitle: Text(
                                  '${record.paymentMethod} · ${record.createdAt}',
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '+${record.coins}金币',
                                      style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (record.bonus > 0)
                                      Text(
                                        '赠送 ${record.bonus}金币',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return '充值中';
      case 'success':
        return '充值成功';
      case 'failed':
        return '充值失败';
      default:
        return '未知状态';
    }
  }

  IconData _getStatusIcon(String status) {
      switch (status) {
        case 'success':
          return Icons.check;
        case 'pending':
          return Icons.pending_outlined;
        case 'failed':
          return Icons.close;
        default:
          return Icons.help_outline;
      }
    }
  
    Color _getStatusColor(String status) {
      switch (status) {
        case 'success':
          return Colors.green;
        case 'pending':
          return Colors.orange;
        case 'failed':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

  Future<void> _loadRecords() async {
    try {
      final records = await WalletService.getRechargeHistory(
        page: 1,
        sortOrder: _sortOrder,
        status: _statusFilter,
      );
      setState(() {
        _records.clear();
        _records.addAll(records);
        _isLoading = false;
        _currentPage = 1;
        _hasMore = records.length == 10;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载失败: $e')),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() => _isLoadingMore = true);

    try {
      final records = await WalletService.getRechargeHistory(
        page: _currentPage + 1,
        sortOrder: _sortOrder,
        status: _statusFilter,
      );
      
      if (mounted) {
        setState(() {
          _records.addAll(records);
          _currentPage++;
          _hasMore = records.length == 10;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('加载更多失败: $e')),
      );
      setState(() => _isLoadingMore = false);
    }
  }
}