-- use  kpim_retail

-- select * from city

-- select * from sub_region

-- select * from region

-- select * from store

-- select * from ward

-- select top 3 * from pos_sales_header

select top 3 * from pos_sales_line

select top 3 * from purchase_header

select top 3 * from purchase_line

select top 3 * from product_sku

select top 3 * from product_category


select top 3 * from product_subcategory

-- select code from city
-- where city.name = N'Thái Bình'

-- select count(name) from city
-- where city.name like N'Quảng%'

-- select count(distinct city.name) from city
-- join sub_region on city.sub_region_id = sub_region.id
-- join region on sub_region.region_id = region.id
-- where region.name = N'Miền Trung'

-- select count(store.id) from store
-- join city on store.city_id = city.id


-- select cast((select count(city.name) from sub_region
-- join city on sub_region.id = city.sub_region_id
-- where sub_region.name like N'Đồng bằng sông Hồng' or sub_region.name like N'Đồng bằng sông Cửu Long') as float) / cast((select count(city.name) from city) as float) *100

-- select top 1 district.name from district
-- join store on district.id = store.district_id
-- join city on city.id = store.city_id
-- group by district.id, city.id, district.name
-- order by count(store.id) desc

-- select ward.id from ward
-- join store on store.ward_id = ward.id
-- where ward.city_id = 24
-- group by ward.id
-- having count(store.ward_id) >= 10

-- select top 1 district.name from district
-- join city on city.id = district.city_id
-- join store on store.district_id = district.id
-- where city.name = N'Hà Nội'
-- group by district.id, district.name
-- order by cast(count(distinct store.id) as float) / cast(count(distinct store.ward_id) as float) desc

-- select top 3 store.code, dbo.fnc_calc_haversine_distance(store.latitude, store.longitude,
--                                                         (select store.latitude from store where code = 'VMHNI60'),
--                                                         (select store.longitude from store where code = 'VMHNI60'))
--                                                         from store
-- where store.code != 'VMHNI60'
--                 order by  dbo.fnc_calc_haversine_distance(store.latitude, store.longitude,
--                                                         (select store.latitude from store where code = 'VMHNI60'),
--                                                         (select store.longitude from store where code = 'VMHNI60'))



-- select region.code, region.name, sub_region.code, sub_region.name,city.id,city.name, city.code from city
-- join sub_region on city.sub_region_id = sub_region.id
-- join region on region.id = sub_region.region_id
-- where region.name = N'Miền Bắc'
-- order by region.name, city.name, sub_region.name

-- select customer.id, customer.code, customer.full_name, customer.first_name, sum(pos_sales_header.total_amount) from customer
-- join pos_sales_header on customer.id = pos_sales_header.customer_id
-- join store on store.id = pos_sales_header.store_id
-- where pos_sales_header.transaction_date between '2020-10-01' and '2020-10-20' and store.district_id =  1
-- group by customer.id, customer.code, customer.full_name, customer.first_name
-- having sum(pos_sales_header.total_amount) >= 10000000
-- order by sum(pos_sales_header.total_amount) desc, customer.first_name


-- select pos_sales_header.document_code,
--         store.id,
--         store.code,
--         store.name,
--         pos_sales_header.transaction_date,
--         pos_sales_header.customer_id,
--         customer.full_name,
--         pos_sales_header.total_amount,
--         case
--             when (pos_sales_header.total_amount / 2) >= 1000000 then 1000000
--             else pos_sales_header.total_amount / 2
--         end
-- from pos_sales_header
-- join store on pos_sales_header.store_id = store.id
-- join customer on pos_sales_header.customer_id = customer.id
-- where pos_sales_header.transaction_date BETWEEN '2020-08-31' and '2020-09-06'
-- and pos_sales_header.document_code in ('SO-VMHNI4-202009034389708', 'SO-VMHNI109-202008316193214', 'SO-VMHNI51-202008316193066', 'SO-VMHNI64-202008316193112', 'SO-VMHNI48-202009016193491')
-- order by store.id

-- select  product_sku_id,
--         customer_id,
--         sum(line_amount),
--         sum(quantity),
--         count(id),
--         cast(sum(quantity) as float) / cast(count(id) as float)
-- from pos_sales_line
-- where product_sku_id = 91 and year(transaction_date) =2020
-- group by product_sku_id, customer_id

