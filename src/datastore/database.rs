use crate::domain::{DatabaseRepository, RepositoryError, RepositoryErrorKind};

use std::collections::HashMap;

use crate::config::Setting;

use super::connection::ConnectionFactory;

use mongodb::ThreadedClient;

use mongad::Info;

pub struct DatabaseRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
    pub pid: &'a str,
    pub host: &'a str,
    pub port: u16,
    pub setting: &'a Setting,
}

impl<'a> DatabaseRepositoryImpl<'a> {
    fn url(&self) -> String {
        format!(
            "http://{server_host}:{server_port}/ps/{pid}/conns/{host}/{port}/dbs",
            server_host = &self.setting.server_host,
            server_port = &self.setting.server_port,
            pid = &self.pid,
            host = &self.host,
            port = &self.port,
        )
    }
}

impl<'a> DatabaseRepository for DatabaseRepositoryImpl<'a> {
    fn get_names(&self) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let names = client.database_names()?;

        let mut value = HashMap::new();
        value.insert("body", &names);

        let reqwest_client = reqwest::Client::new();
        let url = self.url();
        reqwest_client.post(&url).json(&value).send().unwrap();

        Ok(names)
    }

    fn get_name_by_number(&self, number: usize) -> Result<String, RepositoryError> {
        let reqwest_client = reqwest::Client::new();
        let url = self.url();
        let name = reqwest_client
            .get(&url)
            .send()?
            .json::<Info>()?
            .body
            .get(number)
            .ok_or(RepositoryErrorKind::OutOfIndex)
            .map(|name| String::from(name.as_str()).clone())?;
        Ok(name)
    }
}
