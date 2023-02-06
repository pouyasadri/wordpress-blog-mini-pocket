import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:wordpress_app/pages/home.dart';
import 'package:wordpress_app/tabs/search_tab.dart';

import '../utils/next_screen.dart';

class LiveTvTab extends StatefulWidget {
  const LiveTvTab({Key? key}) : super(key: key);

  @override
  State<LiveTvTab> createState() => _LiveTvTabState();
}

class _LiveTvTabState extends State<LiveTvTab> {
  IconData icon = Feather.maximize;
  Widget _portraitMode(){
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String htmlPortrait = """<!DOCTYPE html>
          <html>
            <head>
            <style>
            body {
              overflow: hidden; 
            }
        .embed-youtube {
            position: relative;
            padding-bottom: 56.25%; 
            padding-top: 0px;
            height: 0;
            overflow: hidden;
        }

        .embed-youtube iframe,
        .embed-youtube object,
        .embed-youtube embed {
            border: 0;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        </style>

        <meta charset="UTF-8">
         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
          <meta http-equiv="X-UA-Compatible" content="ie=edge">
           </head>
          <body bgcolor="#121212">                                    
        <div class="embed-youtube">
        <iframe allowfullscreen="1" frameborder="0"  allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
          webkitallowfullscreen mozallowfullscreen allowfullscreen
          title="Live Tv"
          frameborder="0" style="width:100%;height:100%!important;top:0;left:0;position:absolute;overflow:auto" allowfullscreen src="https://live.ottlive.co.in:8289/livepunjabi/livepunjabi/embed.html"></iframe>
         </div>
          </body>                                    
        </html>
  """;
    final Completer<WebViewController> _controller =
    Completer<WebViewController>();
    final String contentBase64 =
    base64Encode(const Utf8Encoder().convert(htmlPortrait));
    var orientation=MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text('Live TV').tr(),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              icon: Icon(
                icon,
                size: 22,
              ),
              onPressed: () {
                if (orientation==Orientation.portrait) {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.landscapeLeft]);
                  setState(() {
                    icon = Feather.minimize;
                  });
                } else {
                  SystemChrome.setPreferredOrientations(
                      [DeviceOrientation.portraitUp]);
                  setState(() {
                    icon = Feather.maximize;
                  });
                }
              }),
          IconButton(
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 22,
              ),
              onPressed: () {
                nextScreen(context, HomePage(index: 0,));
              })
        ],
      ),
      body: SizedBox(
        height: height,
        width: width,
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
    );
  }
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
  Widget build(BuildContext context) {

    void initState() {
      super.initState();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }

    dispose() {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
      super.dispose();
    }



    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.portrait) {
        return _portraitMode();
      } else {
        return _landscapeMode();
      }

    });
  }
}
