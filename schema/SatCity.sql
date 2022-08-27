CREATE TABLE IF NOT EXISTS SatCity
(
    CityHashKey  VARCHAR(32),
    LoadDate     DATETIME NOT NULL,
    LoadEndDate  DATETIME NOT NULL,
    RecordSource VARCHAR(255) NOT NULL,
    CityName     VARCHAR(255) NOT NULL,
    PRIMARY KEY (CityHashKey, LoadDate)
);
