const express = require('express');
const path = require('path');
const logger = require('morgan');

const scoresRouter = require('./routes/scores');

const app = express();

app.use(logger('dev'));
app.use(express.json());
// cors
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});
app.use('/scores', scoresRouter);

module.exports = app;
