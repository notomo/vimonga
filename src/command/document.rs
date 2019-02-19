use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

extern crate monga;
use monga::Client;

extern crate serde_json;

extern crate mongad;
use mongad::Info;

use crate::config::Setting;

pub struct DocumentListCommand<'a> {
    pub client: Client,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub index: usize,
    pub query_json: &'a str,
    pub projection_json: &'a str,
    pub limit: i64,
    pub offset: i64,
    pub pid: &'a str,
    pub host: &'a str,
    pub port: u16,
    pub setting: Setting,
}

impl<'a> Command for DocumentListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let collection_name = match self.collection_name {
            "" => {
                let url = format!(
                    "http://{server_host}:{server_port}/ps/{pid}/conns/{host}/{port}/dbs/{db_name}/colls",
                    server_host = &self.setting.server_host,
                    server_port = &self.setting.server_port,
                    pid = &self.pid,
                    host = &self.host,
                    port = &self.port,
                    db_name = &self.database_name,
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
            _ => Ok(String::from(self.collection_name)),
        }?;

        let documents = monga::get_documents(
            &self.client,
            self.database_name,
            collection_name.as_str(),
            self.query_json,
            self.projection_json,
            self.limit,
            self.offset,
        )?;

        let mut view = HashMap::new();
        view.insert("body", serde_json::to_string_pretty(&documents)?);
        view.insert("database_name", self.database_name.to_string());
        view.insert("collection_name", collection_name);

        Ok(serde_json::to_string(&view)?)
    }
}
