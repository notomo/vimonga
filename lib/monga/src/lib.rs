extern crate bson;
use bson::Document;

extern crate mongodb;
use mongodb::coll::options::FindOptions;
use mongodb::db::ThreadedDatabase;
pub use mongodb::Client;
use mongodb::{doc, ThreadedClient};

extern crate serde_json;
use serde_json::Value;

use std::collections::HashMap;

pub mod error;

pub fn connect(host: &str, port: u16) -> Result<Client, error::AppError> {
    let client = Client::connect(&host, port)?;
    Ok(client)
}

pub fn get_database_names(client: &Client) -> Result<Vec<String>, error::AppError> {
    let database_names = client.database_names()?;
    Ok(database_names)
}

pub fn get_collection_names(
    client: &Client,
    database_name: &str,
) -> Result<Vec<String>, error::AppError> {
    let filter = Some(doc! {});

    let collection_names = client.db(database_name).collection_names(filter)?;
    Ok(collection_names)
}

pub fn get_documents(
    client: &Client,
    database_name: &str,
    collection_name: &str,
    query_json: &str,
    projection_json: &str,
    limit: i64,
    skip: i64,
) -> Result<Vec<Document>, error::AppError> {
    let query = Some(to_document_from_str(query_json));
    let projection = Some(to_document_from_str(projection_json));

    let mut find_option = FindOptions::new();
    find_option.limit = Some(limit);
    find_option.projection = projection;
    find_option.skip = Some(skip);

    let cursor = client
        .db(database_name)
        .collection(collection_name)
        .find(query, Some(find_option))?;

    // TODO: remove doc.unwrap()
    let documents: Vec<Document> = cursor.map(|doc| doc.unwrap()).collect();
    Ok(documents)
}

fn to_document_from_str(json_str: &str) -> Document {
    // TODO: remove unwrap()
    let decoded_json: HashMap<String, Value> = serde_json::from_str(json_str).unwrap();

    let mut document = Document::new();
    for (key, value) in decoded_json {
        document.insert_bson(key, value.into());
    }
    document
}
