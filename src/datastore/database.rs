use crate::domain::model::UserRole;
use crate::domain::repository::{DatabaseRepository, RepositoryError};

use super::connection::ConnectionFactory;

use bson::Document;

use mongodb::db::options::CreateUserOptions;
use mongodb::db::roles::{Role, SingleDatabaseRole};
use mongodb::db::ThreadedDatabase;
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

    fn get_users(&self, database_name: &str) -> Result<Vec<Document>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let documents = client.db(database_name).get_all_users(false)?;

        Ok(documents)
    }

    fn create_user(
        &self,
        database_name: &str,
        name: &str,
        password: &str,
        roles: Vec<UserRole>,
    ) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        let mut create_option = CreateUserOptions::new();
        create_option.roles = roles
            .iter()
            .map(|role| {
                let single_db_role = match role.role_name().as_str() {
                    "read" => SingleDatabaseRole::Read,
                    "readWrite" => SingleDatabaseRole::ReadWrite,
                    "dbAdmin" => SingleDatabaseRole::DbAdmin,
                    "dbOwner" => SingleDatabaseRole::DbOwner,
                    "userAdmin" => SingleDatabaseRole::UserAdmin,
                    "clusterAdmin" => SingleDatabaseRole::ClusterAdmin,
                    "clusterManager" => SingleDatabaseRole::ClusterManager,
                    "clusterMonitor" => SingleDatabaseRole::ClusterMonitor,
                    "hostManager" => SingleDatabaseRole::HostManager,
                    "backup" => SingleDatabaseRole::Backup,
                    "restore" => SingleDatabaseRole::Restore,
                    _ => SingleDatabaseRole::Read,
                };
                Role::Single {
                    role: single_db_role,
                    db: role.database_name(),
                }
            })
            .collect();

        let documents =
            client
                .db(database_name)
                .create_user(name, password, Some(create_option))?;

        Ok(documents)
    }

    fn drop(&self, database_name: &str) -> Result<bool, RepositoryError> {
        let client = self.connection_factory.get()?;
        client.drop_database(database_name)?;
        Ok(true)
    }
}
