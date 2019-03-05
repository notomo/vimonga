use failure::{Context, Fail};

#[derive(Fail, Debug)]
pub enum RepositoryErrorKind {
    #[fail(display = "Out of index")]
    OutOfIndex,
    #[fail(display = "Internal error: {}", message)]
    InternalError { message: String },
}

#[derive(Debug)]
pub struct RepositoryError {
    pub inner: Context<RepositoryErrorKind>,
}
