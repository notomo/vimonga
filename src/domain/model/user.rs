#[derive(Serialize, Deserialize, Debug)]
pub struct UserRole<'a> {
    #[serde(rename = "db")]
    database_name: &'a str,
    #[serde(rename = "role")]
    role_name: &'a str,
}

impl<'a> UserRole<'a> {
    pub fn database_name(&self) -> String {
        self.database_name.to_string()
    }

    pub fn role_name(&self) -> String {
        self.role_name.to_string()
    }
}
