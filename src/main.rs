extern crate mongodb;
use mongodb::coll::options::FindOptions;
use mongodb::db::ThreadedDatabase;
use mongodb::{doc, Client, ThreadedClient};

extern crate getopts;
use getopts::Options;

extern crate serde_json;

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut options = Options::new();
    options.optopt("h", "host", "host string", "");
    options.optopt("p", "port", "port number", "");
    options.optopt("m", "method", "method name", "");
    options.optopt("d", "db-name", "database name", "");
    options.optopt("c", "collection-name", "collection name", "");

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

    let client = Client::connect(&host, port).expect("Failed to initialize client.");

    let content = match matches.opt_str("m").unwrap_or("".to_string()).as_str() {
        "db" => get_database_names(&client),
        "collection" => get_collection_names(&client, database_name.as_str()),
        "document" => get_documents(&client, database_name.as_str(), collection_name.as_str()),
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

fn get_documents(client: &Client, database_name: &str, collection_name: &str) -> String {
    let filter = Some(doc! {});

    let mut find_option = FindOptions::new();
    find_option.limit = Some(10);

    let cursor = client
        .db(database_name)
        .collection(collection_name)
        .find(filter, Some(find_option))
        .ok()
        .expect("Failed to get documents");

    let documents: Vec<_> = cursor.map(|doc| doc.unwrap()).collect();

    serde_json::to_string_pretty(&documents).unwrap()
}
