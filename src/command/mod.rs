mod collection;
pub use collection::{CollectionCreateCommand, CollectionDropCommand, CollectionListCommand};

mod database;
pub use database::{DatabaseDropCommand, DatabaseListCommand, DatabaseUserListCommand};

mod index;
pub use index::IndexListCommand;

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
