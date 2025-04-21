mod handlers;
mod models;
mod repositories;
mod routes;
mod tracker;

use actix_cors::Cors;
use actix_web::{App, HttpServer, middleware, web::Data};
use reqwest::Url;
use routes::init;
use sqlx::postgres::PgPoolOptions;
use std::env;
use utoipa::OpenApi;
use utoipa_swagger_ui::SwaggerUi;

use arcadia_index::{Arcadia, Error, OpenSignups, Result, api_doc::ApiDoc};

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    if let Ok(env_path) = dotenvy::dotenv() {
        println!("Loading environment from {}", env_path.display());
    } else {
        println!("No .env present");
    }

    env_logger::init_from_env(env_logger::Env::default().default_filter_or("debug"));

    let database_url = env::var("DATABASE_URL").expect("DATABASE_URL must be set");
    let pool = PgPoolOptions::new()
        .max_connections(5)
        .connect(&database_url)
        .await
        .expect("Error building a connection pool");

    let host = env::var("ACTIX_HOST").unwrap_or_else(|_| "127.0.0.1".to_string());
    let port = env::var("ACTIX_PORT").unwrap_or_else(|_| "8080".to_string());
    println!("Server running at http://{}:{}", host, port);

    let open_signups = if env::var("ARCADIA_OPEN_SIGNUPS").unwrap() == "true" {
        OpenSignups::Enabled
    } else {
        OpenSignups::Disabled
    };

    let tracker_name =
        env::var("ARCADIA_TRACKER_NAME").expect("ARCADIA_TRACKER_NAME env var is not set");

    let frontend_url = env::var("ARCADIA_FRONTEND_URL")
        .ok()
        .and_then(|s| Url::parse(&s).ok())
        .expect("ARCADIA_FRONTEND_URL env var is not set");

    let tracker_url = env::var("ARCADIA_TRACKER_URL")
        .ok()
        .and_then(|s| Url::parse(&s).ok())
        .expect("ARCADIA_TRACKER_URL malformed or missing");

    HttpServer::new(move || {
        let cors = Cors::permissive();
        App::new()
            .wrap(middleware::Logger::default())
            .wrap(cors)
            .app_data(Data::new(Arcadia {
                pool: pool.clone(),
                open_signups,
                tracker_name: tracker_name.clone(),
                frontend_url: frontend_url.clone(),
                tracker_url: tracker_url.clone(),
            }))
            .configure(init) // Initialize routes
            .service(
                SwaggerUi::new("/swagger-ui/{_:.*}")
                    .url("/swagger-json/openapi.json", ApiDoc::openapi()),
            )
    })
    .bind(format!("{}:{}", host, port))?
    .run()
    .await
}
