extern crate serde_json;

extern crate actix_web;
use actix_web::{http::Method, server, App, Json};

use rusqlite::{Connection, NO_PARAMS};

#[derive(Debug, Serialize, Deserialize)]
struct Info {
    body: String,
    pid: String,
    host: String,
    port: String,
}

fn upsert_db(info: Json<Info>) -> &'static str {
    let conn = get_connection();
    conn.execute(
        include_str!("upsert_mongo.sql"),
        &[
            format!("/ps/{}/conns/{}/{}/dbs", info.pid, info.host, info.port),
            format!("{}", info.body),
        ],
    )
    .unwrap();

    ""
}

fn get_connection() -> Connection {
    Connection::open("file::memory:?cache=shared").unwrap()
}

pub fn listen() {
    let conn = get_connection();
    conn.execute(include_str!("create_tables.sql"), NO_PARAMS)
        .unwrap();

    server::new(|| App::new().resource("dbs", |r| r.method(Method::POST).with(upsert_db)))
        .bind("127.0.0.1:8000")
        .expect("Can not bind to port 8000")
        .run();
}
