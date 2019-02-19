extern crate clap;
use clap::{App, AppSettings, Arg, SubCommand};

mod command;
use command::{
    CollectionListCommand, Command, DatabaseListCommand, DocumentListCommand, HelpCommand,
    ServerStartCommand,
};

#[macro_use]
extern crate serde_derive;

mod config;

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
                .default_value("27017")
                .takes_value(true)
                .required(false),
        )
        .arg(
            Arg::with_name("config")
                .long("config")
                .default_value("./vimonga.toml")
                .takes_value(true)
                .required(false),
        )
        .subcommand(SubCommand::with_name("server"))
        .subcommand(SubCommand::with_name("database"))
        .subcommand(
            SubCommand::with_name("collection")
                .arg(
                    Arg::with_name("database_name")
                        .long("database")
                        .takes_value(true)
                        .default_value(""),
                )
                .arg(
                    Arg::with_name("index")
                        .long("index")
                        .takes_value(true)
                        .default_value("0")
                        .requires_if("", "database_name"),
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
                        .default_value(""),
                )
                .arg(
                    Arg::with_name("index")
                        .long("index")
                        .takes_value(true)
                        .default_value("0")
                        .requires_if("", "collection_name"),
                )
                .arg(
                    Arg::with_name("limit")
                        .long("limit")
                        .takes_value(true)
                        .default_value("10")
                        .required(false),
                )
                .arg(
                    Arg::with_name("offset")
                        .long("offset")
                        .takes_value(true)
                        .default_value("0")
                        .required(false),
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
    let setting = config::Setting::new(matches.value_of("config").unwrap()).unwrap();

    let pid = matches.value_of("pid").unwrap();
    let command_result = match matches.subcommand() {
        ("server", Some(_)) => ServerStartCommand { setting }.run(),
        ("database", Some(_)) => DatabaseListCommand {
            client,
            pid,
            host,
            port,
            setting,
        }
        .run(),
        ("collection", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();
            let index = cmd.value_of("index").unwrap().parse().unwrap();
            CollectionListCommand {
                client,
                database_name,
                index,
                pid,
                host,
                port,
                setting,
            }
            .run()
        }
        ("document", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();
            let collection_name = cmd.value_of("collection_name").unwrap();
            let index = cmd.value_of("index").unwrap().parse().unwrap();
            let query_json = cmd.value_of("query").unwrap();
            let projection_json = cmd.value_of("projection").unwrap();
            let limit = cmd.value_of("limit").unwrap().parse().unwrap();
            let offset = cmd.value_of("offset").unwrap().parse().unwrap();

            DocumentListCommand {
                client,
                database_name,
                collection_name,
                index,
                query_json,
                projection_json,
                limit,
                offset,
                pid,
                host,
                port,
                setting,
            }
            .run()
        }
        _ => HelpCommand {}.run(),
    };

    match command_result {
        Ok(content) => println!("{}", content),
        Err(err) => {
            println!("{}", err);
            std::process::exit(1);
        }
    }
}
