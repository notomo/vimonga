const exampleDb = new Mongo().getDB("example");

exampleDb.dropDatabase();

exampleDb.persons.insert({ name: "a" });
exampleDb.persons.insert({ name: "b" });
exampleDb.persons.insert({ name: "c" });

exampleDb.teams.insert({ name: "A" });
exampleDb.teams.insert({ name: "B" });
