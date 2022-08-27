INSERT INTO HubCity (CityHashKey, LoadDate, RecordSource, LastSeen, CityCode)
SELECT DISTINCT MD5(CityCode), LoadDate, RecordSource, LoadDate, CityCode
FROM HubCityStaging
WHERE CityCode NOT IN (SELECT CityCode FROM HubCity);

UPDATE HubCity, HubCityStaging
SET HubCity.LastSeen = HubCityStaging.LoadDate
WHERE HubCity.CityCode = HubCityStaging.CityCode;
