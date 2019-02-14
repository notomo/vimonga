use crate::command::error;
use crate::command::Command;

extern crate monga;
use monga::Client;

pub struct DocumentListCommand<'a> {
    pub client: Client,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub query_json: &'a str,
    pub projection_json: &'a str,
}

impl<'a> Command for DocumentListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let documents = monga::get_documents(
            &self.client,
            self.database_name,
            self.collection_name,
            self.query_json,
            self.projection_json,
        )
        .ok()
        .expect("Failed to get documents");

        Ok(serde_json::to_string_pretty(&documents).unwrap())
    }
}
