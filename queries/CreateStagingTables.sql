CREATE TABLE IF NOT EXISTS HubCountryStaging
(
    LoadDate       DATETIME,
    RecordSource   VARCHAR(255),
    CountryCode    VARCHAR(2) COMMENT 'ISO 3166-1 alpha-2'
);

CREATE TABLE IF NOT EXISTS HubCityStaging
(
    LoadDate     DATETIME,
    RecordSource VARCHAR(255),
    CityCode     VARCHAR(5) COMMENT 'UN/LOCODE'
);
