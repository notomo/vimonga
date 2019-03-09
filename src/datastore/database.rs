use crate::domain::{DatabaseRepository, RepositoryError};

use std::collections::HashMap;

use crate::config::Setting;

use super::connection::ConnectionFactory;

use mongodb::ThreadedClient;

pub struct DatabaseRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
    pub host: &'a str,
    pub port: u16,
    pub setting: &'a Setting,
}

impl<'a> DatabaseRepository for DatabaseRepositoryImpl<'a> {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let names = client.database_names()?;

        let mut value = HashMap::new();
        value.insert("body", &names);

        Ok(names)
    }

    fn drop(&self, database_name: &str) -> Result<bool, RepositoryError> {
        let client = self.connection_factory.get()?;
        client.drop_database(database_name)?;
        Ok(true)
    }
}
