use crate::command::error;
use crate::command::Command;

use std::collections::HashMap;

use bson::Bson;

use crate::domain::repository::{BufferRepository, CollectionRepository, DocumentRepository};

pub struct DocumentListCommand<'a> {
    pub document_repository: &'a DocumentRepository,
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub query_json: &'a str,
    pub projection_json: &'a str,
    pub sort_json: &'a str,
    pub limit: i64,
    pub offset: i64,
}

impl<'a> Command for DocumentListCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let documents = self.document_repository.find(
            self.database_name,
            self.collection_name,
            self.query_json,
            self.projection_json,
            self.sort_json,
            self.limit,
            self.offset,
        )?;

        let count = self.document_repository.get_count(
            self.database_name,
            self.collection_name,
            self.query_json,
        )?;

        let mut view = HashMap::new();
        view.insert("body", serde_json::to_string_pretty(&documents)?);
        view.insert("database_name", self.database_name.to_string());
        let is_last = (count - self.offset) <= self.limit;
        view.insert("is_last", is_last.to_string());
        let first = self.offset + 1;
        view.insert("first_number", first.to_string());
        let last = first + documents.len() as i64 - 1;
        view.insert("last_number", last.to_string());
        view.insert("offset", self.offset.to_string());
        view.insert("limit", self.limit.to_string());
        view.insert("count", count.to_string());
        view.insert(
            "path",
            self.buffer_repository
                .get_documents_path(self.database_name, self.collection_name),
        );
        view.insert("collection_name", self.collection_name.to_string());

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct DocumentGetCommand<'a> {
    pub document_repository: &'a DocumentRepository,
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub id: &'a str,
}

impl<'a> Command for DocumentGetCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let document = self.document_repository.find_by_id(
            self.database_name,
            self.collection_name,
            self.id,
        )?;

        let mut view = HashMap::new();
        view.insert("body", serde_json::to_string_pretty(&document)?);
        view.insert("database_name", self.database_name.to_string());
        view.insert(
            "path",
            self.buffer_repository.get_document_path(
                self.database_name,
                self.collection_name,
                self.id,
            ),
        );
        view.insert("collection_name", self.collection_name.to_string());

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct DocumentUpdateCommand<'a> {
    pub document_repository: &'a DocumentRepository,
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub id: &'a str,
    pub content: &'a str,
}

impl<'a> Command for DocumentUpdateCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        self.document_repository.update_one(
            self.database_name,
            self.collection_name,
            self.id,
            self.content,
        )?;

        let mut view = HashMap::new();
        view.insert("body", "");
        view.insert("database_name", self.database_name);
        let path = self.buffer_repository.get_document_path(
            self.database_name,
            self.collection_name,
            self.id,
        );
        view.insert("path", &path);
        view.insert("collection_name", self.collection_name);

        Ok(serde_json::to_string(&view)?)
    }
}

pub struct DocumentInsertCommand<'a> {
    pub document_repository: &'a DocumentRepository,
    pub collection_repository: &'a CollectionRepository,
    pub buffer_repository: &'a BufferRepository,
    pub database_name: &'a str,
    pub collection_name: &'a str,
    pub content: &'a str,
}

impl<'a> Command for DocumentInsertCommand<'a> {
    fn run(&self) -> Result<String, error::CommandError> {
        let id = self.document_repository.insert_one(
            self.database_name,
            self.collection_name,
            self.content,
        )?;

        let body = match id {
            Some(id) => match id {
                Bson::ObjectId(id) => id.to_string(),
                Bson::String(id) => id,
                _ => "".to_string(),
            },
            None => "".to_string(),
        };

        let mut view = HashMap::new();
        view.insert("body", body.as_str());
        view.insert("database_name", self.database_name);
        view.insert("collection_name", self.collection_name);

        Ok(serde_json::to_string(&view)?)
    }
}
