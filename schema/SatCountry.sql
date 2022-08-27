CREATE TABLE IF NOT EXISTS SatCountry
(
    CountryHashKey VARCHAR(32),
    LoadDate       DATETIME NOT NULL,
    LoadEndDate    DATETIME NOT NULL,
    RecordSource   VARCHAR(255) NOT NULL,
    CountryName    VARCHAR(255) NOT NULL,
    PRIMARY KEY (CountryHashKey, LoadDate)
);
