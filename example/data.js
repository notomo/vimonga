let exampleDb = new Mongo().getDB("example");

exampleDb.dropDatabase();

for (let i = 0; i < 25; ++i) {
  exampleDb.persons.insert({ name: i });
}

exampleDb.teams.insert({
  name: "A",
  option: { max: 10, min: 2 },
  createdAt: new Date()
});
exampleDb.teams.insert({
  name: "B",
  option: { max: 15, min: 5 },
  createdAt: new Date()
});
exampleDb.teams.insert({
  name: "C",
  option: { max: 9, min: 6 },
  createdAt: new Date()
});
