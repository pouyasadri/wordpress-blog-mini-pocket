import 'dart:async';
import 'dart:convert';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_app/blocs/ads_bloc.dart';
import 'package:wordpress_app/blocs/category_bloc.dart';
import 'package:wordpress_app/blocs/notification_bloc.dart';
import 'package:wordpress_app/blocs/settings_bloc.dart';
import 'package:wordpress_app/blocs/user_bloc.dart';
import 'package:wordpress_app/config/ad_config.dart';
import 'package:wordpress_app/services/app_service.dart';
import 'package:wordpress_app/services/notification_service.dart';
import 'package:wordpress_app/tabs/live_tv_tab.dart';
import 'package:wordpress_app/tabs/profile_tab.dart';
import 'package:wordpress_app/tabs/search_tab.dart';
import 'package:wordpress_app/tabs/video_tab.dart';
import 'package:wordpress_app/utils/next_screen.dart';
import 'package:wordpress_app/utils/snacbar.dart';
import '../tabs/bookmark_tab.dart';
import '../tabs/home_tab.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.index = 0}) : super(key: key);
  int index;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  PageController? _pageController;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final List<IconData> iconList = [
    Feather.search,
    Feather.youtube,
    Feather.tv,
    Feather.home,
    Feather.bookmark,
    Feather.user
  ];
  IconData icon = Feather.maximize;

  Widget _landscapeMode() {
    double height = MediaQuery.of(context).size.height;
    String html = """<!DOCTYPE html>
          <html>
            <head>
          

        <meta charset="UTF-8">
         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
          <meta http-equiv="X-UA-Compatible" content="ie=edge">
           </head>
          <body bgcolor="#121212">                                    
        <div class="embed-youtube">
        <iframe width="200" height="200" allowfullscreen="1" frameborder="0"  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
          webkitallowfullscreen mozallowfullscreen allowfullscreen
          title="Live Tv"
          frameborder="0" style="overflow: auto;width:100%;height:100%;top:0;left:0;position:absolute;" allowfullscreen src="https://live.ottlive.co.in:8289/livepunjabi/livepunjabi/embed.html"></iframe>
         </div>
          </body>                                    
        </html>
  """;
    final Completer<WebViewController> _controller =
        Completer<WebViewController>();
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(html));
    return Stack(
      children: [
        SizedBox(
          height: height,
          child: WebView(
            initialUrl: 'data:text/html;base64,$contentBase64',
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageStarted: (String url) {
              print('Page started loading: $url');
            },
            onPageFinished: (String url) {
              print('Page finished loading: $url');
            },
            gestureNavigationEnabled: true,
          ),
        ),
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                  nextScreen(context, LiveTvTab());
                }),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    AppService().checkInternet().then((hasInternet) {
      if (hasInternet!) {
        context.read<CategoryBloc>().fetchData();
      } else {
        openSnacbar(scaffoldKey, 'no internet'.tr());
      }
    });

    Future.delayed(Duration(milliseconds: 0)).then((_) {
      NotificationService()
          .initFirebasePushNotification(context)
          .then((_) => context.read<NotificationBloc>().checkSubscription())
          .then((_) {
        context.read<SettingsBloc>().getPackageInfo();
        if (!context.read<UserBloc>().guestUser) {
          context.read<UserBloc>().getUserData();
        }
      });
    }).then((_) {
      if (AdConfig.isAdsEnabled) {
        AdConfig()
            .initAdmob()
            .then((value) => context.read<AdsBloc>().initiateAds());
      }
    });
  }

  @override
  void dispose() {
    _pageController!.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    selectedIndex = widget.index;
    super.dispose();
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController!.animateToPage(index,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  Future _onWillPop() async {
    if (selectedIndex != 0) {
      setState(() => selectedIndex = 0);
      _pageController!.animateToPage(0,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    } else {
      await SystemChannels.platform
          .invokeMethod<void>('SystemNavigator.pop', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        return _landscapeMode();
      }
      if (orientation == Orientation.portrait && selectedIndex != 2) {
        return WillPopScope(
          onWillPop: () async => await _onWillPop(),
          child: Scaffold(
            key: scaffoldKey,
            bottomNavigationBar: _bottonNavigationBar(context),
            body: PageView(
              physics: NeverScrollableScrollPhysics(),
              allowImplicitScrolling: false,
              controller: _pageController,
              children: <Widget>[
                SearchTab(),
                VideoTab(),
                LiveTvTab(),
                HomeTab(),
                BookmarkTab(),
                SettingPage()
              ],
            ),
          ),
        );
      }
      return WillPopScope(
        onWillPop: () async => await _onWillPop(),
        child: Scaffold(
          key: scaffoldKey,
          bottomNavigationBar: _bottonNavigationBar(context),
          body: PageView(
            physics: NeverScrollableScrollPhysics(),
            allowImplicitScrolling: false,
            controller: _pageController,
            children: <Widget>[
              SearchTab(),
              VideoTab(),
              LiveTvTab(),
              HomeTab(),
              BookmarkTab(),
              SettingPage()
            ],
          ),
        ),
      );
    });
  }

  AnimatedBottomNavigationBar _bottonNavigationBar(BuildContext context) {
    return AnimatedBottomNavigationBar(
      icons: iconList,
      gapLocation: GapLocation.none,
      activeIndex: selectedIndex,
      iconSize: 22,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      activeColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      inactiveColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      splashColor: Theme.of(context).primaryColor,
      onTap: (index) => onItemTapped(index),
    );
  }
}
