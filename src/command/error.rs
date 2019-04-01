use core::fmt::{self, Display};
use failure::{Backtrace, Context, Fail};

use crate::domain::repository::{RepositoryError, RepositoryErrorKind};
use serde_json::Error as SerdeJsonError;

#[derive(Debug)]
pub struct CommandError {
    inner: Context<String>,
    is_backtrace: bool,
}

impl Fail for CommandError {
    fn cause(&self) -> Option<&Fail> {
        self.inner.cause()
    }

    fn backtrace(&self) -> Option<&Backtrace> {
        match self.is_backtrace {
            true => self.inner.backtrace(),
            false => None,
        }
    }
}

impl Display for CommandError {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        Display::fmt(&self.inner, f)
    }
}

impl From<SerdeJsonError> for CommandError {
    fn from(e: SerdeJsonError) -> Self {
        CommandError {
            inner: Context::new(e.to_string()),
            is_backtrace: true,
        }
    }
}

impl From<RepositoryError> for CommandError {
    fn from(e: RepositoryError) -> Self {
        let (message, is_backtrace) = match e.inner.get_context() {
            RepositoryErrorKind::AlreadyExists { message } => (message.clone(), false),
            _ => match e.backtrace() {
                Some(backtrace) => (format!("{}\n{}", e, backtrace), true),
                None => (e.to_string(), true),
            },
        };

        CommandError {
            inner: Context::new(message),
            is_backtrace: is_backtrace,
        }
    }
}
