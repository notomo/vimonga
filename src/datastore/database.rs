use crate::domain::repository::{DatabaseRepository, RepositoryError};

use super::connection::ConnectionFactory;
use async_trait::async_trait;

pub struct DatabaseRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
}

#[async_trait]
impl<'a> DatabaseRepository for DatabaseRepositoryImpl<'a> {
    async fn get_names(&self) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let names = client.list_database_names(None, None).await?;
        Ok(names)
    }

    async fn drop(&self, database_name: &str) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        client.database(database_name).drop(None).await?;
        Ok(())
    }
}
