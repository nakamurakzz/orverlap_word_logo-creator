import 'package:intl/intl.dart';

class Score {
  final String id;
  final String name;
  final int score;
  final String playDateTime;

  Score(
      {required this.id,
      required this.name,
      required this.score,
      required this.playDateTime});

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
        id: json['id'],
        name: json['name'],
        score: json['score'],
        // YYYY/MM/DD HH:MM:SS
        playDateTime: DateFormat('yyyy/MM/dd HH:mm:ss').format(
          DateTime.parse(json['playDateTime']),
        ));
  }
}

List<Score> testRanking = [
  Score(id: "1", name: "taro", score: 60, playDateTime: "2023/01/01 00:00:00"),
  Score(id: "2", name: "jiro", score: 50, playDateTime: "2023/01/01 00:00:00"),
  Score(
      id: "3", name: "saburo", score: 40, playDateTime: "2023/01/01 00:00:00"),
  Score(id: "4", name: "shiro", score: 30, playDateTime: "2023/01/01 00:00:00"),
  Score(id: "5", name: "goro", score: 20, playDateTime: "2023/01/01 00:00:00"),
  Score(
      id: "6", name: "rokuro", score: 10, playDateTime: "2023/01/01 00:00:00"),
  Score(id: "7", name: "nanashi", score: 0, playDateTime: "2023/01/01 00:00:00")
];
