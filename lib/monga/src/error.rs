extern crate mongodb;
use mongodb::Error as MongodbError;

use std::error::Error;
use std::fmt;

#[derive(Debug)]
pub enum AppError {
    ConnectionError(String),
    InternalError,
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            AppError::ConnectionError(ref message) => f.write_str(message),
            AppError::InternalError => f.write_str("InternalError"),
        }
    }
}

impl From<mongodb::Error> for AppError {
    fn from(e: MongodbError) -> Self {
        match e {
            MongodbError::ResponseError(message) => AppError::ConnectionError(message),
            _ => AppError::InternalError,
        }
    }
}

impl Error for AppError {
    fn description(&self) -> &str {
        match *self {
            AppError::ConnectionError(ref message) => message,
            AppError::InternalError => "InternalError",
        }
    }
}
