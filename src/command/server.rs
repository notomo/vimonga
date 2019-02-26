use crate::command::error;
use crate::command::Command;

use crate::config::Setting;

pub struct ServerStartCommand {
    pub setting: Setting,
}

impl Command for ServerStartCommand {
    fn run(&self) -> Result<String, error::CommandError> {
        mongad::listen(&self.setting.server_host, self.setting.server_port);
        Ok("".to_string())
    }
}
