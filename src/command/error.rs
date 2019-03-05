use core::fmt::{self, Display};
use failure::{Backtrace, Context, Fail};

use crate::domain::RepositoryError;
use reqwest::Error as ReqwestError;
use serde_json::Error as SerdeJsonError;

#[derive(Debug)]
pub struct CommandError {
    inner: Context<String>,
}

impl Fail for CommandError {
    fn cause(&self) -> Option<&Fail> {
        self.inner.cause()
    }

    fn backtrace(&self) -> Option<&Backtrace> {
        self.inner.backtrace()
    }
}

impl Display for CommandError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        Display::fmt(&self.inner, f)
    }
}

impl From<ReqwestError> for CommandError {
    fn from(e: ReqwestError) -> Self {
        CommandError {
            inner: Context::new(e.to_string()),
        }
    }
}

impl From<SerdeJsonError> for CommandError {
    fn from(e: SerdeJsonError) -> Self {
        CommandError {
            inner: Context::new(e.to_string()),
        }
    }
}

impl From<RepositoryError> for CommandError {
    fn from(e: RepositoryError) -> Self {
        match e.backtrace() {
            Some(backtrace) => CommandError {
                inner: Context::new(backtrace.to_string()),
            },
            None => CommandError {
                inner: Context::new(e.to_string()),
            },
        }
    }
}
