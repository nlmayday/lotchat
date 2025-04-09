import 'package:flutter/material.dart';
import 'package:sky/api/services/character_service.dart';
import 'package:sky/models/banner.dart';
import 'package:sky/models/character.dart';
import 'package:sky/pages/home/widgets/character_grid.dart';
import 'package:sky/pages/home/widgets/category_tabs.dart';
import 'package:sky/pages/home/widgets/search_bar.dart';
import 'package:sky/widgets/common_bottom_nav.dart';
import 'package:sky/api/api_client.dart'; // 导入 ApiClient
import 'package:sky/api/services/banner_service.dart';
import 'package:sky/pages/home/widgets/banner_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _currentCategory = '推荐';
  int _currentPage = 1;
  final int _pageSize = 8;
  bool _hasMore = true;
  List<Character> _characters = [];
  bool _isLoading = false;
  late Future<List<BannerItem>> _bannerListFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadCharacters(_currentCategory);
    _bannerListFuture = BannerService.getBannerList();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (!_isLoading && _hasMore) {
        _loadMoreCharacters();
      }
    }
  }

  void _loadCharacters(String category, {String? keyword}) {
    setState(() {
      _currentPage = 1;
      _characters = [];
      _hasMore = true;
      _isLoading = false;
    });

    CharacterService.getCharacterList(
      page: _currentPage,
      pageSize: _pageSize,
      searchParams: {
        if (category != '推荐') 'category': category,
        if (keyword != null && keyword.isNotEmpty) 'keyword': keyword,
      },
    ).then((result) {
      setState(() {
        _characters = result['data'] as List<Character>;
        _hasMore = _characters.length < (result['total'] as int);
      });
    });
  }

  Future<void> _loadMoreCharacters() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final result = await CharacterService.getCharacterList(
      page: _currentPage + 1,
      pageSize: _pageSize,
      searchParams: {
        if (_currentCategory != '推荐') 'category': _currentCategory,
      },
    );

    setState(() {
      _currentPage++;
      _characters.addAll(result['data'] as List<Character>);
      _hasMore = _characters.length < (result['total'] as int);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: HomeSearchBar(
                onSearch: (keyword) {
                  setState(() {
                    _currentCategory = '推荐';
                    _loadCharacters('推荐', keyword: keyword);
                  });
                },
              ),
            ),
            FutureBuilder<List<BannerItem>>(
              future: _bannerListFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return BannerSlider(banners: snapshot.data!);
                }
                return const SizedBox(height: 200);
              },
            ),
            const SizedBox(height: 24),
            CategoryTabs(
              currentCategory: _currentCategory,
              onCategoryChanged: (category) {
                setState(() {
                  _currentCategory = category;
                  _loadCharacters(category);
                });
              },
            ),
            Expanded(
              child:
                  _characters.isEmpty && _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView(
                        controller: _scrollController,
                        children: [
                          CharacterGrid(
                            characters: _characters,
                            onCharacterTap: _onCharacterTap,
                          ),
                          if (_isLoading)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          if (!_hasMore && _characters.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: Text('没有更多数据了')),
                            ),
                        ],
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CommonBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0:
              // 当前页面，无需跳转
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/favorites');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/history');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  void _onCharacterTap(String characterId) {
    Navigator.pushNamed(context, '/chat', arguments: {'characterId': '3'});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
