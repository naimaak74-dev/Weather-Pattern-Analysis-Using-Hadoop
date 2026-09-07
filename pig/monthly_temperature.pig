weather = LOAD '/weather/input/2020.csv.gz'
USING PigStorage(',')
AS (
    station:chararray,
    date:chararray,
    element:chararray,
    value:int,
    mflag:chararray,
    qflag:chararray,
    sflag:chararray,
    obstime:chararray
);

tmax = FILTER weather BY element == 'TMAX'
                    AND value != -9999;

monthly = FOREACH tmax
GENERATE
    SUBSTRING(date,4,6) AS month,
    (double)value / 10.0 AS temperature;

grouped = GROUP monthly BY month;

result = FOREACH grouped
GENERATE
    group AS month,
    AVG(monthly.temperature) AS average_temperature;

ordered = ORDER result BY month ASC;

DUMP ordered;

STORE ordered
INTO '/weather/output/monthly_temperature'
USING PigStorage(',');