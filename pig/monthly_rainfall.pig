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

rain = FILTER weather BY element == 'PRCP'
                    AND value != -9999;

monthly = FOREACH rain
GENERATE
    SUBSTRING(date,4,6) AS month,
    (double)value / 10.0 AS rainfall_mm;

grouped = GROUP monthly BY month;

result = FOREACH grouped
GENERATE
    group AS month,
    SUM(monthly.rainfall_mm) AS total_rainfall;

ordered = ORDER result BY month ASC;

DUMP ordered;

STORE ordered
INTO '/weather/output/monthly_rainfall'
USING PigStorage(',');