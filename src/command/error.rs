use std::error::Error;
use std::fmt;

extern crate monga;
use monga::error::AppError;

use reqwest::Error as ReqwestError;

#[derive(Debug)]
pub enum CommandError {
    InternalError,
    OutOfIndex,
}

impl fmt::Display for CommandError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            CommandError::InternalError => f.write_str("InternalError"),
            CommandError::OutOfIndex => f.write_str("OutOfIndex"),
        }
    }
}

impl Error for CommandError {
    fn description(&self) -> &str {
        match *self {
            CommandError::InternalError => "InternalError",
            CommandError::OutOfIndex => "OutOfIndex",
        }
    }
}

impl From<AppError> for CommandError {
    fn from(e: AppError) -> Self {
        match e {
            _ => CommandError::InternalError,
        }
    }
}

impl From<ReqwestError> for CommandError {
    fn from(e: ReqwestError) -> Self {
        match e {
            _ => CommandError::InternalError,
        }
    }
}
