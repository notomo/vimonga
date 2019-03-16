use crate::domain::repository::{DocumentRepository, RepositoryError};

use super::connection::ConnectionFactory;

use std::collections::HashMap;

use bson::{Bson, Document};

use serde_json::Value;

use mongodb::coll::options::FindOptions;
use mongodb::db::ThreadedDatabase;
use mongodb::ThreadedClient;

pub struct DocumentRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
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

    fn to_document_from_id(&self, id: &str) -> Result<Document, RepositoryError> {
        let oid = bson::oid::ObjectId::with_string(id)?;
        let mut document = Document::new();
        document.insert_bson("_id".to_string(), oid.into());
        Ok(document)
    }
}

impl<'a> DocumentRepository for DocumentRepositoryImpl<'a> {
    fn find(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
        projection_json: &str,
        sort_json: &str,
        limit: i64,
        skip: i64,
    ) -> Result<Vec<Document>, RepositoryError> {
        let query = Some(self.to_document_from_str(query_json));
        let projection = Some(self.to_document_from_str(projection_json));
        let sort = Some(self.to_document_from_str(sort_json));

        let mut find_option = FindOptions::new();
        find_option.limit = Some(limit);
        find_option.projection = projection;
        find_option.sort = sort;
        find_option.skip = Some(skip);

        let client = self.connection_factory.get()?;
        let cursor = client
            .db(database_name)
            .collection(collection_name)
            .find(query, Some(find_option))?;

        // TODO: remove doc.unwrap()
        let documents: Vec<Document> = cursor.map(|doc| doc.unwrap()).collect();
        Ok(documents)
    }

    fn find_by_id(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<Document, RepositoryError> {
        let query = Some(self.to_document_from_id(id)?);

        let mut find_option = FindOptions::new();
        find_option.limit = Some(1);

        let client = self.connection_factory.get()?;
        let document = client
            .db(database_name)
            .collection(collection_name)
            .find_one(query, Some(find_option))?
            .unwrap();

        Ok(document)
    }

    fn get_count(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
    ) -> Result<i64, RepositoryError> {
        let query = Some(self.to_document_from_str(query_json));

        let client = self.connection_factory.get()?;
        let count = client
            .db(database_name)
            .collection(collection_name)
            .count(query, None)?;

        Ok(count)
    }

    fn update_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
        update_document: &str,
    ) -> Result<bool, RepositoryError> {
        let filter = self.to_document_from_id(id)?;
        let doc = self.to_document_from_str(update_document);

        let mut update = Document::new();
        update.insert_bson("$set".to_string(), doc.into());

        let client = self.connection_factory.get()?;
        client
            .db(database_name)
            .collection(collection_name)
            .update_one(filter, update, None)?;

        Ok(true)
    }

    fn insert_one(
        &self,
        database_name: &str,
        collection_name: &str,
        insert_document: &str,
    ) -> Result<Option<Bson>, RepositoryError> {
        let doc = self.to_document_from_str(insert_document);

        let client = self.connection_factory.get()?;
        let id = client
            .db(database_name)
            .collection(collection_name)
            .insert_one(doc, None)?
            .inserted_id;

        Ok(id)
    }

    fn delete_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<bool, RepositoryError> {
        let filter = self.to_document_from_id(id)?;

        let client = self.connection_factory.get()?;
        client
            .db(database_name)
            .collection(collection_name)
            .delete_one(filter, None)?;

        Ok(true)
    }
}
