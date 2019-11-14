with b as (
SELECT "Minutes5UTC", date_trunc('hour', "Minutes5UTC") as hourutc, date_trunc('hour', "Minutes5DK") as hourdk, "PriceArea", "CO2Emission"
  FROM "d856694b-5e0e-463b-acc4-d9d7d895128a" 
  WHERE "PriceArea" = 'DK1' 
    AND "Minutes5UTC" >= (current_timestamp at time zone 'UTC') 
    AND "Minutes5UTC" < ((current_timestamp at time zone 'UTC') + INTERVAL '6 hours')       
)
, a as (
select hourutc, CAST(AVG("CO2Emission") as INTEGER) AS CO2
 from b
 GROUP BY hourutc 
 ORDER BY hourutc ASC LIMIT 6
)
select distinct to_char(b.hourDK, 'HH24:MI') as "Minutes5DK", b."PriceArea", b.hourDK, a.CO2 as "CO2Emission" from a
inner join b on a.hourutc = b.hourutc
order by b.hourDK ASC limit 6