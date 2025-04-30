CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(20) UNIQUE NOT NULL,
    avatar TEXT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    registered_from_ip INET NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description TEXT NOT NULL DEFAULT '',
    uploaded BIGINT NOT NULL DEFAULT 0,
    real_uploaded BIGINT NOT NULL DEFAULT 0,
    -- 1 byte downloaded
    downloaded BIGINT NOT NULL DEFAULT 1,
    real_downloaded BIGINT NOT NULL DEFAULT 1,
    ratio FLOAT NOT NULL DEFAULT 0.0,
    required_ratio FLOAT NOT NULL DEFAULT 0.0,
    last_seen TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    class VARCHAR(50) NOT NULL DEFAULT 'newbie',
    forum_posts INTEGER NOT NULL DEFAULT 0,
    forum_threads INTEGER NOT NULL DEFAULT 0,
    group_comments INTEGER NOT NULL DEFAULT 0,
    torrent_comments INTEGER NOT NULL DEFAULT 0,
    request_comments INTEGER NOT NULL DEFAULT 0,
    artist_comments BIGINT NOT NULL DEFAULT 0,
    seeding INTEGER NOT NULL DEFAULT 0,
    leeching INTEGER NOT NULL DEFAULT 0,
    snatched INTEGER NOT NULL DEFAULT 0,
    seeding_size BIGINT NOT NULL DEFAULT 0,
    requests_filled BIGINT NOT NULL DEFAULT 0,
    collages_started BIGINT NOT NULL DEFAULT 0,
    requests_voted BIGINT NOT NULL DEFAULT 0,
    average_seeding_time BIGINT NOT NULL DEFAULT 0,
    invited BIGINT NOT NULL DEFAULT 0,
    invitations SMALLINT NOT NULL DEFAULT 0,
    bonus_points BIGINT NOT NULL DEFAULT 0,
    freeleech_tokens INT NOT NULL DEFAULT 0,
    settings JSONB NOT NULL DEFAULT '{}',
    passkey_upper BIGINT NOT NULL,
    passkey_lower BIGINT NOT NULL,

    UNIQUE(passkey_upper, passkey_lower)
);
CREATE TABLE invitations (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP NOT NULL,
    invitation_key VARCHAR(50) NOT NULL,
    message TEXT NOT NULL,
    sender_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    receiver_email VARCHAR(255) NOT NULL,
    receiver_id BIGINT REFERENCES users(id) ON DELETE
    SET NULL
);
CREATE TABLE artists (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    pictures TEXT [] NOT NULL,
    created_by_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    title_groups_amount INT NOT NULL DEFAULT 0,
    edition_groups_amount INT NOT NULL DEFAULT 0,
    torrents_amount INT NOT NULL DEFAULT 0,
    seeders_amount INT NOT NULL DEFAULT 0,
    leechers_amount INT NOT NULL DEFAULT 0,
    snatches_amount INT NOT NULL DEFAULT 0,
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE similar_artists (
    artist_1_id BIGINT NOT NULL,
    artist_2_id BIGINT NOT NULL,
    PRIMARY KEY (artist_1_id, artist_2_id),
    FOREIGN KEY (artist_1_id) REFERENCES artists(id) ON DELETE CASCADE,
    FOREIGN KEY (artist_2_id) REFERENCES artists(id) ON DELETE CASCADE
);
CREATE TABLE master_groups (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255),
    -- name_aliases VARCHAR(255)[],
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by_id BIGINT NOT NULL,
    -- description TEXT NOT NULL,
    -- original_language VARCHAR(50) NOT NULL,
    -- country_from VARCHAR(50) NOT NULL,
    -- tags VARCHAR(50)[] NOT NULL,
    -- category VARCHAR(25), -- should only be used for TV-Shows (scripted, reality-tv, etc.)
    -- covers TEXT[],
    -- banners TEXT[],
    -- fan_arts TEXT[],
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE
    SET NULL
);
CREATE TABLE similar_master_groups (
    group_1_id BIGINT NOT NULL,
    group_2_id BIGINT NOT NULL,
    PRIMARY KEY (group_1_id, group_2_id),
    FOREIGN KEY (group_1_id) REFERENCES master_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (group_2_id) REFERENCES master_groups(id) ON DELETE CASCADE
);
CREATE TABLE series (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    tags TEXT [] NOT NULL,
    covers TEXT [] NOT NULL,
    banners TEXT [] NOT NULL,
    created_by_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TYPE content_type_enum AS ENUM (
    'movie',
    'tv_show',
    'music',
    'software',
    'book',
    'collection'
);
CREATE TYPE title_group_category_enum AS ENUM (
    'Ep',
    'Album',
    'Single',
    'Soundtrack',
    'Anthology',
    'Compilation',
    'Remix',
    'Bootleg',
    'Mixtape',
    'ConcertRecording',
    'DjMix',
    'FeatureFilm',
    'ShortFilm',
    'Game',
    'Program',
    'Illustrated',
    'Periodical',
    'Book',
    'Article',
    'Manual',
    'Other'
);
CREATE TYPE platform_enum AS ENUM(
    'Linux',
    'MacOS', 
    'Windows',
    'Xbox'
);
CREATE TABLE title_groups (
    id BIGSERIAL PRIMARY KEY,
    master_group_id BIGINT,
    name TEXT NOT NULL,
    name_aliases TEXT [],
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by_id BIGINT NOT NULL,
    description TEXT NOT NULL,
    platform platform_enum,
    original_language TEXT,
    original_release_date TIMESTAMP NOT NULL,
    tagline TEXT,
    tags VARCHAR(50) [] NOT NULL,
    country_from TEXT,
    covers TEXT [] NOT NULL,
    external_links TEXT [] NOT NULL,
    embedded_links JSONB NOT NULL,
    category title_group_category_enum,
    content_type content_type_enum NOT NULL,
    public_ratings JSONB,
    screenshots TEXT[] NOT NULL,
    series_id BIGINT,
    FOREIGN KEY (master_group_id) REFERENCES master_groups(id) ON DELETE
    SET NULL,
        FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE
    SET NULL,
        FOREIGN KEY (series_id) REFERENCES series(id) ON DELETE
    SET NULL
);
CREATE TABLE similar_title_groups (
    group_1_id BIGINT NOT NULL,
    group_2_id BIGINT NOT NULL,
    PRIMARY KEY (group_1_id, group_2_id),
    FOREIGN KEY (group_1_id) REFERENCES title_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (group_2_id) REFERENCES title_groups(id) ON DELETE CASCADE
);
CREATE TYPE artist_role_enum AS ENUM(
    'main',
    'producer',
    'guest',
    'composer',
    'conductor',
    'dj_compiler',
    'remixer',
    'arranger',
    'director',
    'cinematographer',
    'actor',
    'author'
);
CREATE TABLE affiliated_artists (
    title_group_id BIGINT NOT NULL,
    artist_id BIGINT NOT NULL,
    roles artist_role_enum[] NOT NULL,
    nickname VARCHAR(255),
    created_by_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (title_group_id) REFERENCES title_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (artist_id) REFERENCES artists(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE
    SET NULL
);
-- for web: if it is a DL or a RIP should be specified at the torrent level
CREATE TYPE source_enum AS ENUM (
    'CD',
    'DVD5',
    'DVD9',
    'Vinyl',
    'Web',
    'Soundboard',
    'SACD',
    'DAT',
    'Cassette',
    'Blu-Ray',
    'LaserDisc',
    'HD-DVD',
    'HDTV',
    'PDTV',
    'TV',
    'VHS',
    'Mixed',
    'Physical Book'
);
CREATE TABLE edition_groups (
    id BIGSERIAL PRIMARY KEY,
    title_group_id BIGINT NOT NULL,
    name TEXT NOT NULL,
    release_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by_id BIGINT NOT NULL,
    description TEXT,
    distributor VARCHAR(255),
    covers TEXT [] NOT NULL,
    external_links TEXT [] NOT NULL,
    source source_enum,
    additional_information JSONB,
    FOREIGN KEY (title_group_id) REFERENCES title_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE
    SET NULL
);
CREATE TYPE audio_codec_enum AS ENUM (
    'mp2',
    'mp3',
    'aac',
    'ac3',
    'dts',
    'flac',
    'pcm',
    'true-hd',
    'opus',
    'dsd'
);
CREATE TYPE audio_bitrate_sampling_enum AS ENUM(
    '192',
    '256',
    '320',
    'APS (VBR)',
    'V2 (VBR)',
    'V1 (VBR)',
    'APX (VBR)',
    'V0 (VBR)',
    'Lossless',
    '24bit Lossless',
    'DSD64',
    'DSD128',
    'DSD256',
    'DSD512',
    'other'
);
CREATE TYPE audio_channels_enum AS ENUM (
    '1.0',
    '2.0',
    '2.1',
    '5.0',
    '5.1',
    '7.1'
);
CREATE TYPE video_codec_enum AS ENUM(
    'mpeg1',
    'mpeg2',
    'Xvid',
    'divX',
    'h264',
    'h265',
    'vc-1',
    'vp9',
    'BD50',
    'UHD100'
);
CREATE TYPE language_enum AS ENUM(
   'English',
   'French',
   'German',
   'Italian',
   'Spanish',
   'Swedish'
);
CREATE TYPE features_enum AS ENUM('HDR', 'DV', 'Commentary', 'Remux', '3D', 'Booklet', 'Cue');
CREATE TABLE torrents (
    id BIGSERIAL PRIMARY KEY,
    upload_factor FLOAT NOT NULL DEFAULT 1.0,
    download_factor FLOAT NOT NULL DEFAULT 1.0,
    edition_group_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by_id BIGINT NOT NULL,
    info_hash BYTEA NOT NULL,
    info_dict BYTEA NOT NULL,
    languages language_enum[] NOT NULL,
    release_name TEXT NOT NULL,
    -- maybe change the size
    release_group VARCHAR(30),
    description TEXT,
    file_amount_per_type JSONB NOT NULL,
    uploaded_as_anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    file_list JSONB NOT NULL,
    -- maybe change the size to the max length of a file name in a torrent
    mediainfo TEXT NOT NULL,
    trumpable TEXT,
    staff_checked BOOLEAN NOT NULL DEFAULT FALSE,
    container VARCHAR(8) NOT NULL,
    -- in bytes
    size BIGINT NOT NULL,

    -- audio
    duration INT,
    -- in seconds
    audio_codec audio_codec_enum,
    audio_bitrate INT,
    -- in kb/s, taken from mediainfo
    audio_bitrate_sampling audio_bitrate_sampling_enum,
    audio_channels audio_channels_enum,
    -- audio

    -- video
    video_codec video_codec_enum,
    features features_enum [] NOT NULL,
    subtitle_languages language_enum[] NOT NULL,
    video_resolution VARCHAR(6),

    FOREIGN KEY (edition_group_id) REFERENCES edition_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE (info_hash)
);
CREATE TABLE title_group_comments (
    id BIGSERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by_id BIGINT NOT NULL,
    title_group_id BIGINT NOT NULL,
    refers_to_torrent_id BIGINT,
    answers_to_comment_id BIGINT,
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (title_group_id) REFERENCES title_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (refers_to_torrent_id) REFERENCES torrents(id) ON DELETE SET NULL,
    FOREIGN KEY (answers_to_comment_id) REFERENCES title_group_comments(id) ON DELETE SET NULL
);
CREATE TABLE torrent_requests (
    id BIGSERIAL PRIMARY KEY,
    title_group_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by_id BIGINT NOT NULL,
    edition_name TEXT,
    release_group VARCHAR(20),
    description TEXT,
    languages language_enum[] NOT NULL,
    container VARCHAR(8),
    bounty_upload BIGINT NOT NULL,
    bounty_bonus_points BIGINT NOT NULL,
    -- Audio
    audio_codec audio_codec_enum,
    audio_channels VARCHAR(8),
    -- Video
    video_codec video_codec_enum,
    features features_enum[] NOT NULL,
    subtitle_languages language_enum[] NOT NULL,
    video_resolution VARCHAR(6),
    FOREIGN KEY (title_group_id) REFERENCES title_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE torrent_request_votes(
    id BIGSERIAL PRIMARY KEY,
    torrent_request_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    created_by_id BIGINT NOT NULL,
    bounty_upload BIGINT NOT NULL DEFAULT 0,
    bounty_bonus_points BIGINT NOT NULL DEFAULT 0,
    FOREIGN KEY (torrent_request_id) REFERENCES torrent_requests(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by_id) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE torrent_reports (
    id BIGSERIAL PRIMARY KEY,
    reported_at TIMESTAMP NOT NULL DEFAULT NOW(),
    reported_by_id BIGINT NOT NULL,
    description TEXT NOT NULL,
    reported_torrent_id BIGINT NOT NULL,
    FOREIGN KEY (reported_by_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (reported_torrent_id) REFERENCES torrents(id) ON DELETE CASCADE
);
CREATE TABLE title_group_subscriptions (
    id BIGSERIAL PRIMARY KEY,
    title_group_id BIGINT NOT NULL,
    subscribed_at TIMESTAMP NOT NULL DEFAULT NOW(),
    subscriber_id BIGINT NOT NULL,
    FOREIGN KEY (title_group_id) REFERENCES title_groups(id) ON DELETE CASCADE,
    FOREIGN KEY (subscriber_id) REFERENCES users(id) ON DELETE SET NULL,
    UNIQUE (title_group_id, subscriber_id)
);
CREATE TYPE notification_item_enum AS ENUM (
    'TitleGroup',
    'Artist', 
    'Collage'
);
CREATE TABLE notifications (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    receiver BIGINT NOT NULL,
    title TEXT NOT NULL,
    message TEXT NOT NULL,
    notification_type notification_item_enum NOT NULL,
    item_id BIGINT,
    read_status BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (receiver) REFERENCES users(id) ON DELETE CASCADE
);
CREATE TABLE peers (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id BIGINT,
    torrent_id BIGINT NOT NULL,
    peer_id BYTEA NOT NULL,
    ip INET NOT NULL,
    port INTEGER NOT NULL,
    first_seen_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_seen_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    real_uploaded BIGINT NOT NULL DEFAULT 0,
    real_downloaded BIGINT NOT NULL DEFAULT 0,

    PRIMARY KEY (id),

    FOREIGN KEY (torrent_id) REFERENCES torrents(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id),

    UNIQUE (torrent_id, peer_id, ip, port)
);
CREATE TABLE entities (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    pictures TEXT [],
    created_by_id BIGINT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    title_groups_amount INT NOT NULL DEFAULT 0,
    edition_groups_amount INT NOT NULL DEFAULT 0,
    torrents_amount INT NOT NULL DEFAULT 0,
    seeders_amount INT NOT NULL DEFAULT 0,
    leechers_amount INT NOT NULL DEFAULT 0,
    snatches_amount INT NOT NULL DEFAULT 0,
    FOREIGN KEY (created_by_id) REFERENCES users(id)
);
CREATE TYPE collage_category_enum AS ENUM (
    'Personal',
    'Staff Picks',
    'External',
    'Theme'
);
CREATE TYPE collage_type_enum AS ENUM (
    'Artist',
    'Entity',
    'Title'
);
CREATE TABLE collage (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    created_by_id BIGINT NOT NULL,
    name VARCHAR NOT NULL,
    covers VARCHAR NOT NULL,
    description TEXT NOT NULL,
    tags VARCHAR[] NOT NULL,
    category collage_category_enum NOT NULL,
    section collage_type_enum NOT NULL,
    FOREIGN KEY (created_by_id) REFERENCES users(id)
);
CREATE TABLE collage_title_group_entry (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    created_by_id BIGINT NOT NULL,
    title_group_id BIGINT NOT NULL,
    collage_id BIGINT NOT NULL,
    FOREIGN KEY (collage_id) REFERENCES users(id),
    FOREIGN KEY (title_group_id) REFERENCES title_groups(id),
    FOREIGN KEY (created_by_id) REFERENCES users(id)
);
CREATE TABLE collage_artist_entry (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    created_by_id BIGINT NOT NULL,
    artist_id BIGINT NOT NULL,
    collage_id BIGINT NOT NULL,
    FOREIGN KEY (artist_id) REFERENCES artists(id),
    FOREIGN KEY (collage_id) REFERENCES users(id),
    FOREIGN KEY (created_by_id) REFERENCES users(id)
);
CREATE TABLE collage_entity_entry (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    created_by_id BIGINT NOT NULL,
    entity_id BIGINT NOT NULL,
    collage_id BIGINT NOT NULL,
    FOREIGN KEY (entity_id) REFERENCES entities(id),
    FOREIGN KEY (collage_id) REFERENCES users(id),
    FOREIGN KEY (created_by_id) REFERENCES users(id)
);

-- Views

CREATE VIEW torrents_and_reports AS
SELECT
    t.id,
    t.upload_factor,
    t.download_factor,
    t.edition_group_id,
    t.created_at,
    t.updated_at,
    CASE
        WHEN t.uploaded_as_anonymous THEN NULL
        ELSE t.created_by_id
    END as created_by_id,
    t.info_hash,
    t.languages,
    t.release_name,
    t.release_group,
    t.description,
    t.file_amount_per_type,
    t.uploaded_as_anonymous,
    t.file_list,
    t.mediainfo,
    t.trumpable,
    t.staff_checked,
    t.container,
    t.size,
    t.duration,
    t.audio_codec,
    t.audio_bitrate,
    t.audio_bitrate_sampling,
    t.audio_channels,
    t.video_codec,
    t.features,
    t.subtitle_languages,
    t.video_resolution,
    CASE
        WHEN EXISTS (SELECT 1 FROM torrent_reports WHERE reported_torrent_id = t.id) THEN json_agg(row_to_json(tr))
        ELSE '[]'::json
    END AS reports
FROM
    torrents t
LEFT JOIN
    torrent_reports tr ON t.id = tr.reported_torrent_id
GROUP BY
    t.id;

CREATE OR REPLACE VIEW title_groups_and_edition_group_and_torrents_lite AS
SELECT
    tg.id AS title_group_id,
    jsonb_build_object(
        'id', tg.id,
        'name', tg.name,
        'covers', tg.covers,
        'category', tg.category,
        'content_type', tg.content_type,
        'tags', tg.tags,
        'original_release_date', tg.original_release_date
    ) || jsonb_build_object(
        'edition_groups', COALESCE((
            SELECT jsonb_agg(
                jsonb_build_object(
                    'id', eg.id,
                    'title_group_id', eg.title_group_id,
                    'name', eg.name,
                    'release_date', eg.release_date,
                    'distributor', eg.distributor,
                    'covers', eg.covers,
                    'source', eg.source,
                    'additional_information', eg.additional_information,
                    'torrents', COALESCE((
                        SELECT jsonb_agg(
                            jsonb_build_object(
                                'id', t.id,
                                'upload_factor', t.upload_factor,
                                'download_factor', t.download_factor,
                                'edition_group_id', t.edition_group_id,
                                'created_at', t.created_at,
                                'release_name', t.release_name,
                                'release_group', t.release_group,
                                'file_amount_per_type', t.file_amount_per_type,
                                'trumpable', t.trumpable,
                                'staff_checked', t.staff_checked,
                                'languages', t.languages,
                                'container', t.container,
                                'size', t.size,
                                'duration', t.duration,
                                'audio_codec', t.audio_codec,
                                'audio_bitrate', t.audio_bitrate,
                                'audio_bitrate_sampling', t.audio_bitrate_sampling,
                                'audio_channels', t.audio_channels,
                                'video_codec', t.video_codec,
                                'features', t.features,
                                'subtitle_languages', t.subtitle_languages,
                                'video_resolution', t.video_resolution,
                                'reports', t.reports
                            )
                        )
                        FROM torrents_and_reports t
                        WHERE t.edition_group_id = eg.id
                    ), '[]'::jsonb)
                )
            )
            FROM edition_groups eg
            WHERE eg.title_group_id = tg.id
        ), '[]'::jsonb)
    ) AS title_group_data
FROM title_groups tg;