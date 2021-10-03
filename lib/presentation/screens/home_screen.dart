import 'package:eigital_test/models/news.dart';
import 'package:eigital_test/presentation/screens/widgets/calculator/calculator.dart';
import 'package:eigital_test/presentation/screens/widgets/map/maps.dart';
import 'package:eigital_test/presentation/screens/widgets/news/news_listview.dart';
import 'package:eigital_test/services/news_network.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String route = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NewsList _fetchNewsList = NewsList(news: []);
  NewsList _newsList = NewsList(news: []);
  bool _isLoading = true;

  final _tabs = <Tab>[
    const Tab(
      text: 'Map',
    ),
    const Tab(
      text: 'News',
    ),
    const Tab(
      text: 'Calculator',
    ),
  ];

  @override
  void initState() {
    _fetchNewsData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: _renderTabBar(_tabs),
        ),
        body: _renderTabBarView(),
      ),
    );
  }

  TabBar _renderTabBar(List<Tab> _tabs) {
    return TabBar(
      isScrollable: true,
      tabs: _tabs,
    );
  }

  TabBarView _renderTabBarView() {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // const Text("MAP"),
        const Maps(),
        // Text("NEWS"),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : NewsListview(newsList: _newsList),
        // const Text("CALCULATOR"),
        const Calculator(),
      ],
    );
  }

  void _fetchNewsData() async {
    final newsNetwork = NewsNetwork();

    try {
      _fetchNewsList = await newsNetwork.fetchNewsData();

      setState(() {
        _isLoading = false;
        _newsList = _fetchNewsList;
      });
    } catch (e) {
      print(e);
    }
  }
}
