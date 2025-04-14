-- Add migration script here
ALTER TABLE users ADD test_schema_change INTEGER NOT NULL DEFAULT 0;
