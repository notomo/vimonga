use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::model::UserRole;
use crate::domain::repository::{BufferRepository, UserRepository};

pub struct UserListCommand<'a> {
    pub user_repository: &'a UserRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
}

impl<'a> Command for UserListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let documents = self.user_repository.get_documents(self.database_name)?;

        let mut view = HashMap::new();
        view.insert("body", serde_json::to_string_pretty(&documents)?);
        view.insert(
            "path",
            self.buffer_repository.get_users_path(self.database_name),
        );

        Ok(serde_json::to_string(&view)?)
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct CreateInfo<'a> {
    #[serde(rename = "user")]
    user_name: &'a str,
    #[serde(rename = "pwd")]
    password: &'a str,
    roles: Vec<UserRole<'a>>,
}

pub struct UserCreateCommand<'a> {
    pub user_repository: &'a UserRepository,
    pub database_name: &'a str,
    pub create_info_json: &'a str,
}

impl<'a> Command for UserCreateCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let info: CreateInfo = serde_json::from_str(self.create_info_json)?;

        self.user_repository.create(
            self.database_name,
            info.user_name,
            info.password,
            info.roles,
        )?;

        let mut view = HashMap::new();
        view.insert("body", "");

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct UserDropCommand<'a> {
    pub user_repository: &'a UserRepository,
    pub database_name: &'a str,
    pub user_name: &'a str,
}

impl<'a> Command for UserDropCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.user_repository
            .drop(self.database_name, self.user_name)?;

        let mut view = HashMap::new();
        view.insert("body", "");

        Ok(serde_json::to_string(&view)?)
    }
}
