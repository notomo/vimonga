extern crate clap;
use clap::{App, AppSettings, Arg, SubCommand};

mod command;
use command::{
    CollectionListCommand, Command, DatabaseListCommand, DocumentListCommand, HelpCommand,
    ServerStartCommand,
};

fn main() {
    let app = App::new("monga")
        .version("0.0.1")
        .setting(AppSettings::ArgRequiredElseHelp)
        .arg(
            Arg::with_name("pid")
                .long("pid")
                .takes_value(true)
                .required(true),
        )
        .arg(
            Arg::with_name("host")
                .short("h")
                .long("host")
                .default_value("localhost")
                .takes_value(true)
                .required(false),
        )
        .arg(
            Arg::with_name("port")
                .short("p")
                .long("port")
                .default_value("27020")
                .takes_value(true)
                .required(false),
        )
        .subcommand(SubCommand::with_name("server"))
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

    let pid = matches.value_of("pid").unwrap();
    let content = match matches.subcommand() {
        ("server", Some(_)) => ServerStartCommand {}.run(),
        ("database", Some(_)) => DatabaseListCommand {
            client,
            pid,
            host,
            port,
        }
        .run(),
        ("collection", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();
            CollectionListCommand {
                client,
                database_name,
            }
            .run()
        }
        ("document", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();
            let collection_name = cmd.value_of("collection_name").unwrap();
            let query_json = cmd.value_of("query").unwrap();
            let projection_json = cmd.value_of("projection").unwrap();

            DocumentListCommand {
                client,
                database_name,
                collection_name,
                query_json,
                projection_json,
            }
            .run()
        }
        _ => HelpCommand {}.run(),
    }
    .or_else(|e| -> Result<String, String> { Ok(e.to_string()) })
    .ok()
    .unwrap();

    println!("{}", content);
}
