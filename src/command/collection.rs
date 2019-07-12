use crate::command::error;
use crate::command::Command;

use crate::domain::repository::CollectionRepository;

pub struct CollectionListCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub database_name: &'a str,
}

impl<'a> Command for CollectionListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let mut names = self.collection_repository.get_names(self.database_name)?;
        names.sort_unstable();

        Ok(names.join("\n"))
    }
}

pub struct CollectionCreateCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub database_name: &'a str,
    pub collection_names: Vec<&'a str>,
}

impl<'a> Command for CollectionCreateCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        for collection_name in &self.collection_names {
            self.collection_repository
                .create(self.database_name, collection_name)?;
        }

        Ok("".to_string())
    }
}

pub struct CollectionDropCommand<'a> {
    pub collection_repository: &'a CollectionRepository,
    pub database_name: &'a str,
    pub collection_names: Vec<&'a str>,
}

impl<'a> Command for CollectionDropCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        for collection_name in &self.collection_names {
            self.collection_repository
                .drop(self.database_name, collection_name)?;
        }

        Ok("".to_string())
    }
}
