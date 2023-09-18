import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'AuthPage.dart';
import 'Profile.dart';
import '../Models/cache.dart';
import '../controller/string.dart';
import 'package:onboarding/onboarding.dart';
import 'dart:ui' as ui;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool loggedin;
  runApp(
      new MediaQuery(
          data: new MediaQueryData.fromWindow(ui.window),
          child: new Directionality(
              textDirection: TextDirection.rtl,
              child: SplashScreen())));
  Future.delayed(const Duration(milliseconds: 2000), () {
    AppCache.isUserLoggedIn().then((bool result){
      loggedin=result;
      runApp(MaterialApp(
        theme: ThemeData(
            colorSchemeSeed: const Color(0xff6750a4), useMaterial3: true),
        title: 'GamePartner',
        home: loggedin ? HomePage(steamid:"Desired Data", profile: true): MyApp(),
      ),
      );
    });
  });
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.deepPurple,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/images/logo2.png"),
        ],
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Material materialButton;
  late int index;

  Future<void> signup() async {
    AppCache.completeOnboarding();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AuthPage()));
  }

  final onboardingPagesList = [
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Image(image:
              AssetImage(
                'assets/images/1.jpg',
              ),
                fit: BoxFit.contain,
                width: 600,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 45,right: 45,top: 70,bottom: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LOOKING FOR A FRIEND ?',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Strings.onBoardTitle_sub1,
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Image(image:
              AssetImage(
                'assets/images/2.jpg',
              ),
                fit: BoxFit.contain,
                width: 600,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 45,right: 45,top: 70,bottom: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'MAKE A GAMEFRIEND',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Strings.onBoardTitle_sub2,
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          border: Border.all(
            width: 0.0,
            color: background,
          ),
        ),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Image(image:
              AssetImage(
                'assets/images/3.jpg',
              ),
                fit: BoxFit.contain,
                width: 600,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 45,right: 45,top: 70,bottom: 0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'LEVEL COMPETITIONS',
                    style: pageTitleStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    Strings.onBoardTitle_sub3,
                    style: pageInfoStyle,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 2;
            setIndex(2);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        body: Onboarding(
          pages: onboardingPagesList,
          onPageChange: (int pageIndex) {
            index = pageIndex;
          },
          startPageIndex: 0,
          footerBuilder: (context, dragDistance, pagesLength, setIndex) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: background,
                border: Border.all(
                  width: 0.0,
                  color: background,
                ),
              ),
              child: ColoredBox(
                color: background,
                child: Padding(
                  padding: const EdgeInsets.all(45.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomIndicator(
                        netDragPercent: dragDistance,
                        pagesLength: pagesLength,
                        indicator: Indicator(
                          indicatorDesign: IndicatorDesign.line(
                            lineDesign: LineDesign(
                              lineType: DesignType.line_uniform,
                            ),
                          ),
                        ),
                      ),
                      index == pagesLength - 1
                          ? Material(
                        borderRadius: defaultProceedButtonBorderRadius,
                        color: Colors.deepPurple,
                        child: InkWell(
                          borderRadius: defaultProceedButtonBorderRadius,
                          onTap: () {
                            signup();
                          },
                          child: const Padding(
                            padding: defaultProceedButtonPadding,
                            child: Text(
                              'Sign up',
                              style: defaultProceedButtonTextStyle,
                            ),
                          ),
                        ),
                      )
                          : _skipButton(setIndex: setIndex)
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}