pub mod collection;
pub mod database;
pub mod document;

mod error;

pub trait Command {
    fn run(&self) -> Result<String, error::CommandError>;
}
