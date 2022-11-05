use super::error::RepositoryError;

use async_trait::async_trait;
use bson::Document;

#[async_trait]
pub trait IndexRepository {
    async fn get_documents(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<Document>, RepositoryError>;

    async fn get_names(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<String>, RepositoryError>;

    async fn create(
        &self,
        database_name: &str,
        collection_name: &str,
        keys_json: &str,
    ) -> Result<(), RepositoryError>;

    async fn drop(
        &self,
        database_name: &str,
        collection_name: &str,
        name: &str,
    ) -> Result<(), RepositoryError>;
}
