use crate::domain::repository::{RepositoryError, RepositoryErrorKind};

use mongodb::{Client, ClientOptions, ThreadedClient};

pub struct ConnectionFactory<'a> {
    pub host: &'a str,
    pub port: u16,
}

impl<'a> ConnectionFactory<'a> {
    pub fn new(host: &str) -> Result<ConnectionFactory, RepositoryError> {
        let host_port = host.split(":").collect::<Vec<&str>>();

        let port = host_port
            .get(1)
            .ok_or(RepositoryErrorKind::ParseError {
                message: "host must include `:{port}`".to_string(),
            })?
            .parse()?;

        Ok(ConnectionFactory {
            host: host_port[0],
            port: port,
        })
    }

    pub fn get(&self) -> Result<Client, RepositoryError> {
        let mut options = ClientOptions::new();
        options.server_selection_timeout_ms = 100;
        let client = Client::connect_with_options(self.host, self.port, options)?;
        Ok(client)
    }
}
