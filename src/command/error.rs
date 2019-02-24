use std::error::Error;
use std::fmt;

use crate::domain::RepositoryError;

use reqwest::Error as ReqwestError;

extern crate serde_json;
use serde_json::Error as SerdeJsonError;

#[derive(Debug)]
pub enum CommandError {
    InternalError(String),
}

impl fmt::Display for CommandError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            CommandError::InternalError(ref message) => {
                f.write_str(&format!("InternalError: {}", message))
            }
        }
    }
}

impl Error for CommandError {
    fn description(&self) -> &str {
        match *self {
            CommandError::InternalError(_) => "InternalError",
        }
    }
}

impl From<ReqwestError> for CommandError {
    fn from(e: ReqwestError) -> Self {
        match e {
            _ => CommandError::InternalError(e.to_string()),
        }
    }
}

impl From<SerdeJsonError> for CommandError {
    fn from(e: SerdeJsonError) -> Self {
        match e {
            _ => CommandError::InternalError(e.to_string()),
        }
    }
}

impl From<RepositoryError> for CommandError {
    fn from(e: RepositoryError) -> Self {
        match e {
            _ => CommandError::InternalError(e.to_string()),
        }
    }
}
