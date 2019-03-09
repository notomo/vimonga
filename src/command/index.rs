use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::{BufferRepository, CollectionRepository, IndexRepository};

pub struct IndexListCommand<'a> {
    pub index_repository: &'a IndexRepository,
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
}

impl<'a> Command for IndexListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let indexes = self
            .index_repository
            .get_names(self.database_name, self.collection_name)?;

        let mut view = HashMap::new();
        view.insert("body", serde_json::to_string_pretty(&indexes)?);
        view.insert("database_name", self.database_name.to_string());
        view.insert(
            "path",
            self.buffer_repository
                .get_indexes_path(self.database_name, self.collection_name),
        );
        view.insert("collection_name", self.collection_name.to_string());

        Ok(serde_json::to_string(&view)?)
    }
}
