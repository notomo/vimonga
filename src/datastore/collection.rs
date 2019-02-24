use crate::domain::{CollectionRepository, RepositoryError};

use std::collections::HashMap;

use crate::config::Setting;

extern crate mongodb;
use mongodb::db::ThreadedDatabase;
use mongodb::Client;
use mongodb::ThreadedClient;

pub struct CollectionRepositoryImpl<'a> {
    pub client: &'a Client,
    pub pid: &'a str,
    pub host: &'a str,
    pub port: u16,
    pub setting: &'a Setting,
}

impl<'a> CollectionRepository for CollectionRepositoryImpl<'a> {
    fn get_names(&self, database_name: &str) -> Result<Vec<String>, RepositoryError> {
        let names = self.client.db(database_name).collection_names(None)?;

        let url = format!(
            "http://{server_host}:{server_port}/ps/{pid}/conns/{host}/{port}/dbs/{db_name}/colls",
            server_host = &self.setting.server_host,
            server_port = &self.setting.server_port,
            pid = &self.pid,
            host = &self.host,
            port = &self.port,
            db_name = database_name,
        );

        let mut value = HashMap::new();
        value.insert("body", &names);

        let reqwest_client = reqwest::Client::new();
        reqwest_client.post(&url).json(&value).send().unwrap();

        Ok(names)
    }
}
