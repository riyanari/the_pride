import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_pride/pages/account/accounts_page.dart';
import 'package:the_pride/pages/daily-talks/daily_talk_page.dart';
import 'package:the_pride/pages/news/news_page.dart';
import 'package:the_pride/pages/rewards/rewards_page.dart';
import 'package:the_pride/pages/teori/teori_page.dart';
import '../../theme/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  final PageController _pageController = PageController(initialPage: 2);
  DateTime? _lastPressedAt;

  final _children = const <Widget>[
    NewsPage(),
    RewardsPage(),
    TeoriPage(),
    DailyTalkPage(),
    AccountsPage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPopInvoked(bool result) {
    final now = DateTime.now();
    final doubleTap =
        _lastPressedAt != null &&
        now.difference(_lastPressedAt!) < const Duration(seconds: 1);
    if (doubleTap) {
      // Exit the app
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      // Update the last pressed time
      _lastPressedAt = now;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Center(child: Text('Tap back again to exit'))),
      );
    }
  }

  Widget _activePill(BuildContext context, String assetPath, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      decoration: BoxDecoration(
        color: kWhiteColor.withValues(alpha:0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(assetPath, height: 20, width: 20),
          const SizedBox(width: 4),
          Text(
            label,
            style: titleWhiteTextStyle.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _activeTeori(BuildContext context, String assetPath, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kWhiteColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(assetPath, height: 20, width: 20),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: titleWhiteTextStyle.copyWith(fontSize: 10),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _inactiveTeori(String assetPath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: kWhiteColor.withValues(alpha: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(assetPath, height: 20, width: 20),
        ),
        // const SizedBox(height: 4),
        // Text(
        //   'Teori',
        //   style: titleWhiteTextStyle.copyWith(fontSize: 10, color: Colors.white.withValues(alpha:0.7)),
        //   maxLines: 1,
        //   overflow: TextOverflow.ellipsis,
        // ),
      ],
    );
  }

  Widget _inactiveIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Image.asset(assetPath, height: 24, width: 24),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: _onPopInvoked,
        child: Scaffold(
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: kBackgroundPrimaryColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // News
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                      _pageController.jumpToPage(0);
                    },
                    child: _currentIndex == 0
                        ? _activePill(context, 'assets/ic_news.png', 'News')
                        : _inactiveIcon('assets/ic_news.png'),
                  ),
                  // Rewards
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                      _pageController.jumpToPage(1);
                    },
                    child: _currentIndex == 1
                        ? _activePill(context, 'assets/ic_reward.png', 'Reward')
                        : _inactiveIcon('assets/ic_reward.png'),
                  ),
                  // Teori
                  // Teori
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });
                      _pageController.jumpToPage(2);
                    },
                    child: _currentIndex == 2
                        ? _activeTeori(context, 'assets/ic_teori.png', 'Teori')
                        : _inactiveTeori('assets/ic_teori.png'),
                  ),
                  // Talk
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 3;
                      });
                      _pageController.jumpToPage(3);
                    },
                    child: _currentIndex == 3
                        ? _activePill(context, 'assets/ic_talk.png', 'Talk')
                        : _inactiveIcon('assets/ic_talk.png'),
                  ),
                  // Profile
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 4;
                      });
                      _pageController.jumpToPage(4);
                    },
                    child: _currentIndex == 4
                        ? _activePill(
                            context,
                            'assets/ic_account.png',
                            'Profile',
                          )
                        : _inactiveIcon('assets/ic_account.png'),
                  ),
                ],
              ),
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            children: _children,
          ),
        ),
      ),
    );
  }
}
