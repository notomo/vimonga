use super::error::RepositoryError;

use bson::Document;

pub trait IndexRepository {
    fn get_names(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<Document>, RepositoryError>;

    fn create(
        &self,
        database_name: &str,
        collection_name: &str,
        keys_json: &str,
    ) -> Result<bool, RepositoryError>;

    fn drop(
        &self,
        database_name: &str,
        collection_name: &str,
        name: &str,
    ) -> Result<bool, RepositoryError>;
}
