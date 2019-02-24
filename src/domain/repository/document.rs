use super::error::RepositoryError;

extern crate bson;
use bson::Document;

pub trait DocumentRepository {
    fn find(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
        projection_json: &str,
        limit: i64,
        skip: i64,
    ) -> Result<Vec<Document>, RepositoryError>;

    fn get_count(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
    ) -> Result<i64, RepositoryError>;
}
