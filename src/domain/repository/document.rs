use super::error::RepositoryError;

use async_trait::async_trait;
use bson::{Bson, Document};

#[async_trait]
pub trait DocumentRepository {
    async fn find(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
        projection_json: &str,
        sort_json: &str,
        limit: i64,
        skip: u64,
    ) -> Result<Vec<Document>, RepositoryError>;

    async fn find_by_id(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<Document, RepositoryError>;

    async fn get_count(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
    ) -> Result<u64, RepositoryError>;

    async fn update_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
        update_document: &str,
    ) -> Result<(), RepositoryError>;

    async fn insert_one(
        &self,
        database_name: &str,
        collection_name: &str,
        insert_document: &str,
    ) -> Result<Bson, RepositoryError>;

    async fn delete_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<(), RepositoryError>;
}
