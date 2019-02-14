use crate::command::error;
use crate::command::Command;

extern crate monga;
use monga::Client;

pub struct CollectionListCommand<'a> {
    pub client: Client,
    pub database_name: &'a str,
}

impl<'a> Command for CollectionListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let names = monga::get_collection_names(&self.client, self.database_name)?;
        Ok(names.join("\n"))
    }
}
