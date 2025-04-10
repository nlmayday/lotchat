import 'package:flutter/material.dart';
import 'package:sky/pages/wallet/recharge_page.dart';
import 'package:sky/utils/search_history_manager.dart';
import 'package:sky/providers/user_provider.dart';
import 'package:provider/provider.dart';

class HomeSearchBar extends StatefulWidget {
  final Function(String) onSearch;

  const HomeSearchBar({super.key, required this.onSearch});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _searchHistory = [];
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
    _focusNode.addListener(_onFocusChange);
  }

  // 移除 _isClearing 变量，改用不同的方案

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!_focusNode.hasFocus) {
          _hideOverlay();
        }
      });
    }
  }

  Future<void> _loadSearchHistory() async {
    final history = await SearchHistoryManager.getSearchHistory();
    if (!mounted) return;
    setState(() {
      _searchHistory = history;
    });
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hideOverlay,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                ),
              ),
              Positioned(
                width: size.width - 80,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  offset: const Offset(0.0, 60.0),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 300),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('搜索历史'),
                                TextButton(
                                  onPressed: () async {
                                    await SearchHistoryManager.clearSearchHistory();
                                    if (!mounted) return;
                                    setState(() {
                                      _searchHistory = [];
                                    });
                                    _focusNode.requestFocus(); // 保持焦点
                                  },
                                  child: const Text('清空'),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          if (_searchHistory.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: Text('暂无搜索历史')),
                            )
                          else
                            Flexible(
                              child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: _searchHistory.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.history),
                                    title: Text(_searchHistory[index]),
                                    onTap: () {
                                      _controller.text = _searchHistory[index];
                                      _onSearch(_searchHistory[index]);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _onSearch(String keyword) async {
    // if (keyword.trim().isEmpty) return;

    await SearchHistoryManager.addSearchHistory(keyword);
    await _loadSearchHistory();

    if (!mounted) return;
    widget.onSearch(keyword);
    _hideOverlay();
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Row(
      children: [
        Expanded(
          child: CompositedTransformTarget(
            link: _layerLink,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: InputDecoration(
                hintText: '搜索角色',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _controller.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _controller.clear();
                            setState(() {});
                          },
                        )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onTap: _showOverlay,
              onSubmitted: _onSearch,
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RechargePage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(255, 215, 0, 0.2),
              border: Border.all(color: Colors.amber),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  '${userProvider.user?.coins ?? 0}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.amber,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/profile');
          },
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[200],
            backgroundImage:
                userProvider.user?.avatar != null
                    ? NetworkImage(userProvider.user!.avatar!)
                    : const AssetImage('assets/images/default_avatar.png')
                        as ImageProvider,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
