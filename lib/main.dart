import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_reader/pages/home_page.dart';
import 'package:qr_reader/pages/map_page.dart';
import 'package:qr_reader/providers/scan_list_provider.dart';
import 'package:qr_reader/providers/ui_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_ ) => UiProvider(), lazy: false,),
        ChangeNotifierProvider(create: (_ ) => ScanListProvider(), lazy: false,)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QR Reader',
        initialRoute: 'home',
        routes: {'home': (_) => const HomePage(), 'map': (_) => const MapPage()},
        theme: ThemeData(
            bottomNavigationBarTheme:
                const BottomNavigationBarThemeData(selectedItemColor: Colors.teal, selectedIconTheme: IconThemeData(color: Colors.teal)),
            appBarTheme: const AppBarTheme(backgroundColor: Colors.teal),
            primaryColor: Colors.teal,
            floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Colors.teal)),
      ),
    );
  }
}
