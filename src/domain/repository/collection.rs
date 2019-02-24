use super::error::RepositoryError;

pub trait CollectionRepository {
    fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError>;
}
