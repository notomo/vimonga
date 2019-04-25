#![feature(slice_patterns)]

use clap::{App, AppSettings, Arg, SubCommand};

mod command;
use command::Command;
mod datastore;
mod domain;

#[macro_use]
extern crate serde_derive;

use failure::Fail;

fn main() {
    let app = App::new("monga")
        .version("0.0.1")
        .setting(AppSettings::ArgRequiredElseHelp)
        .subcommand(
            SubCommand::with_name("complete")
                .arg(
                    Arg::with_name("current_arg")
                        .long("current")
                        .takes_value(true)
                        .default_value("")
                        .required(false),
                )
                .arg(
                    Arg::with_name("args")
                        .long("args")
                        .multiple(true)
                        .takes_value(true)
                        .required(false),
                )
                .arg(
                    Arg::with_name("host")
                        .short("h")
                        .long("host")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("port")
                        .short("p")
                        .long("port")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("vimonga")),
        )
        .subcommand(
            SubCommand::with_name("connection").subcommand(
                SubCommand::with_name("list").arg(
                    Arg::with_name("file")
                        .long("file")
                        .takes_value(true)
                        .required(true),
                ),
            ),
        )
        .subcommand(
            SubCommand::with_name("database")
                .arg(
                    Arg::with_name("host")
                        .short("h")
                        .long("host")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("port")
                        .short("p")
                        .long("port")
                        .takes_value(true)
                        .required(true),
                )
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
            SubCommand::with_name("user")
                .arg(
                    Arg::with_name("database_name")
                        .long("database")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("host")
                        .short("h")
                        .long("host")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("port")
                        .short("p")
                        .long("port")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("list"))
                .subcommand(
                    SubCommand::with_name("create").arg(
                        Arg::with_name("info")
                            .long("info")
                            .takes_value(true)
                            .required(true),
                    ),
                )
                .subcommand(
                    SubCommand::with_name("drop").arg(
                        Arg::with_name("name")
                            .long("name")
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
                .arg(
                    Arg::with_name("host")
                        .short("h")
                        .long("host")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("port")
                        .short("p")
                        .long("port")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("list"))
                .subcommand(
                    SubCommand::with_name("create").arg(
                        Arg::with_name("collection_name")
                            .long("collection")
                            .takes_value(true)
                            .required(true),
                    ),
                )
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
                .arg(
                    Arg::with_name("host")
                        .short("h")
                        .long("host")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("port")
                        .short("p")
                        .long("port")
                        .takes_value(true)
                        .required(true),
                )
                .subcommand(SubCommand::with_name("list"))
                .subcommand(
                    SubCommand::with_name("create").arg(
                        Arg::with_name("keys")
                            .long("keys")
                            .takes_value(true)
                            .required(true),
                    ),
                )
                .subcommand(
                    SubCommand::with_name("drop").arg(
                        Arg::with_name("name")
                            .long("name")
                            .takes_value(true)
                            .required(true),
                    ),
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
                    Arg::with_name("host")
                        .short("h")
                        .long("host")
                        .takes_value(true)
                        .required(true),
                )
                .arg(
                    Arg::with_name("port")
                        .short("p")
                        .long("port")
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
                    SubCommand::with_name("delete").arg(
                        Arg::with_name("id")
                            .long("id")
                            .takes_value(true)
                            .required(true),
                    ),
                )
                .subcommand(
                    SubCommand::with_name("insert").arg(
                        Arg::with_name("content")
                            .long("content")
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

    let command_result = match matches.subcommand() {
        ("complete", Some(cmd)) => {
            let host = cmd.value_of("host").unwrap();
            let port = cmd.value_of("port").unwrap().parse().unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host, port);

            let current_arg = cmd.value_of("current_arg").unwrap();
            let args: Vec<_> = cmd.values_of("args").unwrap_or_default().collect();
            let db_repo = datastore::DatabaseRepositoryImpl {
                connection_factory: &connection_factory,
            };
            let coll_repo = datastore::CollectionRepositoryImpl {
                connection_factory: &connection_factory,
            };
            let user_repo = datastore::UserRepositoryImpl {
                connection_factory: &connection_factory,
            };
            let index_repo = datastore::IndexRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match cmd.subcommand() {
                ("vimonga", Some(_)) => command::CompleteVimongaCommand {
                    current_arg: current_arg,
                    args: args,
                    database_repository: &db_repo,
                    collection_repository: &coll_repo,
                    user_repository: &user_repo,
                    index_repository: &index_repo,
                }
                .run(),
                _ => command::HelpCommand {}.run(),
            }
        }
        ("connection", Some(cmd)) => match cmd.subcommand() {
            ("list", Some(cmd)) => {
                let config_file_path = cmd.value_of("file").unwrap();
                command::ConnectionListCommand { config_file_path }.run()
            }
            _ => command::HelpCommand {}.run(),
        },
        ("database", Some(cmd)) => {
            let host = cmd.value_of("host").unwrap();
            let port = cmd.value_of("port").unwrap().parse().unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host, port);

            let repo = datastore::DatabaseRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match cmd.subcommand() {
                ("list", Some(_)) => command::DatabaseListCommand {
                    database_repository: &repo,
                }
                .run(),
                ("drop", Some(cmd)) => {
                    let database_name = cmd.value_of("database_name").unwrap();
                    command::DatabaseDropCommand {
                        database_repository: &repo,
                        database_name: database_name,
                    }
                    .run()
                }
                _ => command::HelpCommand {}.run(),
            }
        }
        ("user", Some(cmd)) => {
            let host = cmd.value_of("host").unwrap();
            let port = cmd.value_of("port").unwrap().parse().unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host, port);

            let database_name = cmd.value_of("database_name").unwrap();

            let repo = datastore::UserRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match cmd.subcommand() {
                ("list", Some(_)) => command::UserListCommand {
                    user_repository: &repo,
                    database_name,
                }
                .run(),
                ("create", Some(cmd)) => {
                    let create_info_json = cmd.value_of("info").unwrap();
                    command::UserCreateCommand {
                        user_repository: &repo,
                        database_name,
                        create_info_json,
                    }
                    .run()
                }
                ("drop", Some(cmd)) => {
                    let user_name = cmd.value_of("name").unwrap();
                    command::UserDropCommand {
                        user_repository: &repo,
                        database_name,
                        user_name,
                    }
                    .run()
                }
                _ => command::HelpCommand {}.run(),
            }
        }
        ("collection", Some(cmd)) => {
            let host = cmd.value_of("host").unwrap();
            let port = cmd.value_of("port").unwrap().parse().unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host, port);

            let database_name = cmd.value_of("database_name").unwrap();

            let repo = datastore::CollectionRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match cmd.subcommand() {
                ("list", Some(_)) => command::CollectionListCommand {
                    collection_repository: &repo,
                    database_name,
                }
                .run(),
                ("create", Some(cmd)) => {
                    let collection_name = cmd.value_of("collection_name").unwrap();
                    command::CollectionCreateCommand {
                        collection_repository: &repo,
                        database_name,
                        collection_name,
                    }
                    .run()
                }
                ("drop", Some(cmd)) => {
                    let collection_name = cmd.value_of("collection_name").unwrap();
                    command::CollectionDropCommand {
                        collection_repository: &repo,
                        database_name,
                        collection_name,
                    }
                    .run()
                }
                _ => command::HelpCommand {}.run(),
            }
        }
        ("index", Some(cmd)) => {
            let host = cmd.value_of("host").unwrap();
            let port = cmd.value_of("port").unwrap().parse().unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host, port);

            let database_name = cmd.value_of("database_name").unwrap();
            let collection_name = cmd.value_of("collection_name").unwrap();

            let repo = datastore::IndexRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match cmd.subcommand() {
                ("list", Some(_)) => command::IndexListCommand {
                    index_repository: &repo,
                    database_name,
                    collection_name,
                }
                .run(),
                ("create", Some(cmd)) => {
                    let keys_json = cmd.value_of("keys").unwrap();

                    command::IndexCreateCommand {
                        index_repository: &repo,
                        database_name,
                        collection_name,
                        keys_json,
                    }
                }
                .run(),
                ("drop", Some(cmd)) => {
                    let index_name = cmd.value_of("name").unwrap();

                    command::IndexDropCommand {
                        index_repository: &repo,
                        database_name,
                        collection_name,
                        index_name,
                    }
                }
                .run(),
                _ => command::HelpCommand {}.run(),
            }
        }
        ("document", Some(cmd)) => {
            let host = cmd.value_of("host").unwrap();
            let port = cmd.value_of("port").unwrap().parse().unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host, port);

            let database_name = cmd.value_of("database_name").unwrap();
            let collection_name = cmd.value_of("collection_name").unwrap();

            let repo = datastore::DocumentRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match cmd.subcommand() {
                ("get", Some(cmd)) => {
                    let id = cmd.value_of("id").unwrap();

                    command::DocumentGetCommand {
                        document_repository: &repo,
                        database_name,
                        collection_name,
                        id,
                    }
                    .run()
                }
                ("delete", Some(cmd)) => {
                    let id = cmd.value_of("id").unwrap();

                    command::DocumentDeleteCommand {
                        document_repository: &repo,
                        database_name,
                        collection_name,
                        id,
                    }
                    .run()
                }
                ("insert", Some(cmd)) => {
                    let content = cmd.value_of("content").unwrap();

                    command::DocumentInsertCommand {
                        document_repository: &repo,
                        database_name,
                        collection_name,
                        content,
                    }
                    .run()
                }
                ("update", Some(cmd)) => {
                    let id = cmd.value_of("id").unwrap();
                    let content = cmd.value_of("content").unwrap();

                    command::DocumentUpdateCommand {
                        document_repository: &repo,
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

                    command::DocumentListCommand {
                        document_repository: &repo,
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
                _ => command::HelpCommand {}.run(),
            }
        }
        _ => command::HelpCommand {}.run(),
    };

    match command_result {
        Ok(content) => println!("{}", content),
        Err(err) => {
            eprintln!("{}", err);
            if let Some(backtrace) = err.backtrace() {
                eprintln!("{}", backtrace);
            }
            std::process::exit(1);
        }
    }
}
