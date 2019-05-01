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

exampleDb.tests1.insert({
  _id: ObjectId("7ca3f45b1edab35868df1e0e"),
  name: "bar"
});

let dropped = new Mongo().getDB("dropped");
dropped.dropAllUsers();
dropped.dropDatabase();
dropped.createCollection("dropped");

let otherDb = new Mongo().getDB("other");
otherDb.dropAllUsers();
otherDb.dropDatabase();
otherDb.createCollection("other");
otherDb.other.createIndex({ dropped_index: 1 });
