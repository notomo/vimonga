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
            self.param_keys(actions[0], keys)
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
            "user.list",
            "user.new",
            "user.create",
            "collection.list",
            "collection.create",
            "collection.drop",
            "index.list",
            "index.new",
            "index.create",
            "document.find",
            "document.page.next",
            "document.page.first",
            "document.page.prev",
            "document.page.last",
            "document.sort.ascending",
            "document.sort.descending",
            "document.sort.toggle",
            "document.sort.reset",
            "document.sort.reset_all",
            "document.projection.hide",
            "document.projection.reset_all",
            "document.query.add",
            "document.query.reset_all",
            "document.one",
            "document.one.insert",
            "document.one.delete",
            "document.one.update",
            "document.new",
        ]
        .iter()
        .map(|action| action.to_string())
        .collect()
    }

    fn param_keys(&self, action: &str, keys: Vec<&str>) -> Vec<String> {
        match action {
            "database.drop" | "collection.list" | "collection.create" | "user.list" => vec!["-db"],
            "collection.drop" | "index.list" => vec!["-db", "-coll"],
            _ => vec![],
        }
        .iter()
        .filter(|action| !keys.contains(action))
        .map(|action| format!("{}=", action))
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

#[cfg(test)]
mod tests {

    use super::*;
    use crate::domain::repository::RepositoryError;

    struct DatabaseRepositoryMock<'a> {
        pub names: Vec<&'a str>,
    }

    impl<'a> DatabaseRepository for DatabaseRepositoryMock<'a> {
        fn get_names(&self) -> Result<Vec<String>, RepositoryError> {
            Ok(self.names.iter().map(|x| x.to_string()).collect())
        }
        fn drop(&self, _database_name: &str) -> Result<bool, RepositoryError> {
            Ok(true)
        }
    }

    struct CollectionRepositoryMock;

    impl CollectionRepository for CollectionRepositoryMock {
        fn get_names(&self, _database_name: &str) -> Result<Vec<String>, RepositoryError> {
            Ok(vec!["".to_string()])
        }
        fn create(
            &self,
            _database_name: &str,
            _collection_name: &str,
        ) -> Result<bool, RepositoryError> {
            Ok(true)
        }
        fn drop(
            &self,
            _database_name: &str,
            _collection_name: &str,
        ) -> Result<bool, RepositoryError> {
            Ok(true)
        }
    }

    #[test]
    fn param_keys() {
        let db_repo = DatabaseRepositoryMock { names: vec![""] };
        let coll_repo = CollectionRepositoryMock {};
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            current_arg: "",
            args: vec!["collection.list"],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("-db=".to_string(), result.unwrap());
    }

    #[test]
    fn action_names() {
        let db_repo = DatabaseRepositoryMock { names: vec![""] };
        let coll_repo = CollectionRepositoryMock {};
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            current_arg: "",
            args: vec![],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!(true, result.unwrap().starts_with("database.list"));
    }

    #[test]
    fn param_values() {
        let db_repo = DatabaseRepositoryMock {
            names: vec!["example", "local"],
        };
        let coll_repo = CollectionRepositoryMock {};
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            current_arg: "-db=",
            args: vec!["collection.list", "-db="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("-db=example\n-db=local".to_string(), result.unwrap());
    }
}
