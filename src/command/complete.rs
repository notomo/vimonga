use crate::command::error;
use crate::command::Command;

use crate::domain::repository::{CollectionRepository, DatabaseRepository};

pub struct CompleteVimongaCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
    pub collection_repository: &'a CollectionRepository,
    pub current_arg: &'a str,
    pub args: Vec<&'a str>,
}

impl<'a> Command for CompleteVimongaCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let actions: Vec<_> = self
            .args
            .iter()
            .filter(|arg| !arg.starts_with("-"))
            .collect();

        let keys: Vec<_> = self
            .args
            .iter()
            .filter(|arg| arg.starts_with("-"))
            .map(|arg| arg.split("=").collect::<Vec<&str>>()[0])
            .collect();

        let candidates = if actions.len() != 0
            && (self.current_arg == "" || self.current_arg.starts_with("-"))
            && !self.current_arg.contains("=")
        {
            self.param_keys(actions[0])
        } else if keys.len() != 0
            && self.current_arg.starts_with("-")
            && self.current_arg.contains("=")
        {
            self.param_values(keys[0])?
        } else {
            self.action_names()
        };

        Ok(candidates.join("\n"))
    }
}

impl<'a> CompleteVimongaCommand<'a> {
    fn action_names(&self) -> Vec<String> {
        vec![
            "database.list",
            "database.drop",
            "collection.list",
            "collection.drop",
            "collection.create",
            "user.list",
            "index.list",
        ]
        .iter()
        .map(|action| action.to_string())
        .collect()
    }

    fn param_keys(&self, action: &str) -> Vec<String> {
        match action {
            "database.drop" | "collection.list" | "collection.create" | "user.list" => vec!["-db="],
            "collection.drop" | "index.list" => vec!["-db=", "-coll="],
            _ => vec![],
        }
        .iter()
        .map(|action| action.to_string())
        .collect()
    }

    fn param_values(&self, key: &str) -> Result<Vec<String>, error::CommandError> {
        let values = match key {
            "-db" => self.database_repository.get_names()?,
            _ => vec![],
        }
        .iter()
        .map(|action| format!("{}={}", key, action))
        .collect();

        Ok(values)
    }
}
