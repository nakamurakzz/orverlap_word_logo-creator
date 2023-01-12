var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function (req, res, next) {
  console.log("GET /scores");
  return res.json(ranking.sort((a, b) => b.score - a.score).slice(0, req.query.limit || 10));
});

router.post('/', function (req, res, next) {
  console.log("POST /scores");
  ranking.push({ id: (ranking.length + 1).toString(), ...req.body });
  console.log({ ranking });
  return res.json(ranking);
});


const ranking = [
  {
    id: "1",
    name: "John",
    score: 4,
    playDateTime: "2020-01-01 12:00:00"
  },
  {
    id: "2",
    name: "Jane",
    score: 30,
    playDateTime: "2020-01-01 12:00:00"
  },
  {
    id: "3",
    name: "Jack",
    score: 20,
    playDateTime: "2020-01-01 12:00:00"
  },
  {
    id: "4",
    name: "John",
    score: 4,
    playDateTime: "2020-01-01 12:00:00"
  },
  {
    id: "5",
    name: "John",
    score: 3454,
    playDateTime: "2020-01-01 12:00:00"
  },
  {
    id: "6",
    name: "John",
    score: 32,
    playDateTime: "2020-01-01 12:00:00"
  },
];

module.exports = router;
