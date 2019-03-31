use crate::command::error;
use crate::command::Command;

use crate::domain::repository::IndexRepository;

pub struct IndexListCommand<'a> {
    pub index_repository: &'a IndexRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
}

impl<'a> Command for IndexListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let indexes = self
            .index_repository
            .get_names(self.database_name, self.collection_name)?;

        Ok(serde_json::to_string_pretty(&indexes)?)
    }
}

pub struct IndexCreateCommand<'a> {
    pub index_repository: &'a IndexRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub keys_json: &'a str,
}

impl<'a> Command for IndexCreateCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.index_repository
            .create(self.database_name, self.collection_name, self.keys_json)?;

        Ok("".to_string())
    }
}

pub struct IndexDropCommand<'a> {
    pub index_repository: &'a IndexRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub index_name: &'a str,
}

impl<'a> Command for IndexDropCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.index_repository
            .drop(self.database_name, self.collection_name, self.index_name)?;

        Ok("".to_string())
    }
}
