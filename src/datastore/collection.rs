use crate::domain::repository::{CollectionRepository, Item, RepositoryError};

use super::connection::ConnectionFactory;
use async_trait::async_trait;

pub struct CollectionRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
}

#[async_trait]
impl<'a> CollectionRepository for CollectionRepositoryImpl<'a> {
    async fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let names = client
            .database(database_name)
            .list_collection_names(None)
            .await?;

        Ok(names)
    }

    async fn create(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        client
            .database(database_name)
            .create_collection(collection_name, None)
            .await?;
        Ok(())
    }

    async fn drop(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        client
            .database(database_name)
            .collection::<Item>(collection_name)
            .drop(None)
            .await?;
        Ok(())
    }
}
