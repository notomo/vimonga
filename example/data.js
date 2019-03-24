let exampleDb = new Mongo().getDB("example");

exampleDb.dropDatabase();

for (let i = 0; i < 25; ++i) {
  exampleDb.persons.insert({ name: i });
}

exampleDb.teams.insert({
  name: "A",
  option: { max: 10, min: 2 },
  skills: [1, 2, 3],
  createdAt: new Date()
});
exampleDb.teams.insert({
  name: "B",
  option: { max: 15, min: 5 },
  skills: [2, 3, 4],
  createdAt: new Date()
});
exampleDb.teams.insert({
  name: "C",
  option: { max: 9, min: 6 },
  skills: [3, 4, 5],
  createdAt: new Date()
});
exampleDb.teams.insert({
  name: "D",
  option: { max: 9, min: 6 },
  skills: [1, 2, 3],
  createdAt: new Date()
});

const testUser1 = exampleDb.getUser("test-user1");
if (testUser1 == undefined) {
  exampleDb.createUser({
    user: "test-user1",
    pwd: "test",
    roles: [{ role: "readWrite", db: "example" }]
  });
}

const readUser = exampleDb.getUser("read-user");
if (readUser == undefined) {
  exampleDb.createUser({
    user: "read-user",
    pwd: "test",
    roles: [{ role: "read", db: "example" }]
  });
}

const names = new Mongo().getDBNames().filter(name => name.startsWith("test"));
names.forEach(name => {
  const testDb = new Mongo().getDB(name);
  testDb.dropDatabase();
});

for (let i = 0; i < 50; ++i) {
  let testDb = new Mongo().getDB("test" + i);
  testDb.tests.insert({});
}
