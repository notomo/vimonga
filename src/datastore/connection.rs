use crate::domain::repository::{RepositoryError, RepositoryErrorKind};

use std::time::Duration;

use mongodb::Client;
use mongodb::options::ClientOptions;

pub struct ConnectionFactory<'a> {
    pub host_name: &'a str,
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
            host_name: host_port[0],
            port,
        })
    }

    pub fn get(&self) -> Result<Client, RepositoryError> {
        let mut options = ClientOptions::default();
        options.server_selection_timeout = Some(Duration::from_millis(100));
        options.hosts = vec![self.host_name];
        let client = Client::with_options(self.host_name, self.port, options)?;
        Ok(client)
    }
}
