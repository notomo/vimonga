use super::error::RepositoryError;

pub trait CollectionRepository {
    fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError>;
    fn get_name_by_number(
        &self,
        database_name: &str,
        number: usize,
    ) -> Result<String, RepositoryError>;
}
