let exampleDb = new Mongo().getDB("example");

exampleDb.dropAllUsers();
exampleDb.dropDatabase();
exampleDb.createCollection("tests1");
exampleDb.createCollection("tests2");
exampleDb.createCollection("empty");
exampleDb.createCollection("dropped");
exampleDb.createCollection("dropped2");

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

for (let i = 0; i < 50; ++i) {
  exampleDb.tests2.insert({ num: i });
}

let dropped = new Mongo().getDB("dropped");
dropped.dropAllUsers();
dropped.dropDatabase();
dropped.createCollection("dropped");

let dropped2 = new Mongo().getDB("dropped2");
dropped2.dropAllUsers();
dropped2.dropDatabase();
dropped2.createCollection("dropped2");

let otherDb = new Mongo().getDB("other");
otherDb.dropAllUsers();
otherDb.dropDatabase();
otherDb.createCollection("other");
otherDb.other.createIndex({ dropped_index: 1 });
otherDb.createUser({
  user: "dropped_user",
  pwd: "password",
  roles: [{ role: "read", db: "other" }]
});
