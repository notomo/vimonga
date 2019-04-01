use crate::domain::repository::{IndexRepository, RepositoryError};

use super::connection::ConnectionFactory;

use std::collections::HashMap;

use bson::{Bson, Document};

use serde_json::Value;

use mongodb::db::ThreadedDatabase;
use mongodb::ThreadedClient;

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

impl<'a> IndexRepository for IndexRepositoryImpl<'a> {
    fn get_documents(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<Document>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let cursor = client
            .db(database_name)
            .collection(collection_name)
            .list_indexes()?;

        let documents: Vec<Document> = cursor.map(|index| index.unwrap()).collect();
        Ok(documents)
    }

    fn get_names(
        &self,
        database_name: &str,
        collection_name: &str,
    ) -> Result<Vec<String>, RepositoryError> {
        let client = self.connection_factory.get()?;
        let cursor = client
            .db(database_name)
            .collection(collection_name)
            .list_indexes()?;

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

    fn create(
        &self,
        database_name: &str,
        collection_name: &str,
        keys_json: &str,
    ) -> Result<(), RepositoryError> {
        let keys = self.to_document_from_str(keys_json)?;

        let client = self.connection_factory.get()?;
        client
            .db(database_name)
            .collection(collection_name)
            .create_index(keys, None)?;

        Ok(())
    }

    fn drop(
        &self,
        database_name: &str,
        collection_name: &str,
        name: &str,
    ) -> Result<(), RepositoryError> {
        let client = self.connection_factory.get()?;
        client
            .db(database_name)
            .collection(collection_name)
            .drop_index_string(name.to_string())?;

        Ok(())
    }
}
