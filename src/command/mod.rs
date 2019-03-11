mod collection;
pub use collection::{CollectionDropCommand, CollectionListCommand};

mod database;
pub use database::{DatabaseDropCommand, DatabaseListCommand};

mod index;
pub use index::IndexListCommand;

mod document;
pub use document::{DocumentGetCommand, DocumentListCommand};

mod help;
pub use help::HelpCommand;

mod error;

pub trait Command {
    fn run(&self) -> Result<String, error::CommandError>;
}
