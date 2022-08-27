INSERT INTO LinkCityInCountry (CityInCountryHashKey, LoadDate, RecordSource, LastSeen, CityHashKey, CountryHashKey)
SELECT MD5(CONCAT(HubCity.CityCode, HubCountry.CountryCode)),
       HubCity.LoadDate,
       HubCity.RecordSource,
       HubCity.LastSeen,
       HubCity.CityHashKey,
       HubCountry.CountryHashKey
FROM HubCountry
         INNER JOIN HubCity
                    ON HubCity.CityCode LIKE CONCAT(HubCountry.CountryCode, '%')
WHERE HubCity.CityHashKey NOT IN (SELECT CityHashKey FROM LinkCityInCountry);

UPDATE LinkCityInCountry, HubCity
SET LinkCityInCountry.LastSeen = HubCity.LastSeen
WHERE LinkCityInCountry.CityHashKey = HubCity.CityHashKey;
