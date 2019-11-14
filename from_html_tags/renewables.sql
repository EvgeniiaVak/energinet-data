Select cast(sum("s1"+"s2")/sum("p1"+"p2")*100 as int) as "Wind and Solar power", 
case when sum("s1"+"s2")/sum("p1"+"p2") > 1 then 0 
else cast(100-sum("s1"+"s2")/sum("p1"+"p2")*100 as int) end as "Other"
from
    (select * from
        (
            (SELECT "OffshoreWindPower" + "OnshoreWindPower" + "SolarPower" as s1, "TotalLoad" as p1, "HourUTC" as h1
            FROM electricitybalancenonv
            WHERE "SolarPower" IS NOT NULL 
                AND "PriceArea" = 'DK1') as dk1
          inner join  
            (SELECT "OffshoreWindPower" + "OnshoreWindPower" + "SolarPower" as s2, "TotalLoad" as p2, "HourUTC" as h2
            FROM electricitybalancenonv
            WHERE "SolarPower" IS NOT NULL 
                AND "PriceArea" = 'DK2') as dk2
             on h1 = h2
        ) 
 order by h1 desc limit 1 -- 1 week
    ) as detail