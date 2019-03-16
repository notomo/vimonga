pub trait BufferRepository {
    fn get_dbs_path(&self) -> String;
    fn get_db_path(&self, database_name: &str) -> String;
    fn get_users_path(&self, database_name: &str) -> String;
    fn get_collections_path(&self, database_name: &str) -> String;
    fn get_indexes_path(&self, database_name: &str, collection_name: &str) -> String;
    fn get_documents_path(&self, database_name: &str, collection_name: &str) -> String;
    fn get_document_path(
        &self,
        database_name: &str,
        collection_name: &str,
        object_id: &str,
    ) -> String;
}
