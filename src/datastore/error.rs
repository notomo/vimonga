use core::fmt::{self, Display};
use failure::{Backtrace, Context, Fail};

pub use crate::domain::{RepositoryError, RepositoryErrorKind};

use mongodb::Error as MongodbError;
use reqwest::Error as ReqwestError;
use serde_json::Error as SerdeJsonError;

impl Fail for RepositoryError {
    fn cause(&self) -> Option<&Fail> {
        self.inner.cause()
    }

    fn backtrace(&self) -> Option<&Backtrace> {
        self.inner.backtrace()
    }
}

impl Display for RepositoryError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        Display::fmt(&self.inner, f)
    }
}

impl From<RepositoryErrorKind> for RepositoryError {
    fn from(kind: RepositoryErrorKind) -> RepositoryError {
        RepositoryError {
            inner: Context::new(kind),
        }
    }
}

impl From<Context<RepositoryErrorKind>> for RepositoryError {
    fn from(inner: Context<RepositoryErrorKind>) -> RepositoryError {
        RepositoryError { inner: inner }
    }
}

impl From<ReqwestError> for RepositoryError {
    fn from(e: ReqwestError) -> Self {
        let message = match e.url() {
            Some(url) => format!("{}: {}", e, url),
            None => e.to_string(),
        };
        RepositoryError {
            inner: e.context(RepositoryErrorKind::InternalError { message }),
        }
    }
}

impl From<SerdeJsonError> for RepositoryError {
    fn from(e: SerdeJsonError) -> Self {
        let message = e.to_string();
        RepositoryError {
            inner: e.context(RepositoryErrorKind::InternalError { message }),
        }
    }
}

impl From<MongodbError> for RepositoryError {
    fn from(e: MongodbError) -> Self {
        let message = e.to_string();
        RepositoryError {
            inner: e.context(RepositoryErrorKind::InternalError { message }),
        }
    }
}
