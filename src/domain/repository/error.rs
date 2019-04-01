use failure::{Context, Fail};

#[derive(Fail, Debug)]
pub enum RepositoryErrorKind {
    #[fail(display = "Internal error: {}", message)]
    InternalError { message: String },
    #[fail(display = "Already exists: {}", message)]
    AlreadyExists { message: String },
    #[fail(display = "Document syntax error: {}", message)]
    DocumentSyntaxError { message: String },
}

#[derive(Debug)]
pub struct RepositoryError {
    pub inner: Context<RepositoryErrorKind>,
}
