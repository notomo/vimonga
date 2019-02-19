use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

extern crate monga;
use monga::Client;

use crate::config::Setting;

pub struct DatabaseListCommand<'a> {
    pub client: Client,
    pub pid: &'a str,
    pub host: &'a str,
    pub port: u16,
    pub setting: Setting,
}

impl<'a> Command for DatabaseListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let names = monga::get_database_names(&self.client)?;

        let url = format!(
            "http://{server_host}:{server_port}/ps/{pid}/conns/{host}/{port}/dbs",
            server_host = &self.setting.server_host,
            server_port = &self.setting.server_port,
            pid = &self.pid,
            host = &self.host,
            port = &self.port,
        );

        let mut value = HashMap::new();
        value.insert("body", &names);

        let reqwest_client = reqwest::Client::new();
        reqwest_client.post(&url).json(&value).send().unwrap();

        Ok(names.join("\n"))
    }
}
