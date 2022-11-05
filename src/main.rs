use clap::{Command, Arg};

mod command;
use command::Command as DefinedCommand;
mod datastore;
mod domain;

#[macro_use]
extern crate serde_derive;

use failure::Fail;

#[tokio::main]
async fn main() {
    let cmd = Command::new("monga")
        .version("0.0.1")
        .subcommand(
            Command::new("complete")
                .arg(
                    Arg::new("current_arg")
                        .long("current")
                        .default_value("")
                        .required(false),
                )
                .arg(
                    Arg::new("args")
                        .long("args")
                        .required(false),
                )
                .arg(
                    Arg::new("host")
                        .long("host")
                        .required(true),
                )
                .subcommand(Command::new("vimonga")),
        )
        .subcommand(
            Command::new("connection").subcommand(
                Command::new("list").arg(
                    Arg::new("file")
                        .long("file")
                        .required(true),
                ),
            ),
        )
        .subcommand(
            Command::new("database")
                .arg(
                    Arg::new("host")
                        .long("host")
                        .required(true),
                )
                .subcommand(Command::new("list"))
                .subcommand(
                    Command::new("drop").arg(
                        Arg::new("database_names")
                            .long("databases")
                            .required(true)
                            // .min_values(1)
                            ,
                    ),
                ),
        )
        .subcommand(
            Command::new("user")
                .arg(
                    Arg::new("database_name")
                        .long("database")
                        .required(true),
                )
                .arg(
                    Arg::new("host")
                        .long("host")
                        .required(true),
                )
                .subcommand(Command::new("list"))
                .subcommand(
                    Command::new("create").arg(
                        Arg::new("info")
                            .long("info")
                            .required(true),
                    ),
                )
                .subcommand(
                    Command::new("drop").arg(
                        Arg::new("name")
                            .long("name")
                            .required(true),
                    ),
                ),
        )
        .subcommand(
            Command::new("collection")
                .arg(
                    Arg::new("database_name")
                        .long("database")
                        .required(true),
                )
                .arg(
                    Arg::new("host")
                        .long("host")
                        .required(true),
                )
                .subcommand(Command::new("list"))
                .subcommand(
                    Command::new("create").arg(
                        Arg::new("collection_names")
                            .long("collections")
                            .required(true),
                    ),
                )
                .subcommand(
                    Command::new("drop").arg(
                        Arg::new("collection_names")
                            .long("collections")
                            .required(true),
                    ),
                ),
        )
        .subcommand(
            Command::new("index")
                .arg(
                    Arg::new("database_name")
                        .long("database")
                        .required(true),
                )
                .arg(
                    Arg::new("collection_name")
                        .long("collection")
                        .required(true),
                )
                .arg(
                    Arg::new("host")
                        .long("host")
                        .required(true),
                )
                .subcommand(Command::new("list"))
                .subcommand(
                    Command::new("create").arg(
                        Arg::new("keys")
                            .long("keys")
                            .required(true),
                    ),
                )
                .subcommand(
                    Command::new("drop").arg(
                        Arg::new("name")
                            .long("name")
                            .required(true),
                    ),
                ),
        )
        .subcommand(
            Command::new("document")
                .arg(
                    Arg::new("database_name")
                        .long("database")
                        .required(true),
                )
                .arg(
                    Arg::new("collection_name")
                        .long("collection")
                        .required(true),
                )
                .arg(
                    Arg::new("host")
                        .long("host")
                        .required(true),
                )
                .subcommand(
                    Command::new("get").arg(
                        Arg::new("id")
                            .long("id")
                            .required(true),
                    ),
                )
                .subcommand(
                    Command::new("delete").arg(
                        Arg::new("id")
                            .long("id")
                            .required(true),
                    ),
                )
                .subcommand(
                    Command::new("insert").arg(
                        Arg::new("content")
                            .long("content")
                            .required(true),
                    ),
                )
                .subcommand(
                    Command::new("update")
                        .arg(
                            Arg::new("id")
                                .long("id")
                                .required(true),
                        )
                        .arg(
                            Arg::new("content")
                                .long("content")
                                .required(true),
                        ),
                )
                .subcommand(
                    Command::new("find")
                        .arg(
                            Arg::new("limit")
                                .long("limit")
                                .default_value("10")
                                .required(false),
                        )
                        .arg(
                            Arg::new("offset")
                                .long("offset")
                                .default_value("0")
                                .required(false),
                        )
                        .arg(
                            Arg::new("query")
                                .long("query")
                                .default_value("{}")
                                .required(false),
                        )
                        .arg(
                            Arg::new("projection")
                                .long("projection")
                                .default_value("{}")
                                .required(false),
                        )
                        .arg(
                            Arg::new("sort")
                                .long("sort")
                                .default_value("{}")
                                .required(false),
                        ),
                ),
        );

    match get_command_result(cmd) {
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

fn get_command_result(cmd: clap::Command) -> Result<String, command::CommandError> {
    let matches = cmd.get_matches();
    match matches.subcommand() {
        Some(("complete", arg_matches)) => {
            let host = arg_matches.get_one::<String>("host").unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host)?;

            let current_arg = arg_matches.get_one::<String>("current_arg").unwrap();
            let args = arg_matches.get_many::<String>("args").unwrap_or_default().map(|x| x.as_str()).collect();
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
            match arg_matches.subcommand() {
                Some(("vimonga", _)) => command::CompleteVimongaCommand {
                    current_arg,
                    args,
                    database_repository: &db_repo,
                    collection_repository: &coll_repo,
                    user_repository: &user_repo,
                    index_repository: &index_repo,
                }
                .run(),
                _ => command::HelpCommand {}.run(),
            }
        }
        Some(("connection", arg_matches)) => match arg_matches.subcommand() {
            Some(("list", cmd)) => {
                let config_file_path = cmd.get_one::<String>("file").unwrap();
                command::ConnectionListCommand { config_file_path }.run()
            }
            _ => command::HelpCommand {}.run(),
        },
        Some(("database", arg_matches)) => {
            let host = arg_matches.get_one::<String>("host").unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host)?;

            let repo = datastore::DatabaseRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match arg_matches.subcommand() {
                Some(("list", _)) => command::DatabaseListCommand {
                    database_repository: &repo,
                }
                .run(),
                Some(("drop", arg_matches)) => {
                    let database_names = arg_matches
                        .get_many::<String>("database_names")
                        .unwrap_or_default()
                        .map(|x| x.as_str())
                        .collect();
                    command::DatabaseDropCommand {
                        database_repository: &repo,
                        database_names,
                    }
                    .run()
                }
                _ => command::HelpCommand {}.run(),
            }
        }
        Some(("user", arg_matches)) => {
            let host = arg_matches.get_one::<String>("host").unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host)?;

            let database_name = arg_matches.get_one::<String>("database_name").unwrap();

            let repo = datastore::UserRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match arg_matches.subcommand() {
                Some(("list", _)) => command::UserListCommand {
                    user_repository: &repo,
                    database_name,
                }
                .run(),
                Some(("create", arg_matches)) => {
                    let create_info_json = arg_matches.get_one::<String>("info").unwrap();
                    command::UserCreateCommand {
                        user_repository: &repo,
                        database_name,
                        create_info_json,
                    }
                    .run()
                }
                Some(("drop", arg_matches)) => {
                    let user_name = arg_matches.get_one::<String>("name").unwrap();
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
        Some(("collection", arg_matches)) => {
            let host = arg_matches.get_one::<String>("host").unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host)?;

            let database_name = arg_matches.get_one::<String>("database_name").unwrap();

            let repo = datastore::CollectionRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match arg_matches.subcommand() {
                Some(("list", _)) => command::CollectionListCommand {
                    collection_repository: &repo,
                    database_name,
                }
                .run(),
                Some(("create", arg_matches)) => {
                    let collection_names = arg_matches
                        .get_many::<String>("collection_names")
                        .unwrap_or_default()
                        .map(|x| x.as_str())
                        .collect();
                    command::CollectionCreateCommand {
                        collection_repository: &repo,
                        database_name,
                        collection_names,
                    }
                    .run()
                }
                Some(("drop", arg_matches)) => {
                    let collection_names = arg_matches
                        .get_many::<String>("collection_names")
                        .unwrap_or_default()
                        .map(|x| x.as_str())
                        .collect();
                    command::CollectionDropCommand {
                        collection_repository: &repo,
                        database_name,
                        collection_names,
                    }
                    .run()
                }
                _ => command::HelpCommand {}.run(),
            }
        }
        Some(("index", arg_matches)) => {
            let host = arg_matches.get_one::<String>("host").unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host)?;

            let database_name = arg_matches.get_one::<String>("database_name").unwrap();
            let collection_name = arg_matches.get_one::<String>("collection_name").unwrap();

            let repo = datastore::IndexRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match arg_matches.subcommand() {
                Some(("list", _)) => command::IndexListCommand {
                    index_repository: &repo,
                    database_name,
                    collection_name,
                }
                .run(),
                Some(("create", arg_matches)) => {
                    let keys_json = arg_matches.get_one::<String>("keys").unwrap();

                    command::IndexCreateCommand {
                        index_repository: &repo,
                        database_name,
                        collection_name,
                        keys_json,
                    }
                }
                .run(),
                Some(("drop", arg_matches)) => {
                    let index_name = arg_matches.get_one::<String>("name").unwrap();

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
        Some(("document", arg_matches)) => {
            let host = arg_matches.get_one::<String>("host").unwrap();
            let connection_factory = datastore::ConnectionFactory::new(host)?;

            let database_name = arg_matches.get_one::<String>("database_name").unwrap();
            let collection_name = arg_matches.get_one::<String>("collection_name").unwrap();

            let repo = datastore::DocumentRepositoryImpl {
                connection_factory: &connection_factory,
            };
            match arg_matches.subcommand() {
                Some(("get", arg_matches)) => {
                    let id = arg_matches.get_one::<String>("id").unwrap();

                    command::DocumentGetCommand {
                        document_repository: &repo,
                        database_name,
                        collection_name,
                        id,
                    }
                    .run()
                }
                Some(("delete", arg_matches)) => {
                    let id = arg_matches.get_one::<String>("id").unwrap();

                    command::DocumentDeleteCommand {
                        document_repository: &repo,
                        database_name,
                        collection_name,
                        id,
                    }
                    .run()
                }
                Some(("insert", arg_matches)) => {
                    let content = arg_matches.get_one::<String>("content").unwrap();

                    command::DocumentInsertCommand {
                        document_repository: &repo,
                        database_name,
                        collection_name,
                        content,
                    }
                    .run()
                }
                Some(("update", arg_matches)) => {
                    let id = arg_matches.get_one::<String>("id").unwrap();
                    let content = arg_matches.get_one::<String>("content").unwrap();

                    command::DocumentUpdateCommand {
                        document_repository: &repo,
                        database_name,
                        collection_name,
                        id,
                        content,
                    }
                    .run()
                }
                Some(("find", arg_matches)) => {
                    let query_json = arg_matches.get_one::<String>("query").unwrap();
                    let projection_json = arg_matches.get_one::<String>("projection").unwrap();
                    let sort_json = arg_matches.get_one::<String>("sort").unwrap();
                    let limit = arg_matches.get_one::<String>("limit").unwrap().parse().unwrap();
                    let offset = arg_matches.get_one::<String>("offset").unwrap().parse().unwrap();

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
    }
}
