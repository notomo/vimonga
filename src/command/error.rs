use std::error::Error;
use std::fmt;

extern crate monga;
use monga::error::AppError;

#[derive(Debug)]
pub enum CommandError {
    InternalError,
}

impl fmt::Display for CommandError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        match *self {
            CommandError::InternalError => f.write_str("InternalError"),
        }
    }
}

impl Error for CommandError {
    fn description(&self) -> &str {
        match *self {
            CommandError::InternalError => "InternalError",
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
