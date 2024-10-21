#Jaki był najpopularniejszy temat w każdej dekadzie?
#What was the most popular product topic per decade?

with
Themecount as
(
	SELECT 
	     	(FLOOR(year/10)* 10)+10 AS dekada
	    	,theme
	    	,COUNT(*) AS theme_count	    	
		FROM lego
	GROUP BY dekada,theme
)
select 
	 dekada
    ,theme
    ,theme_count
    from Themecount
    where (dekada,theme_count) in 
    (
   	 	select dekada,max(theme_count)
   		from Themecount
      	GROUP BY dekada
    );



#checking if counts correctly for a given topic
#sprawdzenie czy liczy dobrze dla danego teamtu
WITH prod AS (
  SELECT 
    year, 
    COUNT(theme) AS prod
  FROM lego le 
  WHERE theme = 'LEGOLAND' 
    AND year BETWEEN 1970 AND 1979
  GROUP BY year
)
SELECT year, prod, (SELECT SUM(prod) FROM prod) AS total_prod FROM prod;


#query2
#Price vs count of pieces
WITH dane AS (
    SELECT 
        set_id,
        pieces,
        minifigs,
        US_retailPrice 
    FROM 
        lego 
    WHERE 
        US_retailPrice > 0 AND (pieces > 0 OR minifigs > 0)
),
per_pie AS (
    SELECT 
        set_id,
        ROUND((pieces / US_retailPrice), 2) AS pieces_per_price
    FROM 
        dane
),
avg_price as
(
select round(avg(Us_retailPrice),2) as avg_price from dane
)
SELECT 
    d.set_id 				as id
    ,d.pieces				as pieces
    ,d.minifigs 	 		as minifigs
    ,d.US_retailPrice 		as US_Price
    ,ap.avg_price 			as avg_price
    ,pp.pieces_per_price
FROM 
    dane d
LEFT JOIN 
    per_pie pp ON d.set_id = pp.set_id
cross join 
    avg_price ap

    

