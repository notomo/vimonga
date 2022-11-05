use super::error::RepositoryError;
use async_trait::async_trait;

#[async_trait]
pub trait DatabaseRepository {
    async fn get_names(&self) -> Result<Vec<String>, RepositoryError>;
    async fn drop(&self, database_name: &str) -> Result<(), RepositoryError>;
}
