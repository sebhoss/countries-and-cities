CREATE TABLE cities
(
    id      SERIAL,
    name    VARCHAR(255),
    country BIGINT,
    PRIMARY KEY (id),
    FOREIGN KEY (country) REFERENCES countries (id)
);

