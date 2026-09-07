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

rainfall = FOREACH rain
GENERATE
    station,
    date,
    (double)value / 10.0 AS rainfall_mm;

ordered = ORDER rainfall BY rainfall_mm DESC;

result = LIMIT ordered 10;

DUMP result;

STORE result
INTO '/weather/output/Top10RainiestDays'
USING PigStorage(',');