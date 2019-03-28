use super::error::RepositoryError;
use crate::domain::model::UserRole;
use bson::Document;

pub trait DatabaseRepository {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError>;
    fn get_users(&self, database_name: &str) -> Result<Vec<Document>, RepositoryError>;
    fn create_user(
        &self,
        database_name: &str,
        name: &str,
        password: &str,
        roles: Vec<UserRole>,
    ) -> Result<(), RepositoryError>;
    fn drop(&self, database_name: &str) -> Result<bool, RepositoryError>;
}
