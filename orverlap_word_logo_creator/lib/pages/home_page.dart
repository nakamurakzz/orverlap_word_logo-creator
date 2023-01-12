import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:orverlap_word_logo_creator/models/ranking.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _name = '';
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Orverlap Word',
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
                child: Center(
                  child: Column(
                    children: [
                      const Text(
                        // English
                        // "表示された英単語を時間内にたくさん当てる遊び"
                        'Try to guess as many English words as possible within the time limit',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 400,
                        child: Lottie.network(
                          'https://assets8.lottiefiles.com/packages/lf20_rbpv9urtg6.json',
                          errorBuilder: (context, error, stackTrace) {
                            return const Padding(
                              padding: EdgeInsets.all(30.0),
                              child: Text('Loading...'),
                            );
                          },
                          onLoaded: (composition) {
                            const Text('Loading...');
                          },
                        ),
                      ),
                      SizedBox(
                        width: 400,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person),
                            hintText: 'Your Name',
                          ),
                          maxLength: 32,
                          onChanged: (String value) {
                            setState(() {
                              _name = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          if (_name == '') {
                            // ポップアップを表示
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('ERROR'),
                                  content: const Text('Input Your Name'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }
                          Navigator.pushNamed(context, '/logo',
                              arguments: _name);
                        },
                        child: const Text('Go!!'),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
