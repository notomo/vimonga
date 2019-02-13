extern crate serde_json;

extern crate actix_web;
use actix_web::{http::Method, server, App, HttpRequest, HttpResponse, Json};

use rusqlite::{Connection, NO_PARAMS};

use serde_json::json;

#[derive(Debug, Serialize, Deserialize)]
pub struct Info {
    pub body: Vec<String>,
}

fn upsert_db(info: Json<Info>, req: HttpRequest) -> &'static str {
    let pid = req.match_info().get("pid").unwrap();
    let host = req.match_info().get("host").unwrap();
    let port = req.match_info().get("port").unwrap();

    let conn = get_connection();
    conn.execute_named(
        include_str!("upsert_mongo.sql"),
        &[
            (":key", &format!("/ps/{}/conns/{}/{}/dbs", pid, host, port)),
            (":body", &info.body.join(",")),
        ],
    )
    .unwrap();

    ""
}

fn select_db(req: HttpRequest) -> HttpResponse {
    let pid = req.match_info().get("pid").unwrap();
    let host = req.match_info().get("host").unwrap();
    let port = req.match_info().get("port").unwrap();

    let conn = get_connection();
    let mut stmt = conn.prepare(include_str!("select_mongo.sql")).unwrap();

    let mut rows = stmt
        .query_named(&[(":key", &format!("/ps/{}/conns/{}/{}/dbs", pid, host, port))])
        .ok()
        .unwrap();

    let body = match rows.next() {
        Some(res) => match res {
            Ok(row) => row.get_raw(0).as_str().unwrap(),
            Err(_) => "",
        },
        None => "",
    };

    let names: Vec<String> = body.split(",").map(|x| x.to_string()).collect();
    HttpResponse::Ok().json(json!({
        "body": names,
    }))
}

fn get_connection() -> Connection {
    Connection::open("file::memory:?cache=shared").unwrap()
}

pub fn listen() {
    let conn = get_connection();
    conn.execute(include_str!("create_tables.sql"), NO_PARAMS)
        .unwrap();

    server::new(|| {
        App::new().resource("/ps/{pid}/conns/{host}/{port}/dbs", |r| {
            r.method(Method::POST).with(upsert_db);
            r.method(Method::GET).with(select_db);
            r.route().f(|_| HttpResponse::MethodNotAllowed());
        })
    })
    .bind("127.0.0.1:8000")
    .expect("Can not bind to port 8000")
    .run();
}
