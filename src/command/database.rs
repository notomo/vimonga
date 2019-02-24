use crate::command::error;
use crate::command::Command;

use crate::domain::DatabaseRepository;

pub struct DatabaseListCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
}

impl<'a> Command for DatabaseListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let names = self.database_repository.get_names()?;

        Ok(names.join("\n"))
    }
}
