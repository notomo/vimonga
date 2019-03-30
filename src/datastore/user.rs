use crate::domain::model::UserRole;
use crate::domain::repository::{RepositoryError, UserRepository};

use super::connection::ConnectionFactory;

use bson::Document;

use mongodb::db::options::CreateUserOptions;
use mongodb::db::roles::{Role, SingleDatabaseRole};
use mongodb::db::ThreadedDatabase;
use mongodb::ThreadedClient;

pub struct UserRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
}

impl<'a> UserRepository for UserRepositoryImpl<'a> {
    fn get_documents(&self, database_name: &str) -> Result<Vec<Document>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let documents = client.db(database_name).get_all_users(false)?;

        Ok(documents)
    }

    fn create(
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

        client
            .db(database_name)
            .create_user(name, password, Some(create_option))?;

        Ok(())
    }

    fn drop(&self, database_name: &str, name: &str) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        client.db(database_name).drop_user(name, None)?;

        Ok(())
    }
}
