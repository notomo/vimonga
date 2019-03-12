use clap::{App, AppSettings, Arg, SubCommand};

mod command;
use command::{
    CollectionDropCommand, CollectionListCommand, Command, DatabaseDropCommand,
    DatabaseListCommand, DocumentGetCommand, DocumentListCommand, DocumentUpdateCommand,
    HelpCommand, IndexListCommand,
};

mod datastore;
use datastore::{
    BufferRepositoryImpl, CollectionRepositoryImpl, ConnectionFactory, DatabaseRepositoryImpl,
    DocumentRepositoryImpl, IndexRepositoryImpl,
};

mod domain;

#[macro_use]
extern crate serde_derive;

use failure::Fail;

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
            SubCommand::with_name("database")
                .subcommand(SubCommand::with_name("list"))
                .subcommand(
                    SubCommand::with_name("drop").arg(
                        Arg::with_name("database_name")
                            .long("database")
                            .takes_value(true)
                            .required(true),
                    ),
                ),
        )
        .subcommand(
            SubCommand::with_name("collection")
                .arg(
                    Arg::with_name("database_name")
                        .long("database")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("list"))
                .subcommand(
                    SubCommand::with_name("drop").arg(
                        Arg::with_name("collection_name")
                            .long("collection")
                            .takes_value(true)
                            .required(true),
                    ),
                ),
        )
        .subcommand(
            SubCommand::with_name("index")
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
                        .required(true),
                )
                .subcommand(
                    SubCommand::with_name("get").arg(
                        Arg::with_name("id")
                            .long("id")
                            .takes_value(true)
                            .required(true),
                    ),
                )
                .subcommand(
                    SubCommand::with_name("update")
                        .arg(
                            Arg::with_name("id")
                                .long("id")
                                .takes_value(true)
                                .required(true),
                        )
                        .arg(
                            Arg::with_name("content")
                                .long("content")
                                .takes_value(true)
                                .required(true),
                        ),
                )
                .subcommand(
                    SubCommand::with_name("find")
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
                        ),
                ),
        );
    let matches = app.get_matches();

    let host = matches.value_of("host").unwrap();
    let port = matches.value_of("port").unwrap().parse().unwrap();
    let connection_factory = ConnectionFactory::new(host, port);
    let buffer_repo = BufferRepositoryImpl::new(host, port);
    let setting = config::Setting::new(matches.value_of("config").unwrap()).unwrap();

    let command_result = match matches.subcommand() {
        ("database", Some(cmd)) => {
            let repo = DatabaseRepositoryImpl {
                connection_factory: &connection_factory,
                host,
                port,
                setting: &setting,
            };
            match cmd.subcommand() {
                ("list", Some(_)) => DatabaseListCommand {
                    database_repository: &repo,
                    buffer_repository: &buffer_repo,
                }
                .run(),
                ("drop", Some(cmd)) => {
                    let database_name = cmd.value_of("database_name").unwrap();
                    DatabaseDropCommand {
                        database_repository: &repo,
                        database_name: database_name,
                    }
                    .run()
                }
                _ => HelpCommand {}.run(),
            }
        }
        ("collection", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();

            let db_repo = DatabaseRepositoryImpl {
                connection_factory: &connection_factory,
                host,
                port,
                setting: &setting,
            };

            let repo = CollectionRepositoryImpl {
                connection_factory: &connection_factory,
                host,
                port,
                setting: &setting,
            };
            match cmd.subcommand() {
                ("list", Some(_)) => CollectionListCommand {
                    collection_repository: &repo,
                    database_repository: &db_repo,
                    buffer_repository: &buffer_repo,
                    database_name,
                }
                .run(),
                ("drop", Some(cmd)) => {
                    let collection_name = cmd.value_of("collection_name").unwrap();
                    CollectionDropCommand {
                        collection_repository: &repo,
                        database_repository: &db_repo,
                        buffer_repository: &buffer_repo,
                        database_name,
                        collection_name,
                    }
                    .run()
                }
                _ => HelpCommand {}.run(),
            }
        }
        ("index", Some(cmd)) => match cmd.subcommand() {
            ("list", Some(_)) => {
                let database_name = cmd.value_of("database_name").unwrap();
                let collection_name = cmd.value_of("collection_name").unwrap();

                let collection_repo = CollectionRepositoryImpl {
                    connection_factory: &connection_factory,
                    host,
                    port,
                    setting: &setting,
                };

                let repo = IndexRepositoryImpl {
                    connection_factory: &connection_factory,
                    host,
                    port,
                    setting: &setting,
                };

                IndexListCommand {
                    index_repository: &repo,
                    collection_repository: &collection_repo,
                    buffer_repository: &buffer_repo,
                    database_name,
                    collection_name,
                }
                .run()
            }
            _ => HelpCommand {}.run(),
        },
        ("document", Some(cmd)) => {
            let database_name = cmd.value_of("database_name").unwrap();
            let collection_name = cmd.value_of("collection_name").unwrap();
            let collection_repo = CollectionRepositoryImpl {
                connection_factory: &connection_factory,
                host,
                port,
                setting: &setting,
            };

            let repo = DocumentRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match cmd.subcommand() {
                ("get", Some(cmd)) => {
                    let id = cmd.value_of("id").unwrap();

                    DocumentGetCommand {
                        document_repository: &repo,
                        collection_repository: &collection_repo,
                        buffer_repository: &buffer_repo,
                        database_name,
                        collection_name,
                        id,
                    }
                    .run()
                }
                ("update", Some(cmd)) => {
                    let id = cmd.value_of("id").unwrap();
                    let content = cmd.value_of("content").unwrap();

                    DocumentUpdateCommand {
                        document_repository: &repo,
                        collection_repository: &collection_repo,
                        buffer_repository: &buffer_repo,
                        database_name,
                        collection_name,
                        id,
                        content,
                    }
                    .run()
                }
                ("find", Some(cmd)) => {
                    let query_json = cmd.value_of("query").unwrap();
                    let projection_json = cmd.value_of("projection").unwrap();
                    let sort_json = cmd.value_of("sort").unwrap();
                    let limit = cmd.value_of("limit").unwrap().parse().unwrap();
                    let offset = cmd.value_of("offset").unwrap().parse().unwrap();

                    DocumentListCommand {
                        document_repository: &repo,
                        collection_repository: &collection_repo,
                        buffer_repository: &buffer_repo,
                        database_name,
                        collection_name,
                        query_json,
                        projection_json,
                        sort_json,
                        limit,
                        offset,
                    }
                    .run()
                }
                _ => HelpCommand {}.run(),
            }
        }
        _ => HelpCommand {}.run(),
    };

    match command_result {
        Ok(content) => println!("{}", content),
        Err(err) => {
            println!("{}", err);
            if let Some(backtrace) = err.backtrace() {
                println!("{}", backtrace);
            }
            std::process::exit(1);
        }
    }
}
