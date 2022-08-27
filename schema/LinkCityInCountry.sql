CREATE TABLE IF NOT EXISTS LinkCityInCountry
(
    CityInCountryHashKey VARCHAR(32),
    LoadDate             DATETIME NOT NULL,
    RecordSource         VARCHAR(255) NOT NULL,
    LastSeen             DATETIME NOT NULL,
    CityHashKey          VARCHAR(32) UNIQUE,
    CountryHashKey       VARCHAR(32),
    PRIMARY KEY (CityInCountryHashKey),
    FOREIGN KEY (CityHashKey) REFERENCES HubCity (CityHashKey),
    FOREIGN KEY (CountryHashKey) REFERENCES HubCountry (CountryHashKey)
);
