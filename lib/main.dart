import 'package:ecoeden_redux/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:ecoeden_redux/app_routes.dart';
import 'package:ecoeden_redux/localization.dart';
import 'package:ecoeden_redux/redux/app_state.dart';
import 'package:ecoeden_redux/redux/navigation_middleware.dart';
import 'package:ecoeden_redux/redux/reducers/app_reducer.dart';
import 'package:ecoeden_redux/route_aware_widget.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());



final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  
  final store = Store<AppState>(
      appReducer,
      initialState: AppState.loading(),
      middleware: createMiddleware(),
      );

  //   final theme = ThemeData(
  //     primaryColor: Colors.grey.shade900,
  //     primaryColorLight: Colors.grey.shade800,
  //     primaryColorDark: Colors.black,
  //     scaffoldBackgroundColor: Colors.grey.shade800,
  // //          textTheme: TextTheme(
  // //            body1: TextStyle(color: Colors.white),
  // //            display1: TextStyle(color: Colors.white),
  // //            title: TextStyle(color: Colors.white),
  // //          ),
  //     iconTheme: IconThemeData(color: Colors.white),
  //     accentColor: Colors.yellow[500],
  // );



 // define  all the routes here 
  MaterialPageRoute _getRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MainRoute(RegisterPage(), settings: settings);
      // case AppRoutes.addGame:
      //   return FabRoute(NewGame(), settings: settings);
      default:
        return MainRoute(RegisterPage(), settings: settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: store,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        title: AppLocalizations.appTitle,
        // theme: theme,
        onGenerateRoute: (RouteSettings settings) => _getRoute(settings),
      ),
    );
  }

}


class MainRoute<T> extends MaterialPageRoute<T> {
  MainRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => RouteAwareWidget(child: widget),
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    // return FadeTransition(opacity: animation, child: child);
    return child;
  }
}


// from bottom to top animations use this route for 
//in-page widget transitions 

class FabRoute<T> extends MaterialPageRoute<T> {
  FabRoute(Widget widget, {RouteSettings settings})
      : super(
            builder: (_) => RouteAwareWidget(child: widget),
            settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // if (settings.isInitialRoute) return child;
    return SlideTransition(
        position: new Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child);
  }

}