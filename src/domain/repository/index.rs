use super::error::RepositoryError;

use bson::Document;

pub trait IndexRepository {
    fn get_documents(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<Document>, RepositoryError>;

    fn get_names(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<String>, RepositoryError>;

    fn create(
        &self,
        database_name: &str,
        collection_name: &str,
        keys_json: &str,
    ) -> Result<(), RepositoryError>;

    fn drop(
        &self,
        database_name: &str,
        collection_name: &str,
        name: &str,
    ) -> Result<(), RepositoryError>;
}
