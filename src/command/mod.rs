pub mod database;
mod error;

pub trait Command {
    fn run(&self) -> Result<String, error::CommandError>;
}
