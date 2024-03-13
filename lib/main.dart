import 'package:borrar4/google_play_games.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool logged = false;

  @override
  void initState() {
    checkUser();
    super.initState();
  }

  checkUser() async {
    logged = await GPG().isSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: logged
            ? Text('user is logged in')
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('user is not logged in'),
                  TextButton(
                    onPressed: () async {
                      await GPG().signIn().then((value) {
                        setState(() {
                          logged = value;
                        });
                      });
                    },
                    child: Text('Sign in'),
                  ),
                ],
              ),
      ),
    );
  }
}
