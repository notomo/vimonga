use crate::domain::{DocumentRepository, RepositoryError};

use std::collections::HashMap;

use bson::Document;

use serde_json::Value;

use mongodb::coll::options::FindOptions;
use mongodb::db::ThreadedDatabase;
use mongodb::Client;
use mongodb::ThreadedClient;

pub struct DocumentRepositoryImpl<'a> {
    pub client: &'a Client,
}
impl<'a> DocumentRepositoryImpl<'a> {
    fn to_document_from_str(&self, json_str: &str) -> Document {
        // TODO: remove unwrap()
        let decoded_json: HashMap<String, Value> = serde_json::from_str(json_str).unwrap();

        let mut document = Document::new();
        for (key, value) in decoded_json {
            document.insert_bson(key, value.into());
        }
        document
    }
}

impl<'a> DocumentRepository for DocumentRepositoryImpl<'a> {
    fn find(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
        projection_json: &str,
        limit: i64,
        skip: i64,
    ) -> Result<Vec<Document>, RepositoryError> {
        let query = Some(self.to_document_from_str(query_json));
        let projection = Some(self.to_document_from_str(projection_json));

        let mut find_option = FindOptions::new();
        find_option.limit = Some(limit);
        find_option.projection = projection;
        find_option.skip = Some(skip);

        let cursor = self
            .client
            .db(database_name)
            .collection(collection_name)
            .find(query, Some(find_option))?;

        // TODO: remove doc.unwrap()
        let documents: Vec<Document> = cursor.map(|doc| doc.unwrap()).collect();
        Ok(documents)
    }

    fn get_count(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
    ) -> Result<i64, RepositoryError> {
        let query = Some(self.to_document_from_str(query_json));

        let count = self
            .client
            .db(database_name)
            .collection(collection_name)
            .count(query, None)?;

        Ok(count)
    }
}
