use crate::domain::repository::RepositoryError;

use mongodb::{Client, ClientOptions, ThreadedClient};

pub struct ConnectionFactory<'a> {
    pub host: &'a str,
    pub port: u16,
}

impl<'a> ConnectionFactory<'a> {
    pub fn new(host: &str, port: u16) -> ConnectionFactory {
        ConnectionFactory {
            host: host,
            port: port,
        }
    }

    pub fn get(&self) -> Result<Client, RepositoryError> {
        let mut options = ClientOptions::new();
        options.server_selection_timeout_ms = 100;
        let client = Client::connect_with_options(self.host, self.port, options)?;
        Ok(client)
    }
}
