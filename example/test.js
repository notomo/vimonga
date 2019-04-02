let exampleDb = new Mongo().getDB("example");

exampleDb.dropAllUsers();
exampleDb.dropDatabase();
exampleDb.createCollection("tests1");
exampleDb.createCollection("tests2");
exampleDb.createCollection("empty");
