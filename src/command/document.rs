use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use crate::domain::{CollectionRepository, DocumentRepository};

extern crate serde_json;

pub struct DocumentListCommand<'a> {
    pub document_repository: &'a DocumentRepository,
    pub collection_repository: &'a CollectionRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub number: usize,
    pub query_json: &'a str,
    pub projection_json: &'a str,
    pub limit: i64,
    pub offset: i64,
}

impl<'a> Command for DocumentListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let collection_name = match self.collection_name {
            "" => self
                .collection_repository
                .get_name_by_number(self.database_name, self.number),
            _ => Ok(String::from(self.collection_name)),
        }?;

        let documents = self.document_repository.find(
            self.database_name,
            collection_name.as_str(),
            self.query_json,
            self.projection_json,
            self.limit,
            self.offset,
        )?;

        let count = self.document_repository.get_count(
            self.database_name,
            collection_name.as_str(),
            self.query_json,
        )?;

        let mut view = HashMap::new();
        view.insert("body", serde_json::to_string_pretty(&documents)?);
        view.insert("database_name", self.database_name.to_string());
        view.insert("collection_name", collection_name);
        let is_last = (count - self.offset) <= self.limit;
        view.insert("is_last", is_last.to_string());
        view.insert("count", count.to_string());

        Ok(serde_json::to_string(&view)?)
    }
}
