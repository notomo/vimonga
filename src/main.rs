use clap::{App, AppSettings, Arg, SubCommand};

mod command;
use command::{
    CollectionListCommand, Command, DatabaseListCommand, DocumentListCommand, HelpCommand,
    IndexListCommand, ServerPingCommand, ServerStartCommand,
};

mod datastore;
use datastore::{
    CollectionRepositoryImpl, ConnectionFactory, DatabaseRepositoryImpl, DocumentRepositoryImpl,
    IndexRepositoryImpl,
};

mod domain;

#[macro_use]
extern crate serde_derive;

mod config;

fn main() {
    let app = App::new("monga")
        .version("0.0.1")
        .setting(AppSettings::ArgRequiredElseHelp)
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
        .subcommand(
            SubCommand::with_name("server")
                .subcommand(SubCommand::with_name("start"))
                .subcommand(SubCommand::with_name("ping")),
        )
        .subcommand(
            SubCommand::with_name("database")
                .arg(
                    Arg::with_name("pid")
                        .long("pid")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("list")),
        )
        .subcommand(
            SubCommand::with_name("collection")
                .arg(
                    Arg::with_name("database_name")
                        .long("database")
                        .takes_value(true)
                        .default_value(""),
                )
                .arg(
                    Arg::with_name("number")
                        .long("number")
                        .takes_value(true)
                        .default_value("0")
                        .requires_if("", "database_name"),
                )
                .arg(
                    Arg::with_name("pid")
                        .long("pid")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("list")),
        )
        .subcommand(
            SubCommand::with_name("index")
                .arg(
                    Arg::with_name("database_name")
                        .long("database")
                        .takes_value(true)
                        .default_value(""),
                )
                .arg(
                    Arg::with_name("collection_name")
                        .long("collection")
                        .takes_value(true)
                        .default_value(""),
                )
                .arg(
                    Arg::with_name("number")
                        .long("number")
                        .takes_value(true)
                        .default_value("0")
                        .requires_if("", "database_name"),
                )
                .arg(
                    Arg::with_name("pid")
                        .long("pid")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("list")),
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
                    Arg::with_name("number")
                        .long("number")
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
                )
                .arg(
                    Arg::with_name("sort")
                        .long("sort")
                        .takes_value(true)
                        .default_value("{}")
                        .required(false),
                )
                .arg(
                    Arg::with_name("pid")
                        .long("pid")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("find")),
        );
    let matches = app.get_matches();

    let host = matches.value_of("host").unwrap();
    let port = matches.value_of("port").unwrap().parse().unwrap();
    let connection_factory = ConnectionFactory::new(host, port);
    let setting = config::Setting::new(matches.value_of("config").unwrap()).unwrap();

    let command_result = match matches.subcommand() {
        ("server", Some(cmd)) => match cmd.subcommand() {
            ("start", Some(_)) => ServerStartCommand { setting }.run(),
            ("ping", Some(_)) => ServerPingCommand { setting }.run(),
            _ => HelpCommand {}.run(),
        },
        ("database", Some(cmd)) => match cmd.subcommand() {
            ("list", Some(_)) => {
                let pid = cmd.value_of("pid").unwrap();
                let repo = DatabaseRepositoryImpl {
                    connection_factory: &connection_factory,
                    pid,
                    host,
                    port,
                    setting: &setting,
                };

                DatabaseListCommand {
                    database_repository: &repo,
                }
                .run()
            }
            _ => HelpCommand {}.run(),
        },
        ("collection", Some(cmd)) => match cmd.subcommand() {
            ("list", Some(_)) => {
                let pid = cmd.value_of("pid").unwrap();
                let database_name = cmd.value_of("database_name").unwrap();
                let number = cmd.value_of("number").unwrap().parse().unwrap();

                let db_repo = DatabaseRepositoryImpl {
                    connection_factory: &connection_factory,
                    pid,
                    host,
                    port,
                    setting: &setting,
                };

                let repo = CollectionRepositoryImpl {
                    connection_factory: &connection_factory,
                    pid,
                    host,
                    port,
                    setting: &setting,
                };

                CollectionListCommand {
                    collection_repository: &repo,
                    database_repository: &db_repo,
                    database_name,
                    number,
                }
                .run()
            }
            _ => HelpCommand {}.run(),
        },
        ("index", Some(cmd)) => match cmd.subcommand() {
            ("list", Some(_)) => {
                let pid = cmd.value_of("pid").unwrap();
                let database_name = cmd.value_of("database_name").unwrap();
                let collection_name = cmd.value_of("collection_name").unwrap();
                let number = cmd.value_of("number").unwrap().parse().unwrap();

                let collection_repo = CollectionRepositoryImpl {
                    connection_factory: &connection_factory,
                    pid,
                    host,
                    port,
                    setting: &setting,
                };

                let repo = IndexRepositoryImpl {
                    connection_factory: &connection_factory,
                    pid,
                    host,
                    port,
                    setting: &setting,
                };

                IndexListCommand {
                    index_repository: &repo,
                    collection_repository: &collection_repo,
                    database_name,
                    collection_name,
                    number,
                }
                .run()
            }
            _ => HelpCommand {}.run(),
        },
        ("document", Some(cmd)) => match cmd.subcommand() {
            ("find", Some(_)) => {
                let pid = cmd.value_of("pid").unwrap();
                let database_name = cmd.value_of("database_name").unwrap();
                let collection_name = cmd.value_of("collection_name").unwrap();
                let number = cmd.value_of("number").unwrap().parse().unwrap();
                let query_json = cmd.value_of("query").unwrap();
                let projection_json = cmd.value_of("projection").unwrap();
                let sort_json = cmd.value_of("sort").unwrap();
                let limit = cmd.value_of("limit").unwrap().parse().unwrap();
                let offset = cmd.value_of("offset").unwrap().parse().unwrap();

                let collection_repo = CollectionRepositoryImpl {
                    connection_factory: &connection_factory,
                    pid,
                    host,
                    port,
                    setting: &setting,
                };

                let repo = DocumentRepositoryImpl {
                    connection_factory: &connection_factory,
                };

                DocumentListCommand {
                    document_repository: &repo,
                    collection_repository: &collection_repo,
                    database_name,
                    collection_name,
                    number,
                    query_json,
                    projection_json,
                    sort_json,
                    limit,
                    offset,
                }
                .run()
            }
            _ => HelpCommand {}.run(),
        },
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
