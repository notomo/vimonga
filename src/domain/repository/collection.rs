use super::error::RepositoryError;
use async_trait::async_trait;

#[async_trait]
pub trait CollectionRepository {
    async fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError>;
    async fn create(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<(), RepositoryError>;
    async fn drop(&self, database_name: &str, collection_name: &str)
        -> Result<(), RepositoryError>;
}

pub struct Item {
    id: u32,
}
