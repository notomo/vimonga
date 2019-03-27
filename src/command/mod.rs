mod complete;
pub use complete::CompleteVimongaCommand;

mod collection;
pub use collection::{CollectionCreateCommand, CollectionDropCommand, CollectionListCommand};

mod database;
pub use database::{DatabaseDropCommand, DatabaseListCommand};

mod index;
pub use index::{IndexCreateCommand, IndexListCommand};

mod user;
pub use user::UserListCommand;

mod document;
pub use document::{
    DocumentDeleteCommand, DocumentGetCommand, DocumentInsertCommand, DocumentListCommand,
    DocumentUpdateCommand,
};

mod help;
pub use help::HelpCommand;

mod error;

pub trait Command {
    fn run(&self) -> Result<String, error::CommandError>;
}
