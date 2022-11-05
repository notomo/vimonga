use core::fmt::{self, Display};
use failure::{Backtrace, Context, Fail};

pub use crate::domain::repository::{RepositoryError, RepositoryErrorKind};

use bson::oid::Error as OidError;
use mongodb::error::Error as MongodbError;
use mongodb::error::ErrorKind as MongodbErrorKind;
use serde_json::error::Category as SerdeJsonErrorCategory;
use serde_json::Error as SerdeJsonError;
use std::num::ParseIntError;

impl Fail for RepositoryError {
    fn cause(&self) -> Option<&dyn Fail> {
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
        RepositoryError { inner }
    }
}

impl From<SerdeJsonError> for RepositoryError {
    fn from(e: SerdeJsonError) -> Self {
        let message = e.to_string();
        let kind = match e.classify() {
            SerdeJsonErrorCategory::Syntax | SerdeJsonErrorCategory::Eof => {
                RepositoryErrorKind::DocumentSyntaxError { message }
            }
            _ => RepositoryErrorKind::InternalError { message },
        };
        RepositoryError {
            inner: e.context(kind),
        }
    }
}

impl From<MongodbError> for RepositoryError {
    fn from(e: MongodbError) -> Self {
        let message = e.to_string();
        let kind = match *e.kind {
            MongodbErrorKind::Command(_)
                if message.starts_with("User ") && message.ends_with(" not found") =>
            {
                RepositoryErrorKind::NotFound { message }
            }
            MongodbErrorKind::Command(_) if message.starts_with("index not found with name") => {
                RepositoryErrorKind::NotFound { message }
            }
            MongodbErrorKind::Command(_)
                if message.starts_with("a ") && message.ends_with(" already exists") =>
            {
                RepositoryErrorKind::AlreadyExists { message }
            }
            _ => RepositoryErrorKind::InternalError { message },
        };

        RepositoryError {
            inner: e.context(kind),
        }
    }
}

impl From<OidError> for RepositoryError {
    fn from(e: OidError) -> Self {
        let message = e.to_string();
        RepositoryError {
            inner: e.context(RepositoryErrorKind::InternalError { message }),
        }
    }
}

impl From<ParseIntError> for RepositoryError {
    fn from(e: ParseIntError) -> Self {
        let message = e.to_string();
        RepositoryError {
            inner: e.context(RepositoryErrorKind::ParseError { message }),
        }
    }
}
