use super::error::RepositoryError;

pub trait DatabaseRepository {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError>;
}
