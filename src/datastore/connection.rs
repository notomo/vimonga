use crate::domain::RepositoryError;

use mongodb::{Client, ThreadedClient};

pub struct ConnectionFactory<'a> {
    pub host: &'a str,
    pub port: u16,
    client: Option<&'a Client>,
}

impl<'a> ConnectionFactory<'a> {
    pub fn new(host: &str, port: u16) -> ConnectionFactory {
        ConnectionFactory {
            host: host,
            port: port,
            client: None,
        }
    }

    pub fn get(&self) -> Result<Client, RepositoryError> {
        match self.client {
            Some(client) => Ok(client.clone()),
            None => {
                let client = Client::connect(self.host, self.port)?;
                Ok(client)
            }
        }
    }
}
