use crate::domain::{DatabaseRepository, RepositoryError};

use std::collections::HashMap;

use crate::config::Setting;

extern crate mongodb;
use mongodb::Client;
use mongodb::ThreadedClient;

pub struct DatabaseRepositoryImpl<'a> {
    pub client: Client,
    pub pid: &'a str,
    pub host: &'a str,
    pub port: u16,
    pub setting: Setting,
}

impl<'a> DatabaseRepository for DatabaseRepositoryImpl<'a> {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError> {
        let names = self.client.database_names()?;

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

        Ok(names)
    }
}
