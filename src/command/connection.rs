use crate::command::error;
use crate::command::Command;

use std::fs::File;
use std::io::Read;

pub struct ConnectionListCommand<'a> {
    pub config_file_path: &'a str,
}

impl<'a> Command for ConnectionListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let mut file = File::open(self.config_file_path)?;

        let mut content = String::new();
        file.read_to_string(&mut content)?;
        let connection_config: Vec<ConnectionConfig> =
            serde_json::from_str(&content).map_err(|e| e.to_string())?;

        let lines = connection_config
            .iter()
            .map(|conf| conf.host)
            .collect::<Vec<&str>>();
        Ok(lines.join("\n"))
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct ConnectionConfig<'a> {
    host: &'a str,
}
