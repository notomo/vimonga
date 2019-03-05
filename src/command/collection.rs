use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::{BufferRepository, CollectionRepository, DatabaseRepository};

pub struct CollectionListCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub database_repository: &'a DatabaseRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub number: usize,
}

impl<'a> Command for CollectionListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let database_name = match self.database_name {
            "" => self.database_repository.get_name_by_number(self.number),
            _ => Ok(String::from(self.database_name)),
        }?;

        let names = self
            .collection_repository
            .get_names(database_name.as_str())?;

        let mut view = HashMap::new();
        view.insert("body", names.join("\n"));
        view.insert(
            "path",
            self.buffer_repository
                .get_collections_path(database_name.as_str()),
        );
        view.insert("database_name", database_name);

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct CollectionDropCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub database_repository: &'a DatabaseRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub number: usize,
}

impl<'a> Command for CollectionDropCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let collection_name = match self.collection_name {
            "" => self
                .collection_repository
                .get_name_by_number(self.database_name, self.number),
            _ => Ok(String::from(self.collection_name)),
        }?;

        self.collection_repository
            .drop(self.database_name, collection_name.as_str())?;

        let mut view = HashMap::new();
        view.insert("body", "");
        view.insert("database_name", self.database_name);
        view.insert("collection_name", collection_name.as_str());

        Ok(serde_json::to_string(&view)?)
    }
}
