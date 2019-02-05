extern crate mongodb;
use mongodb::db::ThreadedDatabase;
use mongodb::{doc, Client, ThreadedClient};

extern crate getopts;
use getopts::Options;

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut options = Options::new();
    options.optopt("h", "host", "host string", "");
    options.optopt("p", "port", "port number", "");
    options.optopt("m", "method", "method name", "");
    options.optopt("d", "dbname", "database name", "");

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

    let client = Client::connect(&host, port).expect("Failed to initialize client.");

    let names = match matches.opt_str("m").unwrap_or("".to_string()).as_str() {
        "db" => get_database_names(&client),
        "collection" => get_collection_names(&client, database_name.as_str()),
        _ => get_database_names(&client),
    };

    let joined = names.join("\n");
    println!("{}", joined);
}

fn get_database_names(client: &Client) -> Vec<String> {
    client
        .database_names()
        .ok()
        .expect("Failed to get database names")
}

fn get_collection_names(client: &Client, database_name: &str) -> Vec<String> {
    let filter = Some(doc! {});

    client
        .db(database_name)
        .collection_names(filter)
        .ok()
        .expect("Failed to get collection names")
}
