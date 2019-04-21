let exampleDb = new Mongo().getDB("example");

exampleDb.dropAllUsers();
exampleDb.dropDatabase();
exampleDb.createCollection("tests1");
exampleDb.createCollection("tests2");
exampleDb.createCollection("empty");
exampleDb.createCollection("dropped");

exampleDb.tests1.insert({
  _id: ObjectId("5ca3f45b1edab35868df1e0e"),
  name: "hoge"
});

exampleDb.tests1.insert({
  _id: ObjectId("6ca3f45b1edab35868df1e0e"),
  name: "foo"
});

let dropped = new Mongo().getDB("dropped");
dropped.dropAllUsers();
dropped.dropDatabase();
dropped.createCollection("dropped");
