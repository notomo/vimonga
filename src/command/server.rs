use crate::command::error;
use crate::command::Command;

extern crate mongad;

pub struct ServerStartCommand {}

impl Command for ServerStartCommand {
    fn run(&self) -> Result<String, error::CommandError> {
        mongad::listen();
        Ok("".to_string())
    }
}
