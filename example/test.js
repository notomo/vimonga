let exampleDb = new Mongo().getDB("example");

exampleDb.dropAllUsers();
exampleDb.dropDatabase();
exampleDb.createCollection("tests1");
exampleDb.createCollection("tests2");
exampleDb.createCollection("empty");

exampleDb.tests1.insert({
  _id: ObjectId("5ca3f45b1edab35868df1e0e"),
  name: "hoge"
});
