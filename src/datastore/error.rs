pub use crate::domain::RepositoryError;

use std::error::Error;
use std::fmt;

use reqwest::Error as ReqwestError;

extern crate mongodb;
use mongodb::Error as MongodbError;

extern crate serde_json;
use serde_json::Error as SerdeJsonError;

impl fmt::Display for RepositoryError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            RepositoryError::InternalError(ref message) => {
                f.write_str(&format!("InternalError: {}", message))
            }
            RepositoryError::OutOfIndex => f.write_str("OutOfIndex"),
        }
    }
}

impl Error for RepositoryError {
    fn description(&self) -> &str {
        match *self {
            RepositoryError::InternalError(_) => "InternalError",
            RepositoryError::OutOfIndex => "OutOfIndex",
        }
    }
}

impl From<ReqwestError> for RepositoryError {
    fn from(e: ReqwestError) -> Self {
        match e {
            _ => RepositoryError::InternalError(e.to_string()),
        }
    }
}

impl From<SerdeJsonError> for RepositoryError {
    fn from(e: SerdeJsonError) -> Self {
        match e {
            _ => RepositoryError::InternalError(e.to_string()),
        }
    }
}

impl From<MongodbError> for RepositoryError {
    fn from(e: MongodbError) -> Self {
        match e {
            _ => RepositoryError::InternalError(e.to_string()),
        }
    }
}
