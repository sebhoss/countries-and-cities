CREATE TABLE countries
(
    id            SERIAL,
    short_name    VARCHAR(255),
    long_name     VARCHAR(255),
    english_short VARCHAR(255),
    english_long  VARCHAR(255),
    german_short  VARCHAR(255),
    german_long   VARCHAR(255),
    spanish_short VARCHAR(255),
    spanish_long  VARCHAR(255),
    PRIMARY KEY (id)
);
