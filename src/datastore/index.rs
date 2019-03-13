use crate::domain::repository::{IndexRepository, RepositoryError};

use super::connection::ConnectionFactory;

use bson::Document;

use mongodb::db::ThreadedDatabase;
use mongodb::ThreadedClient;

pub struct IndexRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
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
