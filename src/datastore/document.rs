use crate::domain::repository::{DocumentRepository, Item, RepositoryError};

use super::connection::ConnectionFactory;

use std::collections::HashMap;

use async_trait::async_trait;
use bson::{Bson, Document};
use mongodb::options::FindOptions;

pub struct DocumentRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
}
impl<'a> DocumentRepositoryImpl<'a> {
    fn to_document_from_str(&self, json_str: &str) -> Result<Document, RepositoryError> {
        let decoded_json: HashMap<String, Bson> = serde_json::from_str(json_str)?;

        let mut document = Document::new();
        for (key, value) in decoded_json {
            document.insert::<String, Bson>(key, value);
        }
        Ok(document)
    }

    fn to_document_from_id(&self, id: &str) -> Result<Document, RepositoryError> {
        let oid = bson::oid::ObjectId::from(id);
        let mut document = Document::new();
        document.insert::<String, Bson>("_id".to_string(), oid.into());
        Ok(document)
    }
}

#[async_trait]
impl<'a> DocumentRepository for DocumentRepositoryImpl<'a> {
    async fn find(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
        projection_json: &str,
        sort_json: &str,
        limit: i64,
        skip: u64,
    ) -> Result<Vec<Document>, RepositoryError> {
        let query = Some(self.to_document_from_str(query_json)?);
        let projection = Some(self.to_document_from_str(projection_json)?);
        let sort = Some(self.to_document_from_str(sort_json)?);

        let mut find_option = FindOptions::default();
        find_option.limit = Some(limit);
        find_option.projection = projection;
        find_option.sort = sort;
        find_option.skip = Some(skip);

        let client = self.connection_factory.get()?;
        let cursor = client
            .database(database_name)
            .collection::<Document>(collection_name)
            .find(query, Some(find_option))
            .await?;

        // TODO: remove doc.unwrap()
        let documents: Vec<Document> = cursor.map(|doc| doc.unwrap()).collect();
        Ok(documents)
    }

    async fn find_by_id(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<Document, RepositoryError> {
        let query = Some(self.to_document_from_id(id)?);

        let mut find_option = FindOptions::default();
        find_option.limit = Some(1);

        let client = self.connection_factory.get()?;
        let document = client
            .database(database_name)
            .collection::<Document>(collection_name)
            .find_one(query, Some(find_option))
            .await?;

        Ok(document.unwrap())
    }

    async fn get_count(
        &self,
        database_name: &str,
        collection_name: &str,
        query_json: &str,
    ) -> Result<u64, RepositoryError> {
        let query = Some(self.to_document_from_str(query_json)?);

        let client = self.connection_factory.get()?;
        let count = client
            .database(database_name)
            .collection::<Item>(collection_name)
            .count_documents(query, None)
            .await?;

        Ok(count)
    }

    async fn update_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
        update_document: &str,
    ) -> Result<(), RepositoryError> {
        let filter = self.to_document_from_id(id)?;
        let doc = self.to_document_from_str(update_document)?;

        let mut update = Document::new();
        update.insert::<String, Bson>("$set".to_string(), doc.into());

        let client = self.connection_factory.get()?;
        client
            .database(database_name)
            .collection::<Item>(collection_name)
            .update_one(filter, update, None);

        Ok(())
    }

    async fn insert_one(
        &self,
        database_name: &str,
        collection_name: &str,
        insert_document: &str,
    ) -> Result<Bson, RepositoryError> {
        let doc = self.to_document_from_str(insert_document)?;

        let client = self.connection_factory.get()?;
        let id = client
            .database(database_name)
            .collection(collection_name)
            .insert_one(doc, None)
            .await?
            .inserted_id;

        Ok(id)
    }

    async fn delete_one(
        &self,
        database_name: &str,
        collection_name: &str,
        id: &str,
    ) -> Result<(), RepositoryError> {
        let filter = self.to_document_from_id(id)?;

        let client = self.connection_factory.get()?;
        client
            .database(database_name)
            .collection::<Item>(collection_name)
            .delete_one(filter, None);

        Ok(())
    }
}
