use crate::domain::repository::{DatabaseRepository, RepositoryError};

use super::connection::ConnectionFactory;

use mongodb::ThreadedClient;

pub struct DatabaseRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
}

impl<'a> DatabaseRepository for DatabaseRepositoryImpl<'a> {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let names = client.database_names()?;

        Ok(names)
    }

    fn drop(&self, database_name: &str) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        client.drop_database(database_name)?;
        Ok(())
    }
}
