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

monthly = FOREACH hot
GENERATE
    SUBSTRING(date,4,6) AS month;

grouped = GROUP monthly BY month;

result = FOREACH grouped
GENERATE
    group AS month,
    COUNT(monthly) AS extreme_hot_records;

ordered = ORDER result BY month ASC;

DUMP ordered;

STORE ordered
INTO '/weather/output/MonthlyExtremeHot'
USING PigStorage(',');