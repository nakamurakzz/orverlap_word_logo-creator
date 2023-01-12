const app = require("./app");

const port = 3000;

const main = async () => {

  // サーバ起動
  app.listen(port, () => console.log("app running!!"));
};
main();