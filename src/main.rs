extern crate clap;
use clap::{App, AppSettings, Arg, SubCommand};

extern crate monga;
use monga::Client;

extern crate serde_json;

fn main() {
    let app = App::new("vimonga")
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
    let client = monga::connect(&host, port).expect("Failed to initialize client.");

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
    monga::get_database_names(client)
        .ok()
        .expect("Failed to get database names")
        .join("\n")
}

fn get_collection_names(client: &Client, database_name: &str) -> String {
    monga::get_collection_names(client, database_name)
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
    let documents = monga::get_documents(
        client,
        database_name,
        collection_name,
        query_json,
        projection_json,
    )
    .ok()
    .expect("Failed to get documents");

    serde_json::to_string_pretty(&documents).unwrap()
}
