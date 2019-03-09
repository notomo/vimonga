use crate::domain::{CollectionRepository, RepositoryError};

use super::connection::ConnectionFactory;

use std::collections::HashMap;

use crate::config::Setting;

use mongodb::db::ThreadedDatabase;
use mongodb::ThreadedClient;

pub struct CollectionRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
    pub host: &'a str,
    pub port: u16,
    pub setting: &'a Setting,
}

impl<'a> CollectionRepository for CollectionRepositoryImpl<'a> {
    fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let names = client.db(database_name).collection_names(None)?;

        let mut value = HashMap::new();
        value.insert("body", &names);

        Ok(names)
    }

    fn drop(&self, database_name: &str, collection_name: &str) -> Result<bool, RepositoryError> {
        let client = self.connection_factory.get()?;
        client
            .db(database_name)
            .collection(collection_name)
            .drop()?;
        Ok(true)
    }
}
