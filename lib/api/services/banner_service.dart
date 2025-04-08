import 'package:sky/models/banner.dart';

class BannerService {
  static Future<List<BannerItem>> getBannerList() async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(milliseconds: 800));
    
    // 模拟数据
    return [
      BannerItem(
        id: '1',
        imageUrl: 'assets/images/banner1.png',
        title: '赛博朋克女孩',
        description: '未来科技风格的虚拟伙伴',
        likes: 2800,
        stars: 1200,
        coins: 500,
      ),
      BannerItem(
        id: '2',
        imageUrl: 'assets/images/banner2.png',
        title: '未来战士',
        description: '科幻世界的冒险伙伴',
        likes: 3100,
        stars: 1500,
        coins: 600,
      ),
      BannerItem(
        id: '3',
        imageUrl: 'assets/images/banner3.png',
        title: '机械天使',
        description: '科技与艺术的完美融合',
        likes: 2500,
        stars: 1100,
        coins: 450,
      ),
    ];
  }
}