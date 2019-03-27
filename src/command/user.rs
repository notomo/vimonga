use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::repository::{BufferRepository, DatabaseRepository};

pub struct UserListCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
}

impl<'a> Command for UserListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let documents = self.database_repository.get_users(self.database_name)?;

        let mut view = HashMap::new();
        view.insert("body", serde_json::to_string_pretty(&documents)?);
        view.insert(
            "path",
            self.buffer_repository.get_users_path(self.database_name),
        );

        Ok(serde_json::to_string(&view)?)
    }
}
