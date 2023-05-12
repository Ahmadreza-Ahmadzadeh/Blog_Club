import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_2/atricle.dart';
import 'package:project_2/gen/fonts.gen.dart';
import 'package:project_2/home.dart';
import 'package:project_2/profile.dart';
import 'package:project_2/splash.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = const Color(0xff0D253C);
    final secondaryTextColor = const Color(0xff2D4379);
    final primaryColor = const Color(0xff376AED);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'project 2',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStateProperty.all(
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: FontFamily.avenir,
              ),
            ),
          ),
        ),
        colorScheme: ColorScheme.light(
            primary: primaryColor,
            onPrimary: Colors.white,
            background: const Color(0xffFBFCFF),
            surface: Colors.white,
            onSurface: primaryTextColor,
            onBackground: primaryTextColor),
        appBarTheme: AppBarTheme(
          titleSpacing: 32,
          backgroundColor: Colors.white,
          foregroundColor: primaryTextColor,
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: primaryTextColor,
        ),
        textTheme: TextTheme(
          headline4: TextStyle(
              fontFamily: FontFamily.avenir,
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: primaryTextColor),
          headline5: TextStyle(
              fontFamily: FontFamily.avenir,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryTextColor),
          headline6: TextStyle(
              fontFamily: FontFamily.avenir,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: primaryTextColor),
          bodyText1: TextStyle(
              fontFamily: FontFamily.avenir,
              color: primaryTextColor,
              fontSize: 14),
          bodyText2: TextStyle(
              fontFamily: FontFamily.avenir,
              color: secondaryTextColor,
              fontSize: 12),
          subtitle1: TextStyle(
              fontFamily: FontFamily.avenir,
              fontWeight: FontWeight.w200,
              color: secondaryTextColor,
              fontSize: 18),
          subtitle2: TextStyle(
              fontFamily: FontFamily.avenir,
              fontWeight: FontWeight.w400,
              color: primaryTextColor,
              fontSize: 14),
          caption: const TextStyle(
              fontFamily: FontFamily.avenir,
              fontWeight: FontWeight.w700,
              color: Color(0xff7B8BB2),
              fontSize: 10),
        ),
      ),
      home: SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

const int homeIndex = 0;
const int articleIndex = 1;
const int searchIndex = 2;
const int menuIndedx = 3;
const double bottomNavigationHeight = 65;

class _MainScreenState extends State<MainScreen> {
  int selectedScreenIndex = homeIndex;
  final List<int> _history = [];
  GlobalKey<NavigatorState> _homekey = GlobalKey();
  GlobalKey<NavigatorState> _articlekey = GlobalKey();
  GlobalKey<NavigatorState> _searchkey = GlobalKey();
  GlobalKey<NavigatorState> _menukey = GlobalKey();
  late final map = {
    homeIndex: _homekey,
    articleIndex: _articlekey,
    searchIndex: _searchkey,
    menuIndedx: _menukey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentSelectedTabNavigatorState =
        map[selectedScreenIndex]!.currentState!;
    if (currentSelectedTabNavigatorState.canPop()) {
      currentSelectedTabNavigatorState.pop();
      return false;
    } else if (_history.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _history.last;
        _history.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              bottom: bottomNavigationHeight,
              child: IndexedStack(
                index: selectedScreenIndex,
                children: [
                  _navigator(_homekey, homeIndex, HomeScreen()),
                  _navigator(_articlekey, articleIndex, ArticleScreen()),
                  _navigator(
                      _searchkey,
                      searchIndex,
                      SimpleScreen(
                        tabName: 'Search',
                      )),
                  _navigator(_menukey, menuIndedx, ProfileScreen()),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: _BottomNavigation(
                selectedIndex: selectedScreenIndex,
                onTap: (int index) {
                  setState(
                    () {
                      _history.remove(selectedScreenIndex);
                      _history.add(selectedScreenIndex);
                      selectedScreenIndex = index;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navigator(GlobalKey key, int index, Widget child) {
    return key.currentState == null && selectedScreenIndex != index
        ? Container()
        : Navigator(
            key: key,
            onGenerateRoute: ((settings) => MaterialPageRoute(
                  builder: (context) => Offstage(
                      offstage: selectedScreenIndex != index, child: child),
                )),
          );
  }
}

class SimpleScreen extends StatelessWidget {
  const SimpleScreen({super.key, required this.tabName, this.screenNumber = 1});
  final String tabName;
  final int screenNumber;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Tab: $tabName , Screen #$screenNumber',
          style: Theme.of(context).textTheme.headline4,
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => SimpleScreen(
                      tabName: tabName,
                      screenNumber: screenNumber + 1,
                    )),
              ),
            );
          },
          child: Text(
            'Click Me',
          ),
        )
      ],
    ));
  }
}

class _BottomNavigation extends StatelessWidget {
  final Function(int index) onTap;
  final int selectedIndex;
  const _BottomNavigation(
      {super.key, required this.onTap, required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85,
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              height: bottomNavigationHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: const Color(0xff9B8487).withOpacity(0.3),
                  ),
                ],
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    BootomNavigationItem(
                      iconFileName: 'Home.png',
                      activeIconFileName: 'HomeActive.png',
                      title: 'Home',
                      onTap: () {
                        onTap(homeIndex);
                      },
                      isActive: selectedIndex == homeIndex,
                    ),
                    BootomNavigationItem(
                      iconFileName: 'Articles.png',
                      activeIconFileName: 'ArticlesActive.png',
                      title: 'Article',
                      onTap: () {
                        onTap(articleIndex);
                      },
                      isActive: selectedIndex == articleIndex,
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    BootomNavigationItem(
                      iconFileName: 'Search.png',
                      activeIconFileName: 'SearchActive.png',
                      title: 'Search',
                      onTap: () {
                        onTap(searchIndex);
                      },
                      isActive: selectedIndex == searchIndex,
                    ),
                    BootomNavigationItem(
                        iconFileName: 'Menu.png',
                        activeIconFileName: 'MenuActive.png',
                        title: 'Menu',
                        onTap: () {
                          onTap(menuIndedx);
                        },
                        isActive: selectedIndex == menuIndedx)
                  ]),
            ),
          ),
          Center(
            child: Container(
              width: 65,
              height: 85,
              color: Colors.transparent,
              alignment: Alignment.topCenter,
              child: Container(
                height: bottomNavigationHeight,
                decoration: BoxDecoration(
                  color: const Color(0xff376AED),
                  borderRadius: BorderRadius.circular(32.5),
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Image.asset('assets/img/icons/plus.png'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class BootomNavigationItem extends StatelessWidget {
  final String iconFileName;
  final String activeIconFileName;
  final String title;
  final Function() onTap;
  final bool isActive;

  const BootomNavigationItem(
      {super.key,
      required this.iconFileName,
      required this.activeIconFileName,
      required this.title,
      required this.onTap,
      required this.isActive});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/icons/${isActive ? activeIconFileName : iconFileName}',
              width: 24,
              height: 24,
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              title,
              style: themeData.textTheme.caption!.apply(
                  color: isActive
                      ? themeData.colorScheme.primary
                      : themeData.textTheme.caption!.color),
            )
          ],
        ),
      ),
    );
  }
}
