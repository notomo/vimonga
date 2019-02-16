use crate::command::error;
use crate::command::Command;

pub struct HelpCommand {}

impl Command for HelpCommand {
    fn run(&self) -> Result<String, error::CommandError> {
        Ok("".to_string())
    }
}
