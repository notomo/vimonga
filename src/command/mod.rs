mod collection;
pub use collection::{CollectionDropCommand, CollectionListCommand};

mod database;
pub use database::DatabaseListCommand;

mod index;
pub use index::IndexListCommand;

mod document;
pub use document::DocumentListCommand;

mod help;
pub use help::HelpCommand;

mod server;
pub use server::{ServerPingCommand, ServerStartCommand};

mod error;

pub trait Command {
    fn run(&self) -> Result<String, error::CommandError>;
}
