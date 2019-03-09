use super::error::RepositoryError;

pub trait CollectionRepository {
    fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError>;
    fn drop(&self, database_name: &str, collection_name: &str) -> Result<bool, RepositoryError>;
}
