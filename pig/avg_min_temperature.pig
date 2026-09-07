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

temp = FOREACH tmin
GENERATE
    (double)value / 10.0 AS tmin_c;

grouped = GROUP temp ALL;

result = FOREACH grouped
GENERATE
    AVG(temp.tmin_c) AS average_min_temperature;

DUMP result;

STORE result
INTO '/weather/output/avg_min_temperature'
USING PigStorage(',');