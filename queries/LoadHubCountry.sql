INSERT INTO HubCountry (CountryHashKey, LoadDate, RecordSource, LastSeen, CountryCode)
SELECT DISTINCT MD5(CountryCode), LoadDate, RecordSource, LoadDate, CountryCode
FROM HubCountryStaging
WHERE CountryCode NOT IN (SELECT CountryCode FROM HubCountry);

UPDATE HubCountry, HubCountryStaging
SET HubCountry.LastSeen = HubCountryStaging.LoadDate
WHERE HubCountry.CountryCode = HubCountryStaging.CountryCode;
