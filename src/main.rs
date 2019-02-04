extern crate mongodb;
use mongodb::{Client, ThreadedClient};

fn main() {
    let client = Client::connect("localhost", 27020).expect("Failed to initialize client.");

    let names = client
        .database_names()
        .ok()
        .expect("Failed to get database names");
    let joined = names.join("\n");

    println!("{}", joined);
}
