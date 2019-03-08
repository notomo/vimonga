pub trait BufferRepository {
    fn get_dbs_path(&self) -> String;
    fn get_collections_path(&self, database_name: &str) -> String;
    fn get_indexes_path(&self, database_name: &str, collection_name: &str) -> String;
    fn get_documents_path(&self, database_name: &str, collection_name: &str) -> String;
}