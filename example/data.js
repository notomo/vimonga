let exampleDb = new Mongo().getDB("example");

exampleDb.dropDatabase();

for (let i = 0; i < 25; ++i) {
  exampleDb.persons.insert({ name: i });
}

exampleDb.teams.insert({ name: "A" });
exampleDb.teams.insert({ name: "B" });
