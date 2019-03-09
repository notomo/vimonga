use crate::domain::{IndexRepository, RepositoryError};

use super::connection::ConnectionFactory;

use crate::config::Setting;

use bson::Document;

use mongodb::db::ThreadedDatabase;
use mongodb::ThreadedClient;

pub struct IndexRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
    pub host: &'a str,
    pub port: u16,
    pub setting: &'a Setting,
}

impl<'a> IndexRepository for IndexRepositoryImpl<'a> {
    fn get_names(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<Document>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let cursor = client
            .db(database_name)
            .collection(collection_name)
            .list_indexes()?;

        let documents: Vec<Document> = cursor.map(|index| index.unwrap()).collect();
        Ok(documents)
    }
}
