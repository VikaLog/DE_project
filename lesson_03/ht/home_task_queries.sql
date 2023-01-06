/*
 Завдання на SQL до лекції 03.
 */


/*
1.
Вивести кількість фільмів в кожній категорії.
Результат відсортувати за спаданням.
*/
SELECT
    c.name AS category_name
    ,COUNT(f.film_id) AS film_count
FROM
    category c
    INNER JOIN film_category fc ON c.category_id = fc.category_id
    INNER JOIN film f ON fc.film_id = f.film_id
GROUP BY
    c.name
ORDER BY
    COUNT(f.film_id) DESC
;


/*
2.
Вивести 10 акторів, чиї фільми брали на прокат найбільше.
Результат відсортувати за спаданням.
*/

SELECT
	CONCAT(a.last_name, ', ', a.first_name) AS actors
FROM
	actor a
	INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
    INNER JOIN (SELECT
                    i1.film_id
                    ,COUNT(r1.rental_date) AS films_count
                FROM
                    inventory i1
                    INNER JOIN rental r1 ON i1.inventory_id = r1.inventory_id
                GROUP BY
                    i1.film_id
                ) f_top ON f_top.film_id = fa.film_id
ORDER BY
	f_top.films_count DESC
LIMIT 10
;



/*
3.
Вивести категорія фільмів, на яку було витрачено найбільше грошей
в прокаті
*/
-- SQL code goes here...



/*
4.
Вивести назви фільмів, яких не має в inventory.
Запит має бути без оператора IN
*/
-- SQL code goes here...


/*
5.
Вивести топ 3 актори, які найбільше зʼявлялись в категорії фільмів “Children”.
*/
-- SQL code goes here...
