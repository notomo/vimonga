use crate::command::error;
use crate::command::Command;

use crate::domain::repository::DatabaseRepository;

pub struct DatabaseListCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
}

impl<'a> Command for DatabaseListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let mut names = self.database_repository.get_names()?;
        names.sort_unstable();

        Ok(names.join("\n"))
    }
}

pub struct DatabaseDropCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
    pub database_name: &'a str,
}

impl<'a> Command for DatabaseDropCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.database_repository.drop(self.database_name)?;

        Ok("".to_string())
    }
}
