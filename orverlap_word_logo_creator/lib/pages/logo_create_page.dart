import 'dart:async';

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'dart:math';
import 'package:intl/intl.dart';

import '../models/Ranking.dart';

const timeLimit = 60;
final Random random = Random();

String _getRondomWord() => nouns[random.nextInt(nouns.length)];

class LogoCreatePage extends StatefulWidget {
  const LogoCreatePage({super.key, required this.title});

  final String title;

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
      (Timer timer) {
        if (_isTimerStart && _timer > 0) {
          _timer--;
          setState(() {});
          // ranking window open
          if (_timer == 0) {
            setState(() => _isTimerStart = false);
            // HTTP POST
            // _postRanking();
            // HTTP GET
            // _getRanking();
            setState(() {
              _ranking.add(
                Score(
                  id: "8",
                  name: _userName,
                  score: _score,
                  playDateTime:
                      DateFormat('yyyy/MM/dd HH:mm:ss').format(DateTime.now()),
                ),
              );
            });

            // sort
            // 上位5位まで表示
            _ranking.sort((a, b) => b.score - a.score);
            rankingWindow(context, _ranking);
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
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: Padding(
              padding: const EdgeInsets.all(30),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("1. Input your name.",
                        style: TextStyle(fontSize: 20)),
                    const Text(" 2. Click Start button and Game Start.",
                        style: TextStyle(fontSize: 20)),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Your Name:',
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            // 非活性
                            enabled: !_isTimerStart,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            maxLength: 32,
                            // text Filed size : width 40
                            onChanged: (String value) {
                              setState(() => _userName = value);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: !_isTimerStart ? _start : null,
                          child: const Text('Start',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("timer: ${_timer.toString()}",
                            style: const TextStyle(fontSize: 48)),
                        const SizedBox(
                          width: 48,
                        ),
                        Text("score: ${_score.toString()}",
                            style: const TextStyle(fontSize: 48)),
                        const SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
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
                            "Word will be displayed here",
                            style: TextStyle(color: Colors.grey, fontSize: 50),
                          ),
                    // Input Text
                    TextField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Answer Here',
                      ),
                      onChanged: (String value) {
                        _inpuText(value);
                      },
                      controller: _editController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                      onPressed: _changeAnswerWord,
                      child: const Text('Change Answer Word',
                          style: TextStyle(fontSize: 20)),
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
                                  onPressed: _restart,
                                  child: const Text('Restart',
                                      style: TextStyle(fontSize: 20)),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: _stop,
                                  child: const Text('Stop',
                                      style: TextStyle(fontSize: 20)),
                                ),
                              ],
                            )),
                      ],
                    )
                  ],
                ),
              ),
            )));
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
}
