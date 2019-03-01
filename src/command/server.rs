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

pub struct ServerPingCommand {
    pub setting: Setting,
}

impl Command for ServerPingCommand {
    fn run(&self) -> Result<String, error::CommandError> {
        let url = format!(
            "http://{server_host}:{server_port}/ping",
            server_host = &self.setting.server_host,
            server_port = &self.setting.server_port,
        );

        let body = reqwest::get(&url)?.text()?;
        Ok(body)
    }
}
