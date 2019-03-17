use crate::domain::repository::{CollectionRepository, RepositoryError};

use super::connection::ConnectionFactory;

use mongodb::db::ThreadedDatabase;
use mongodb::ThreadedClient;

pub struct CollectionRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
}

impl<'a> CollectionRepository for CollectionRepositoryImpl<'a> {
    fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let names = client.db(database_name).collection_names(None)?;

        Ok(names)
    }

    fn create(&self, database_name: &str, collection_name: &str) -> Result<bool, RepositoryError> {
        let client = self.connection_factory.get()?;
        client
            .db(database_name)
            .create_collection(collection_name, None)?;
        Ok(true)
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
