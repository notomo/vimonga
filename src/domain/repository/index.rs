use super::error::RepositoryError;

use bson::Document;

pub trait IndexRepository {
    fn get_names(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<Document>, RepositoryError>;
}
