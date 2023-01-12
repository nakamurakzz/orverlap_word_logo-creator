import 'dart:async';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import '../models/Ranking.dart';
import 'package:dio/dio.dart';

const timeLimit = 10;
final Random random = Random();

String _getRondomWord() => nouns[random.nextInt(nouns.length)];

class LogoCreatePageArgs {
  final String name;

  LogoCreatePageArgs({required this.name});
}

class LogoCreatePage extends StatefulWidget {
  const LogoCreatePage({super.key});

  @override
  State<LogoCreatePage> createState() => _LogoCreatePageState();
}

class _LogoCreatePageState extends State<LogoCreatePage> {
  final _editController = TextEditingController();

  String _userName = "";
  String _inputAnswer = "";
  String _answer = "";
  int _score = 0;
  int _timer = timeLimit;
  bool _isTimerStart = false;

  // TODO APIから取得する
  List<Score> _ranking = testRanking;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        if (_isTimerStart && _timer > 0) {
          _timer--;
          setState(() {});
          // ranking window open
          if (_timer == 0) {
            setState(() => _isTimerStart = false);
            // HTTP POST
            await _postScore();

            // HTTP GET
            final ranking = await _fetchScore();

            print("ranking: $ranking");

            // sort
            // 上位5位まで表示
            ranking.sort((a, b) => b.score - a.score);
            rankingWindow(context, ranking);
            _resetScore();
            _resetTimer();
          }
        }
      },
    );
  }

  void _start() {
    setState(() => _isTimerStart = true);
    setState(() => _answer = _getRondomWord());
  }

  void _inpuText(String value) {
    setState(() {
      _inputAnswer = value;
    });
    if (_answer == value) {
      setState(() => _score += _answer.length);
      setState(() => _answer = _getRondomWord());
      setState(() => _inputAnswer = "");
      _editController.clear();
    }
  }

  void _changeAnswerWord() {
    _minusScore();
    setState(() => _inputAnswer = "");
    _editController.clear();
    setState(() => _answer = _getRondomWord());
  }

  void _minusScore() => setState(() => _score > 0 ? _score -= 1 : _score = 0);

  void _restart() {
    _resetScore();
    setState(() => _answer = _getRondomWord());
    setState(() => _inputAnswer = "");
    _resetTimer();
    _editController.clear();
  }

  void _stop() {
    setState(() => _isTimerStart = false);
    _resetTimer();
    _resetScore();
  }

  void _resetTimer() => setState(() => _timer = timeLimit);
  void _resetScore() => setState(() => _score = 0);

  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context)!.settings.arguments as String;
    setState(() => _userName = name);

    return MaterialApp(
        theme: ThemeData(fontFamily: 'NotoSansJP'),
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Orverlap Word'),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'UserName: $_userName',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Time Limit: ${_timer.toString()}",
                            style: const TextStyle(fontSize: 48)),
                        const SizedBox(
                          width: 48,
                        ),
                        Text("Score: ${_score.toString()}",
                            style: const TextStyle(fontSize: 48)),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    ElevatedButton(
                      onPressed: !_isTimerStart ? _start : null,
                      child:
                          const Text('START', style: TextStyle(fontSize: 40)),
                    ),
                    const SizedBox(
                      height: 64,
                    ),
                    _isTimerStart
                        ? Text(
                            _answer,
                            // 文字と文字の間隔を狭める
                            style: const TextStyle(
                              letterSpacing: -10,
                              fontSize: 50,
                            ),
                          )
                        : const Text(
                            "The word will be displayed here",
                            style: TextStyle(color: Colors.grey, fontSize: 50),
                          ),
                    const SizedBox(
                      height: 16,
                    ),
                    // Input Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 400,
                          child: TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Answer',
                            ),
                            onChanged: (String value) {
                              _inpuText(value);
                            },
                            controller: _editController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: _isTimerStart ? _changeAnswerWord : null,
                      child: const Text('Pass!(-1)',
                          style: TextStyle(fontSize: 32)),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _isTimerStart ? _restart : null,
                                  child: const Text('Restart',
                                      style: TextStyle(fontSize: 20)),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _isTimerStart ? _stop : null,
                                  child: const Text('STOP',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ))));
  }

  Future rankingWindow(BuildContext context, List<Score> ranking) => showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ranking'),
            content: SingleChildScrollView(
              child: ListBody(
                children: ranking
                    .map((Score score) => Text(
                        "${score.name} : ${score.score}   ${score.playDateTime}"))
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

  // APIからデータを取得する
  Future<List<Score>> _fetchScore() async {
    try {
      final response =
          await Dio().get('http://localhost:3000/scores', queryParameters: {
        "limit": 5,
      });
      final scores = response.data as List;
      return scores.map((score) => Score.fromJson(score)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  // POST
  Future<void> _postScore() async {
    try {
      final response = await Dio().post('http://localhost:3000/scores', data: {
        "name": _userName,
        "score": _score,
        "playDateTime": DateTime.now().toIso8601String()
      });
      print(response);
      return;
    } catch (e) {
      print(e);
    }
  }
}
