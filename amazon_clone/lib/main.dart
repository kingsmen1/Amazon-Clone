import 'package:amazon_clone/common/widgets/bottomBar.dart';
import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/features/admin/screens/adminScreen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/auth/services/auth_services.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:amazon_clone/router.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future getUser;
  final AuthService authService = AuthService();

  @override
  void initState() {
    getUser = authService.getUserData(context);
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Amazon Clone',
        theme: ThemeData(
          scaffoldBackgroundColor: GlobalVariables.backgroundColor,
          colorScheme: const ColorScheme.light(
              //primary effect's on examples appbar and buttons colors.
              primary: GlobalVariables.secondaryColor),
          appBarTheme: const AppBarTheme(
              elevation: 0.0, iconTheme: IconThemeData(color: Colors.black)),
          // useMaterial3: true,
        ),

        //~onGenerateRoute: responsible for route generation.
        onGenerateRoute: ((settings) => generateRoute(settings)),
        home:

            // Provider.of<UserProvider>(context).user.token.isNotEmpty
            // ? const BottomBar()
            // : const AuthScreen());

            Builder(builder: (context) {
          return FutureBuilder(
            future: getUser,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Provider.of<UserProvider>(context).user.token.isNotEmpty
                    ? Provider.of<UserProvider>(context).user.type == 'user'
                        ? const BottomBar()
                        : AdminScreen()
                    : const AuthScreen();
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(body: loadingCircle);
              } else if (snapshot.hasError) {
                return const Scaffold(
                  body: Center(child: Text('Something Went Wrong')),
                );
              } else {
                return const Scaffold(
                  body: Center(child: Text('Something Went Wrong')),
                );
              }
            },
          );
        }));
  }
}
