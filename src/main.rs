extern crate bson;
use bson::Document;

extern crate mongodb;
use mongodb::coll::options::FindOptions;
use mongodb::db::ThreadedDatabase;
use mongodb::{doc, Client, ThreadedClient};

extern crate getopts;
use getopts::Options;

extern crate serde_json;
use serde_json::Value;

use std::collections::HashMap;

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut options = Options::new();
    options.optopt("h", "host", "host string", "");
    options.optopt("p", "port", "port number", "");
    options.optopt("m", "method", "method name", "");
    options.optopt("d", "db-name", "database name", "");
    options.optopt("c", "collection-name", "collection name", "");
    options.optopt("q", "query", "find query", "");
    options.optopt("r", "projection", "find projection", "");

    let matches = match options.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => panic!(f.to_string()),
    };

    let host = matches.opt_str("h").unwrap_or("localhost".to_string());
    let port = matches
        .opt_str("p")
        .unwrap_or("27020".to_string())
        .parse()
        .unwrap();

    let database_name = matches.opt_str("d").unwrap_or("".to_string());
    let collection_name = matches.opt_str("c").unwrap_or("".to_string());
    let query = matches.opt_str("q").unwrap_or("{}".to_string());
    let projection = matches.opt_str("r").unwrap_or("{}".to_string());

    let client = Client::connect(&host, port).expect("Failed to initialize client.");

    let content = match matches.opt_str("m").unwrap_or("".to_string()).as_str() {
        "db" => get_database_names(&client),
        "collection" => get_collection_names(&client, database_name.as_str()),
        "document" => get_documents(
            &client,
            database_name.as_str(),
            collection_name.as_str(),
            query.as_str(),
            projection.as_str(),
        ),
        _ => get_database_names(&client),
    };

    println!("{}", content);
}

fn get_database_names(client: &Client) -> String {
    client
        .database_names()
        .ok()
        .expect("Failed to get database names")
        .join("\n")
}

fn get_collection_names(client: &Client, database_name: &str) -> String {
    let filter = Some(doc! {});

    client
        .db(database_name)
        .collection_names(filter)
        .ok()
        .expect("Failed to get collection names")
        .join("\n")
}

fn get_documents(
    client: &Client,
    database_name: &str,
    collection_name: &str,
    query_json: &str,
    projection_json: &str,
) -> String {
    let query = Some(to_document_from_str(query_json));
    let projection = Some(to_document_from_str(projection_json));

    let mut find_option = FindOptions::new();
    find_option.limit = Some(10);
    find_option.projection = projection;

    let cursor = client
        .db(database_name)
        .collection(collection_name)
        .find(query, Some(find_option))
        .ok()
        .expect("Failed to get documents");

    let documents: Vec<_> = cursor.map(|doc| doc.unwrap()).collect();

    serde_json::to_string_pretty(&documents).unwrap()
}

fn to_document_from_str(json_str: &str) -> Document {
    let json_value: HashMap<String, Value> = serde_json::from_str(json_str).unwrap();

    let mut document = Document::new();
    for (key, value) in json_value {
        document.insert_bson(key.to_string(), value.into());
    }
    document
}
