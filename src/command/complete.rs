use crate::command::error;
use crate::command::Command;

use crate::domain::repository::{
    CollectionRepository, DatabaseRepository, IndexRepository, UserRepository,
};

pub struct CompleteVimongaCommand<'a> {
    pub database_repository: &'a DatabaseRepository,
    pub collection_repository: &'a CollectionRepository,
    pub user_repository: &'a UserRepository,
    pub index_repository: &'a IndexRepository,
    pub current_arg: &'a str,
    pub args: Vec<&'a str>,
}

const DB: &str = "db";
const COLL: &str = "coll";
const USER: &str = "user";
const INDEX: &str = "index";
const DOC_ID: &str = "id";
const OPEN: &str = "open";

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
            .filter(|arg| arg.starts_with("-") && arg.contains("="))
            .map(|arg| {
                arg.split("=").collect::<Vec<&str>>()[0]
                    .chars()
                    .into_iter()
                    .skip(1)
                    .collect::<String>()
            })
            .collect();

        let database_name = self
            .args
            .iter()
            .filter(|arg| arg.starts_with("-db=") && arg.contains("="))
            .map(|arg| arg.split("=").collect::<Vec<&str>>()[1])
            .last();

        let collection_name = self
            .args
            .iter()
            .filter(|arg| arg.starts_with("-coll=") && arg.contains("="))
            .map(|arg| arg.split("=").collect::<Vec<&str>>()[1])
            .last();

        let candidates = if actions.len() != 0
            && (self.current_arg == "" || self.current_arg.starts_with("-"))
            && !self.current_arg.contains("=")
        {
            self.param_keys(actions[0], keys)
        } else if keys.len() != 0
            && self.current_arg.starts_with("-")
            && self.current_arg.contains("=")
        {
            self.param_values(&keys.last().unwrap(), database_name, collection_name)?
        } else {
            self.action_names()
        };

        Ok(candidates.join("\n"))
    }
}

impl<'a> CompleteVimongaCommand<'a> {
    fn action_names(&self) -> Vec<String> {
        vec![
            "connection.list",
            "database.list",
            "database.drop",
            "user.list",
            "user.new",
            "user.create",
            "user.drop",
            "collection.list",
            "collection.create",
            "collection.drop",
            "index.list",
            "index.new",
            "index.create",
            "index.drop",
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
            "document.query.find_by_oid",
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

    fn param_keys(&self, action: &str, keys: Vec<String>) -> Vec<String> {
        match action {
            "database.drop" | "collection.list" | "collection.create" | "user.list"
            | "user.new" => vec![DB, OPEN],
            "collection.drop" | "index.list" | "index.new" | "document.new" => vec![DB, COLL, OPEN],
            "user.drop" => vec![DB, USER, OPEN],
            "index.drop" => vec![DB, COLL, INDEX, OPEN],
            "document.one" | "document.one.delete" => vec![DB, COLL, DOC_ID, OPEN],
            _ => vec![OPEN],
        }
        .iter()
        .filter(|key| !keys.contains(&key.to_string()))
        .map(|key| format!("-{}=", key))
        .collect()
    }

    fn param_values(
        &self,
        key: &String,
        database_name: Option<&str>,
        collection_name: Option<&str>,
    ) -> Result<Vec<String>, error::CommandError> {
        let values = match key.as_str() {
            DB => self.database_repository.get_names()?,
            COLL => self.get_collection_names(database_name)?,
            USER => self.get_user_names(database_name)?,
            INDEX => self.get_index_names(database_name, collection_name)?,
            OPEN => self.get_open_commands()?,
            _ => vec![],
        }
        .iter()
        .map(|value| format!("-{}={}", key, value))
        .collect();

        Ok(values)
    }

    fn get_collection_names(
        &self,
        database_name: Option<&str>,
    ) -> Result<Vec<String>, error::CommandError> {
        let names = match database_name {
            Some(database_name) => self.collection_repository.get_names(database_name)?,
            None => vec![],
        };

        Ok(names)
    }

    fn get_user_names(
        &self,
        database_name: Option<&str>,
    ) -> Result<Vec<String>, error::CommandError> {
        let names = match database_name {
            Some(database_name) => self.user_repository.get_names(database_name)?,
            None => vec![],
        };

        Ok(names)
    }

    fn get_index_names(
        &self,
        database_name: Option<&str>,
        collection_name: Option<&str>,
    ) -> Result<Vec<String>, error::CommandError> {
        let names = match (database_name, collection_name) {
            (Some(database_name), Some(collection_name)) => self
                .index_repository
                .get_names(database_name, collection_name)?,
            _ => vec![],
        };

        Ok(names)
    }

    fn get_open_commands(&self) -> Result<Vec<String>, error::CommandError> {
        let names = vec!["nosplit", "horizontal", "vertical", "tab"]
            .iter()
            .map(|value| value.to_string())
            .collect();

        Ok(names)
    }
}

#[cfg(test)]
mod tests {

    use super::*;
    use crate::domain::model::UserRole;
    use crate::domain::repository::RepositoryError;
    use bson::Document;

    struct DatabaseRepositoryMock<'a> {
        pub names: Vec<&'a str>,
    }

    impl<'a> DatabaseRepository for DatabaseRepositoryMock<'a> {
        fn get_names(&self) -> Result<Vec<String>, RepositoryError> {
            Ok(self.names.iter().map(|x| x.to_string()).collect())
        }
        fn drop(&self, _database_name: &str) -> Result<(), RepositoryError> {
            Ok(())
        }
    }

    struct CollectionRepositoryMock<'a> {
        pub names: Vec<&'a str>,
    }

