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

tmin = FILTER weather BY element == 'TMIN'
                    AND value != -9999;

temperature = FOREACH tmin
GENERATE
    station,
    date,
    (double)value / 10.0 AS temperature;

ordered = ORDER temperature BY temperature ASC;

result = LIMIT ordered 10;

DUMP result;

STORE result
INTO '/weather/output/Top10ColdestDays'
USING PigStorage(',');