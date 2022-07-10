DELETE FROM cities WHERE country = (SELECT id FROM countries WHERE short_name = 'Deutschland');
