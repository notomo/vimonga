use super::error::RepositoryError;
use crate::domain::model::UserRole;
use bson::Document;

pub trait UserRepository {
    fn get_documents(&self, database_name: &str) -> Result<Vec<Document>, RepositoryError>;
    fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError>;
    fn create(
        &self,
        database_name: &str,
        name: &str,
        password: &str,
        roles: Vec<UserRole>,
    ) -> Result<(), RepositoryError>;
    fn drop(&self, database_name: &str, name: &str) -> Result<(), RepositoryError>;
}
