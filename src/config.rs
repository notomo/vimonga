use config::{Config, ConfigError, File};

#[derive(Debug, Deserialize)]
pub struct Setting {
    pub server_port: u16,
    pub server_host: String,
}

impl Setting {
    pub fn new(config_path: &str) -> Result<Self, ConfigError> {
        let mut s = Config::new();

        s.set_default("server_port", 8000)?;
        s.set_default("server_host", String::from("localhost"))?;
        s.merge(File::with_name(config_path).required(false))?;

        s.try_into()
    }
}