    impl<'a> CollectionRepository for CollectionRepositoryMock<'a> {
        fn get_names(&self, _database_name: &str) -> Result<Vec<String>, RepositoryError> {
            Ok(self.names.iter().map(|x| x.to_string()).collect())
        }
        fn create(
            &self,
            _database_name: &str,
            _collection_name: &str,
        ) -> Result<(), RepositoryError> {
            Ok(())
        }
        fn drop(
            &self,
            _database_name: &str,
            _collection_name: &str,
        ) -> Result<(), RepositoryError> {
            Ok(())
        }
    }

    struct UserRepositoryMock<'a> {
        pub names: Vec<&'a str>,
    }

    impl<'a> UserRepository for UserRepositoryMock<'a> {
        fn get_documents(&self, _database_name: &str) -> Result<Vec<Document>, RepositoryError> {
            Ok(vec![])
        }
        fn get_names(&self, _database_name: &str) -> Result<Vec<String>, RepositoryError> {
            Ok(self.names.iter().map(|x| x.to_string()).collect())
        }
        fn create(
            &self,
            _database_name: &str,
            _name: &str,
            _password: &str,
            _roles: Vec<UserRole>,
        ) -> Result<(), RepositoryError> {
            Ok(())
        }
        fn drop(&self, _database_name: &str, _name: &str) -> Result<(), RepositoryError> {
            Ok(())
        }
    }

    struct IndexRepositoryMock<'a> {
        pub names: Vec<&'a str>,
    }

    impl<'a> IndexRepository for IndexRepositoryMock<'a> {
        fn get_documents(
            &self,
            _database_name: &str,
            _collection_name: &str,
        ) -> Result<Vec<Document>, RepositoryError> {
            Ok(vec![])
        }
        fn get_names(
            &self,
            _database_name: &str,
            _collection_name: &str,
        ) -> Result<Vec<String>, RepositoryError> {
            Ok(self.names.iter().map(|x| x.to_string()).collect())
        }
        fn create(
            &self,
            _database_name: &str,
            _collection_name: &str,
            _keys_json: &str,
        ) -> Result<(), RepositoryError> {
            Ok(())
        }
        fn drop(
            &self,
            _database_name: &str,
            _collection_name: &str,
            _name: &str,
        ) -> Result<(), RepositoryError> {
            Ok(())
        }
    }

    #[test]
    fn param_keys() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock { names: vec![] };
        let user_repo = UserRepositoryMock { names: vec![] };
        let index_repo = IndexRepositoryMock { names: vec![] };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "",
            args: vec!["collection.list"],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("-db=\n-open=".to_string(), result.unwrap());
    }

    #[test]
    fn action_names() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock { names: vec![] };
        let user_repo = UserRepositoryMock { names: vec![] };
        let index_repo = IndexRepositoryMock { names: vec![] };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "",
            args: vec![],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!(true, result.unwrap().starts_with("connection.list"));
    }

    #[test]
    fn db_names() {
        let db_repo = DatabaseRepositoryMock {
            names: vec!["example", "local"],
        };
        let coll_repo = CollectionRepositoryMock { names: vec![] };
        let user_repo = UserRepositoryMock { names: vec![] };
        let index_repo = IndexRepositoryMock { names: vec![] };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "-db=",
            args: vec!["collection.list", "-db="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("-db=example\n-db=local".to_string(), result.unwrap());
    }

    #[test]
    fn collection_names() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock {
            names: vec!["teams", "skills"],
        };
        let user_repo = UserRepositoryMock { names: vec![] };
        let index_repo = IndexRepositoryMock { names: vec![] };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "-coll=",
            args: vec!["collection.list", "-db=example", "-coll="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("-coll=teams\n-coll=skills".to_string(), result.unwrap());
    }

    #[test]
    fn collection_names_without_db() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock {
            names: vec!["teams", "skills"],
        };
        let user_repo = UserRepositoryMock { names: vec![] };
        let index_repo = IndexRepositoryMock { names: vec![] };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "-coll=",
            args: vec!["collection.list", "-coll="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("".to_string(), result.unwrap());
    }

    #[test]
    fn user_names() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock { names: vec![] };
        let user_repo = UserRepositoryMock {
            names: vec!["read-only", "read-write"],
        };
        let index_repo = IndexRepositoryMock { names: vec![] };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "-user=",
            args: vec!["collection.list", "-db=example", "-user="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!(
            "-user=read-only\n-user=read-write".to_string(),
            result.unwrap()
        );
    }

    #[test]
    fn user_names_without_db() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock { names: vec![] };
        let user_repo = UserRepositoryMock {
            names: vec!["read-only", "read-write"],
        };
        let index_repo = IndexRepositoryMock { names: vec![] };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "-user=",
            args: vec!["collection.list", "-user="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("".to_string(), result.unwrap());
    }

    #[test]
    fn index_names() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock { names: vec![] };
        let user_repo = UserRepositoryMock { names: vec![] };
        let index_repo = IndexRepositoryMock {
            names: vec!["name", "role"],
        };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "-index=",
            args: vec!["index.drop", "-db=example", "-coll=tests", "-index="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("-index=name\n-index=role".to_string(), result.unwrap());
    }

    #[test]
    fn index_names_without_db() {
        let db_repo = DatabaseRepositoryMock { names: vec![] };
        let coll_repo = CollectionRepositoryMock { names: vec![] };
        let user_repo = UserRepositoryMock { names: vec![] };
        let index_repo = IndexRepositoryMock {
            names: vec!["name", "role"],
        };
        let command = CompleteVimongaCommand {
            database_repository: &db_repo,
            collection_repository: &coll_repo,
            user_repository: &user_repo,
            index_repository: &index_repo,
            current_arg: "-index=",
            args: vec!["index.drop", "-coll=tests", "-index="],
        };

        let result = command.run();

        assert_eq!(true, result.is_ok());
        assert_eq!("".to_string(), result.unwrap());
    }
}
