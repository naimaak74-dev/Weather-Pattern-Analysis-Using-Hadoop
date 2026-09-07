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

hot = FILTER weather BY element == 'TMAX'
                   AND value != -9999
                   AND value >= 350;

result = FOREACH hot
GENERATE
    station,
    date,
    (double)value / 10.0 AS temperature;

DUMP result;

STORE result
INTO '/weather/output/ExtremeHotDays'
USING PigStorage(',');