-- select top 20
--         year(pos_sales_line.transaction_date),
--         product_sku.id,
--         product_sku.code,
--         product_sku.name,
--         product_sku.country,
--         product_sku.brand,
--         product_sku.price,
--         sum(pos_sales_line.quantity),
--         dense_rank () over (order by sum(pos_sales_line.quantity) desc)
-- from product_sku
-- join pos_sales_line on pos_sales_line.product_sku_id = product_sku.id
-- where year(pos_sales_line.transaction_date) in (2019, 2020) and (product_sku.name like N'%Mỳ%' or product_sku.name like N'%Mì%')
-- and product_sku.product_subcategory_id = 19
-- group by year(pos_sales_line.transaction_date),
--         product_sku.id,
--         product_sku.code,
--         product_sku.name,
--         product_sku.country,
--         product_sku.brand,
--         product_sku.price
-- order by year(pos_sales_line.transaction_date) desc, sum(pos_sales_line.quantity) DESC

-- select emp_shift_schedule.day_work,
--         emp_shift_schedule.store_id,
--         emp_shift_schedule.shift_name,
--         store.name,
--         sales_person.code,
--         sales_person.full_name,
--         sales_person.first_name,
--         sales_person.gender
-- from emp_shift_schedule
-- join store on store.id = emp_shift_schedule.store_id
-- join sales_person on sales_person.id = emp_shift_schedule.sales_person_id
-- where emp_shift_schedule.day_work = '2020-06-13' and emp_shift_schedule.shift_name = N'Chiều'
-- and store.name like N'%Cụm 6 Xã Sen Chiểu%'



-- with
-- hour_table as(
--     SELECT h.customer_id, h.store_id, s.code, s.name as store_name, cast ([transaction_date] as date) date , datepart(hour, [transaction_date]) as hour
--     from pos_sales_header as h
--     join store as s
--     on s.id = h.store_id
--     where year(transaction_date) = '2020' and month(transaction_date) >= 06
-- )
-- ,avg_cus as(
--     select store_id, code, store_name, date , hour, count(*) as nb_cus_per_day
--     from hour_table
--     group by store_id, code, store_name, date , hour
-- )
-- select store_id, code,  store_name , hour, AVG( CAST(nb_cus_per_day as float)) avg_nb_customers
-- from avg_cus as h
-- group by store_id, code,  store_name , hour
-- order by store_id, hour asc


-- WITH
-- prod_filter AS(
-- 	SELECT YEAR(transaction_date) YEAR, product_sku_id, PS.name,
-- 		 CASE
-- 		   WHEN PS.product LIKE N'%trà khô%' THEN '1'
-- 		   WHEN PS.product LIKE N'%trà túi lọc%' THEN '2'
-- 		   WHEN PS.product LIKE N'%trà hòa tan%' THEN '3'
-- 		   WHEN PS.product LIKE N'%trà chai%' THEN '4'
-- 		   END AS product_type,
-- 		   CASE
-- 		   WHEN PS.product LIKE N'%trà khô%' THEN 'Trà khô'
-- 		   WHEN PS.product LIKE N'%trà túi lọc%' THEN 'Trà túi lọc'
-- 		   WHEN PS.product LIKE N'%trà hòa tan%' THEN 'Trà hòa tan'
-- 		   WHEN PS.product LIKE N'%trà chai%' THEN 'Trà chai'
-- 		   END AS product_type_name,
-- 		   SUM(line_amount) AS prod_filter
-- 	FROM pos_sales_line pl
-- 	JOIN product_sku ps
-- 	ON pl.product_sku_id = ps.id
-- 	WHERE product_subcategory_id = 27
-- 	GROUP BY YEAR(transaction_date),product_sku_id, PS.name ,PS.product
-- )
-- , prod_type AS (
-- SELECT year, product_type,product_type_name ,
-- 	   SUM(prod_filter) AS prod_type
-- FROM prod_filter
-- GROUP BY YEAR, product_type,product_type_name
-- )
-- , prod_sales_year AS (
-- 	SELECT YEAR(transaction_date) YEAR,
-- 		   SUM(line_amount) AS prod_sales_year
-- 	FROM pos_sales_line PL
-- 	JOIN product_sku PS ON PL.product_sku_id =PS.id
-- 	WHERE product_subcategory_id = 27
-- 	GROUP BY YEAR(transaction_date)
-- )

