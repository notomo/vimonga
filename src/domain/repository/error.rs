use failure::{Context, Fail};

#[derive(Fail, Debug)]
pub enum RepositoryErrorKind {
    #[fail(display = "Internal error: {}", message)]
    InternalError { message: String },
    #[fail(display = "AlreadyExists: {}", message)]
    AlreadyExists { message: String },
}

#[derive(Debug)]
pub struct RepositoryError {
    pub inner: Context<RepositoryErrorKind>,
}
