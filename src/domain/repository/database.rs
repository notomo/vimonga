use super::error::RepositoryError;
use bson::Document;

pub trait DatabaseRepository {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError>;
    fn get_users(&self, database_name: &str) -> Result<Vec<Document>, RepositoryError>;
    fn drop(&self, database_name: &str) -> Result<bool, RepositoryError>;
}
