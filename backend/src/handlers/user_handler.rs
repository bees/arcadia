use crate::{
    Arcadia, Result,
    models::user::{Profile, PublicProfile, User},
    repositories::{peer_repository, user_repository::find_user_by_id},
};
use actix_web::{HttpResponse, web};
use serde::Deserialize;
use serde_json::json;
use utoipa::IntoParams;

#[derive(Debug, Deserialize, IntoParams)]
pub struct GetUserQuery {
    id: i64,
}

#[utoipa::path(
    get,
    path = "/api/user",
    params(GetUserQuery),
    responses(
        (status = 200, description = "Successfully got the user's profile", body=PublicProfile),
    )
)]
pub async fn get_user(
    arc: web::Data<Arcadia>,
    query: web::Query<GetUserQuery>,
) -> Result<HttpResponse> {
    let user = find_user_by_id(&arc.pool, &query.id).await?;

    Ok(HttpResponse::Created().json(json!({"user":user})))
}

#[utoipa::path(
    get,
    path = "/api/me",
    responses(
        (status = 200, description = "Successfully got the user's profile", body=Profile),
    )
)]
pub async fn get_me(mut current_user: User, arc: web::Data<Arcadia>) -> HttpResponse {
    current_user.password_hash = String::from("");
    let peers = peer_repository::get_user_peers(&arc.pool, current_user.id).await;
    HttpResponse::Ok().json(json!({"user": current_user, "peers":peers}))
}
