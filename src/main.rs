extern crate bson;
use bson::Document;

extern crate mongodb;
use mongodb::coll::options::FindOptions;
use mongodb::db::ThreadedDatabase;
use mongodb::{doc, Client, ThreadedClient};

extern crate serde_json;
use serde_json::Value;

extern crate clap;
use clap::{App, AppSettings, Arg, SubCommand};

use std::collections::HashMap;

fn main() {
    let app = App::new("monga")
        .version("0.0.1")
        .setting(AppSettings::ArgRequiredElseHelp)
        .arg(
            Arg::with_name("host")
                .short("h")
                .long("host")
                .default_value("localhost")
                .required(false),
        )
        .arg(
            Arg::with_name("port")
                .short("p")
                .long("port")
                .default_value("27020")
                .required(false),
        )
        .subcommand(SubCommand::with_name("database"))
        .subcommand(
            SubCommand::with_name("collection").arg(
                Arg::with_name("database_name")
                    .long("database")
                    .takes_value(true)
                    .required(true),
            ),
        )
        .subcommand(
            SubCommand::with_name("document")
                .arg(
                    Arg::with_name("database_name")
                        .long("database")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("collection_name")
                        .long("collection")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("query")
                        .long("query")
                        .takes_value(true)
                        .default_value("{}")
                        .required(false),
                )
                .arg(
                    Arg::with_name("projection")
                        .long("projection")
                        .takes_value(true)
                        .default_value("{}")
                        .required(false),
                ),
        );
    let matches = app.get_matches();

    let host = matches.value_of("host").unwrap();
    let port = matches.value_of("port").unwrap().parse().unwrap();
    let client = Client::connect(&host, port).expect("Failed to initialize client.");

    let content = match matches.subcommand() {
        ("database", Some(_)) => get_database_names(&client),
        ("collection", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();
            get_collection_names(&client, database_name)
        }
        ("document", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();
            let collection_name = cmd.value_of("collection_name").unwrap();
            let query = cmd.value_of("query").unwrap();
            let projection = cmd.value_of("projection").unwrap();

            get_documents(&client, database_name, collection_name, query, projection)
        }
        _ => "".to_string(),
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
    let decoded_json: HashMap<String, Value> = serde_json::from_str(json_str).unwrap();

    let mut document = Document::new();
    for (key, value) in decoded_json {
        document.insert_bson(key, value.into());
    }
    document
}
