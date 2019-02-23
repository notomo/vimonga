extern crate mongodb;
use mongodb::Error as MongodbError;

use std::error::Error;
use std::fmt;

#[derive(Debug)]
pub enum AppError {
    ConnectionError(String),
    InternalError(String),
}

impl fmt::Display for AppError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            AppError::ConnectionError(ref message) => f.write_str(message),
            AppError::InternalError(ref message) => {
                f.write_str(&format!("InternalError: {}", message))
            }
        }
    }
}

impl From<mongodb::Error> for AppError {
    fn from(e: MongodbError) -> Self {
        match e {
            MongodbError::ResponseError(message) => AppError::ConnectionError(message),
            _ => AppError::InternalError(e.to_string()),
        }
    }
}

impl Error for AppError {
    fn description(&self) -> &str {
        match *self {
            AppError::ConnectionError(ref message) => message,
            AppError::InternalError(_) => "InternalError",
        }
    }
}
