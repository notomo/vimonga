extern crate mongodb;
use mongodb::{Client, ThreadedClient};

extern crate getopts;
use getopts::Options;

use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let mut options = Options::new();
    options.optopt("h", "host", "host string", "");
    options.optopt("p", "port", "port number", "");

    let matches = match options.parse(&args[1..]) {
        Ok(m) => m,
        Err(f) => panic!(f.to_string()),
    };

    let host = matches.opt_str("h").unwrap_or("localhost".to_string());
    let port = matches
        .opt_str("p")
        .unwrap_or("27020".to_string())
        .parse()
        .unwrap();

    let client = Client::connect(&host, port).expect("Failed to initialize client.");

    let names = client
        .database_names()
        .ok()
        .expect("Failed to get database names");
    let joined = names.join("\n");

    println!("{}", joined);
}
