use crate::domain::RepositoryError;

use mongodb::{Client, ThreadedClient};

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
        let client = Client::connect(self.host, self.port)?;
        Ok(client)
    }
}