-- SELECT A.YEAR AS year, A.product_type, A.product_type_name, A.prod_type AS sales_amount_ht, B.prod_sales_year AS sales_amount, prod_type/ prod_sales_year AS ratio
-- FROM prod_type A
-- JOIN prod_sales_year B
-- ON A.YEAR =B.YEAR
-- WHERE A.product_type =3 AND (A.YEAR = 2018 OR A.YEAR=2019 OR A.YEAR=2020)
-- ORDER BY year;


-- select top 3 store.id, store.code, store.name, sum(pos_sales_header.total_amount) from pos_sales_header
-- join store on store.id = pos_sales_header.store_id
-- where year(pos_sales_header.transaction_date) = '2020' and month(pos_sales_header.transaction_date) = 10 and store.city_id = 24
-- group by store.id, store.code, store.name
-- order by sum(pos_sales_header.total_amount) desc

-- with prod_sales as (
-- 	select
-- 		YEAR(pos_sales_line.transaction_date) as year
-- 		pos_sales_line.product_sku_id
-- 		sum(line_amount) as total_sales
-- 		ROW_NUMBER() over (order by SUM(line_amount) desc) as num
-- 	from product_sku
-- 	inner join pos_sales_line
-- 	on pos_sales_line.product_sku_id = product_sku.id
-- 	where year(product_sku.transaction_date) = '2020'
-- 	group by year(product_sku.transaction_date), pos_sales_line.product_sku_id
-- ),
-- total_sales as(
-- 	select sum(line_amount) as total, year(transaction_date) as year
-- 	from pos_sales_line
-- 	where year(transaction_date) = '2020'
-- 	group by year(transaction_date)
-- ),
-- perc AS (
-- SELECT prod_sales.*, total_sales/total AS perc
-- FROM prod_sales AS pro
-- JOIN total_sales AS t
-- ON pro.year = t.year
-- ),

-- prod_cummulative as (
-- 	select * sum(perc) over (order by num) as cummulative
-- 	from perc
-- )
-- SELECT *,
-- CASE
-- WHEN cummulative <= 0.7 THEN 'A'
-- WHEN cummulative <= 0.9 THEN 'B'
-- ELSE 'C'
-- END AS type
-- FROM prod_cummulative
-- ORDER BY product_sku_id, num


-- WITH ProductSales as
-- (
-- 	-- Get the total for each Product Model and Year
-- 	SELECT
-- 		YEAR(pos_sales_line.[transaction_date]) AS year,
-- 		pos_sales_line.[product_sku_id] as Product,
-- 		SUM(pos_sales_line.[line_amount]) Sales
-- 	FROM [pos_sales_line]
-- 		INNER JOIN [product_sku]
-- 		ON pos_sales_line.[product_sku_id] = product_sku.[id]
-- 	where year(pos_sales_line.[transaction_date]) = '2020'
-- 	GROUP BY
-- 		year(pos_sales_line.[transaction_date]),
-- 		pos_sales_line.[product_sku_id]
-- )


-- select
-- 	ProductSales.[year],
-- 	sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year] order by ProductSales.[Sales] desc) as CummulativeSales,
-- 	sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year]) as TotalSales,
-- 	sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year] order by ProductSales.[Sales] desc)  / sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year]) as CumulativePercentage,
-- 	case
-- 		when sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year] order by ProductSales.[Sales] desc)  /
-- 		sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year]) <= 0.7
-- 			then 'A'

-- 		when sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year] order by ProductSales.[Sales] desc) /
-- 		sum(ProductSales.[Sales]) over (PARTITION by ProductSales.[year]) <= 0.9
-- 			then 'B'

-- 		else 'C'
-- 	end as Class
-- from ProductSales
-- group by ProductSales.[Product], ProductSales.[Sales], ProductSales.[year]
-- order by ProductSales.[Sales] desc



