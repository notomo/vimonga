mod collection;
pub use collection::CollectionListCommand;

mod database;
pub use database::DatabaseListCommand;

mod document;
pub use document::DocumentListCommand;

mod help;
pub use help::HelpCommand;

mod server;
pub use server::ServerStartCommand;

mod error;

pub trait Command {
    fn run(&self) -> Result<String, error::CommandError>;
}
