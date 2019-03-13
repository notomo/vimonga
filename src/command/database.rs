use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::repository::{BufferRepository, DatabaseRepository};

pub struct DatabaseListCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
    pub buffer_repository: &'a BufferRepository,
}

impl<'a> Command for DatabaseListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let names = self.database_repository.get_names()?;

        let mut view = HashMap::new();
        view.insert("body", names.join("\n"));
        view.insert("path", self.buffer_repository.get_dbs_path());

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct DatabaseDropCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
    pub database_name: &'a str,
}

impl<'a> Command for DatabaseDropCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.database_repository.drop(self.database_name)?;

        let mut view = HashMap::new();
        view.insert("body", "");
        view.insert("database_name", self.database_name);

        Ok(serde_json::to_string(&view)?)
    }
}
