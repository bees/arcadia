use chrono::NaiveDateTime;
use serde::{Deserialize, Serialize};
use sqlx::types::ipnetwork::IpNetwork;
use utoipa::ToSchema;

#[derive(Debug, PartialEq, Serialize, Deserialize, ToSchema)]
pub struct Peer {
    #[schema(value_type = String, format = "0.0.0.0")]
    pub ip: IpNetwork,
    pub port: i32,
    #[schema(value_type = String, format = DateTime)]
    pub first_seen_at: NaiveDateTime,
    #[schema(value_type = String, format = DateTime)]
    pub last_seen_at: NaiveDateTime,
    pub real_uploaded: i64,
    pub real_downloaded: i64,
    pub user_agent: Option<String>,
}
