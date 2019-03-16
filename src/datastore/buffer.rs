use crate::domain::repository::BufferRepository;

pub struct BufferRepositoryImpl<'a> {
    pub host: &'a str,
    pub port: u16,
}

impl<'a> BufferRepositoryImpl<'a> {
    fn get_base_path(&self) -> String {
        format!(
            "vimonga://{host}/{port}",
            host = &self.host,
            port = &self.port,
        )
    }

    pub fn new(host: &str, port: u16) -> BufferRepositoryImpl {
        BufferRepositoryImpl {
            host: host,
            port: port,
        }
    }
}

impl<'a> BufferRepository for BufferRepositoryImpl<'a> {
    fn get_dbs_path(&self) -> String {
        format!("{}/dbs", self.get_base_path())
    }

    fn get_db_path(&self, database_name: &str) -> String {
        format!("{}/{}", self.get_dbs_path(), database_name)
    }

    fn get_users_path(&self, database_name: &str) -> String {
        format!("{}/users", self.get_db_path(database_name))
    }

    fn get_collections_path(&self, database_name: &str) -> String {
        format!("{}/colls", self.get_db_path(database_name))
    }

    fn get_indexes_path(&self, database_name: &str, collection_name: &str) -> String {
        format!(
            "{}/{}/indexes",
            self.get_collections_path(database_name),
            collection_name
        )
    }

    fn get_documents_path(&self, database_name: &str, collection_name: &str) -> String {
        format!(
            "{}/{}/docs",
            self.get_collections_path(database_name),
            collection_name
        )
    }

    fn get_document_path(
        &self,
        database_name: &str,
        collection_name: &str,
        object_id: &str,
    ) -> String {
        format!(
            "{}/{}",
            self.get_documents_path(database_name, collection_name),
            object_id
        )
    }
}
