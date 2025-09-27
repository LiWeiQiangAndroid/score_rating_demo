import 'package:flutter/material.dart';

class TabWithSearchPage extends StatefulWidget {
  const TabWithSearchPage({Key? key}) : super(key: key);

  @override
  State<TabWithSearchPage> createState() => _TabWithSearchPageState();
}

class _TabWithSearchPageState extends State<TabWithSearchPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<Offset> _tabBarAnimation;
  late Animation<Offset> _searchBarAnimation;
  late Animation<double> _paddingAnimation;

  bool _isVisible = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _tabBarAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _searchBarAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _paddingAnimation = Tween<double>(
      begin: 120,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleScrollNotification(bool isScrollingUp) {
    if (isScrollingUp && !_isVisible) {
      setState(() {
        _isVisible = true;
      });
      _animationController.reverse();
    } else if (!isScrollingUp && _isVisible) {
      setState(() {
        _isVisible = false;
      });
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          // 全屏TabBarView
          SafeArea(
            child: AnimatedBuilder(
              animation: _paddingAnimation,
              builder: (context, child) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: _paddingAnimation.value,
                  ),
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      TabContentPage(
                        title: '首页',
                        onScrollNotification: _handleScrollNotification,
                      ),
                      TabContentPage(
                        title: '发现',
                        onScrollNotification: _handleScrollNotification,
                      ),
                      TabContentPage(
                        title: '我的',
                        onScrollNotification: _handleScrollNotification,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // TabBar
          SlideTransition(
            position: _tabBarAnimation,
            child: Container(
              color: Colors.white,
              child: SafeArea(
                bottom: false,
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.blue,
                  tabs: const [
                    Tab(text: '首页'),
                    Tab(text: '发现'),
                    Tab(text: '我的'),
                  ],
                ),
              ),
            ),
          ),
          // 搜索框
          SlideTransition(
            position: _searchBarAnimation,
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 48, // SafeArea top + TabBar height
              ),
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: '搜索...',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TabContentPage extends StatefulWidget {
  final String title;
  final Function(bool) onScrollNotification;

  const TabContentPage({
    Key? key,
    required this.title,
    required this.onScrollNotification,
  }) : super(key: key);

  @override
  State<TabContentPage> createState() => _TabContentPageState();
}

class _TabContentPageState extends State<TabContentPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  List<String> _items = [];
  List<String> _filteredItems = [];
  double _lastScrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _generateItems();
    _filteredItems = List.from(_items);

    _scrollController.addListener(_onScroll);
    _searchController.addListener(_onSearchChanged);
  }

  void _generateItems() {
    _items = List.generate(100, (index) => '${widget.title} - 项目 ${index + 1}');
  }

  void _onScroll() {
    final currentOffset = _scrollController.offset;
    final isScrollingUp = currentOffset < _lastScrollOffset;

    if ((currentOffset - _lastScrollOffset).abs() > 10) {
      widget.onScrollNotification(isScrollingUp);
      _lastScrollOffset = currentOffset;
    }
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredItems = List.from(_items);
      } else {
        _filteredItems = _items
            .where((item) => item.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollUpdateNotification) {
          _onScroll();
        }
        return false;
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text('${index + 1}'),
              ),
              title: Text(_filteredItems[index]),
              subtitle: Text('这是${_filteredItems[index]}的描述信息'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('点击了 ${_filteredItems[index]}'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}