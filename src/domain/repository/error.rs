#[derive(Debug)]
pub enum RepositoryError {
    InternalError(String),
    OutOfIndex,
}
