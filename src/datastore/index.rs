use crate::domain::repository::{IndexRepository, RepositoryError};

use super::connection::ConnectionFactory;

use std::collections::HashMap;

use async_trait::async_trait;
use bson::{Bson, Document};

use serde_json::Value;

pub struct IndexRepositoryImpl<'a> {
    pub connection_factory: &'a ConnectionFactory<'a>,
}

impl<'a> IndexRepositoryImpl<'a> {
    fn to_document_from_str(&self, json_str: &str) -> Result<Document, RepositoryError> {
        let decoded_json: HashMap<String, Value> = serde_json::from_str(json_str)?;

        let mut document = Document::new();
        for (key, value) in decoded_json {
            let val = value.into();
            let bs = match &val {
                &Bson::I64(v) => Bson::I32(v as i32),
                _ => val,
            };
            document.insert_bson(key, bs);
        }
        Ok(document)
    }
}

#[async_trait]
impl<'a> IndexRepository for IndexRepositoryImpl<'a> {
    async fn get_documents(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<Document>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let cursor = client
            .database(database_name)
            .collection(collection_name)
            .list_indexes(None);

        let documents: Vec<Document> = cursor.map(|index| index.unwrap()).collect();
        Ok(documents)
    }

    async fn get_names(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let cursor = client
            .database(database_name)
            .collection::<Document>(collection_name)
            .list_indexes(None)
            .await?;

        let names = cursor
            .map(|doc| {
                doc.unwrap_or(Document::new())
                    .iter()
                    .filter(|(k, _v)| k.as_str() == "name")
                    .map(|(_k, v)| match v {
                        Bson::String(v) => v.to_string(),
                        _ => "".to_string(),
                    })
                    .collect::<String>()
            })
            .collect();

        Ok(names)
    }

    async fn create(
        &self,
        database_name: &str,
        collection_name: &str,
        keys_json: &str,
    ) -> Result<(), RepositoryError> {
        let keys = self.to_document_from_str(keys_json)?;

        let client = self.connection_factory.get()?;
        client
            .database(database_name)
            .collection::<Document>(collection_name)
            .create_index(keys, None);

        Ok(())
    }

    async fn drop(
        &self,
        database_name: &str,
        collection_name: &str,
        name: &str,
    ) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        client
            .database(database_name)
            .collection::<Document>(collection_name)
            .drop_index(name.to_string(), None);

        Ok(())
    }
}
