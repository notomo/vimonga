use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::repository::{BufferRepository, CollectionRepository};

pub struct CollectionListCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
}

impl<'a> Command for CollectionListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let names = self.collection_repository.get_names(self.database_name)?;

        let mut view = HashMap::new();
        view.insert("body", names.join("\n"));
        view.insert(
            "path",
            self.buffer_repository
                .get_collections_path(self.database_name),
        );
        view.insert("database_name", self.database_name.to_string());

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct CollectionCreateCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
}

impl<'a> Command for CollectionCreateCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.collection_repository
            .create(self.database_name, self.collection_name)?;

        let mut view = HashMap::new();
        view.insert("body", "");
        view.insert("database_name", self.database_name);
        view.insert("collection_name", self.collection_name);

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct CollectionDropCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
}

impl<'a> Command for CollectionDropCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.collection_repository
            .drop(self.database_name, self.collection_name)?;

        let mut view = HashMap::new();
        view.insert("body", "");
        view.insert("database_name", self.database_name);
        view.insert("collection_name", self.collection_name);

        Ok(serde_json::to_string(&view)?)
    }
}
