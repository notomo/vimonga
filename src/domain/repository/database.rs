use super::error::RepositoryError;

pub trait DatabaseRepository {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError>;
    fn drop(&self, database_name: &str) -> Result<(), RepositoryError>;
}
