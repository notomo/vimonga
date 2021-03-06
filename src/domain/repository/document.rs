use super::error::RepositoryError;

use bson::{Bson, Document};

pub trait DocumentRepository {
    fn find(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
        projection_json: &str,
        sort_json: &str,
        limit: i64,
        skip: i64,
    ) -> Result<Vec<Document>, RepositoryError>;

    fn find_by_id(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<Document, RepositoryError>;

    fn get_count(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
    ) -> Result<i64, RepositoryError>;

    fn update_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
        update_document: &str,
    ) -> Result<(), RepositoryError>;

    fn insert_one(
        &self,
        database_name: &str,
        collection_name: &str,
        insert_document: &str,
    ) -> Result<Option<Bson>, RepositoryError>;

    fn delete_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<(), RepositoryError>;
}
