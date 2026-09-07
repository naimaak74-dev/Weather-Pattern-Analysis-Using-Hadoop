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

temperature = FOREACH tmax
GENERATE
    station,
    date,
    (double)value / 10.0 AS temperature;

ordered = ORDER temperature BY temperature DESC;

result = LIMIT ordered 10;

DUMP result;

STORE result
INTO '/weather/output/Top10HottestDays'
USING PigStorage(',');