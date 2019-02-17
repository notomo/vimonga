use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

extern crate monga;
use monga::Client;

extern crate mongad;
use mongad::Info;

extern crate serde_json;

pub struct CollectionListCommand<'a> {
    pub client: Client,
    pub database_name: &'a str,
    pub index: usize,
    pub pid: &'a str,
    pub host: &'a str,
    pub port: u16,
}

impl<'a> Command for CollectionListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let database_name = match self.database_name {
            "" => {
                let url = format!(
                    "http://localhost:8000/ps/{pid}/conns/{host}/{port}/dbs",
                    pid = &self.pid,
                    host = &self.host,
                    port = &self.port,
                );

                let reqwest_client = reqwest::Client::new();
                reqwest_client
                    .get(&url)
                    .send()?
                    .json::<Info>()?
                    .body
                    .get(self.index)
                    .ok_or(error::CommandError::OutOfIndex)
                    .map(|name| String::from(name.as_str()).clone())
            }
            _ => Ok(String::from(self.database_name)),
        }?;

        let names = monga::get_collection_names(&self.client, database_name.as_str())?;

        let url = format!(
            "http://localhost:8000/ps/{pid}/conns/{host}/{port}/dbs/{db_name}/colls",
            pid = &self.pid,
            host = &self.host,
            port = &self.port,
            db_name = database_name,
        );

        let mut value = HashMap::new();
        value.insert("body", &names);

        let reqwest_client = reqwest::Client::new();
        reqwest_client.post(&url).json(&value).send().unwrap();

        let mut view = HashMap::new();
        view.insert("body", names.join("\n"));
        view.insert("database_name", database_name);

        Ok(serde_json::to_string(&view)?)
    }
}
