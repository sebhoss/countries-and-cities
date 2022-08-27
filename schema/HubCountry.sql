CREATE TABLE IF NOT EXISTS HubCountry
(
    CountryHashKey VARCHAR(32),
    LoadDate       DATETIME NOT NULL,
    RecordSource   VARCHAR(255) NOT NULL,
    LastSeen       DATETIME NOT NULL,
    CountryCode    VARCHAR(2) UNIQUE NOT NULL COMMENT 'ISO 3166-1 alpha-2',
    PRIMARY KEY (CountryHashKey)
);
