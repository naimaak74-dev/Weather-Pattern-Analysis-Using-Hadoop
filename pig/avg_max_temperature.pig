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

temp = FOREACH tmax
GENERATE
    station,
    date,
    (double)value / 10.0 AS tmax_c;

grouped = GROUP temp ALL;

result = FOREACH grouped
GENERATE
    AVG(temp.tmax_c) AS average_max_temperature;

DUMP result;

STORE result
INTO '/weather/output/avg_max_temperature'
USING PigStorage(',');