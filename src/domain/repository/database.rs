use super::error::RepositoryError;

pub trait DatabaseRepository {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError>;
    fn get_name_by_number(&self, number: usize) -> Result<String, RepositoryError>;
}
