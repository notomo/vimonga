use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::{CollectionRepository, DatabaseRepository};

pub struct CollectionListCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub database_repository: &'a DatabaseRepository,
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
        view.insert("database_name", database_name);

        Ok(serde_json::to_string(&view)?)
    }
}
