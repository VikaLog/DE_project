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
SELECT
    c3.name
FROM
    category c3
    INNER JOIN film_category fc3 ON c3.category_id = fc3.category_id
    INNER JOIN inventory i3 ON fc3.film_id = i3.inventory_id
    INNER JOIN rental r3 ON i3.inventory_id = r3.inventory_id
    INNER JOIN payment p3 ON p3.rental_id = r3.rental_id
GROUP BY
    c3.name
HAVING SUM(p3.amount) = (SELECT
                             MAX(cam.category_amount)
                         FROM
                             category c2
                         INNER JOIN
                                 (SELECT
                                    1.category_id
                                    ,SUM(p1.amount) AS category_amount
                                 FROM
                                    category c1
                                    INNER JOIN film_category fc1 ON c1.category_id = fc1.category_id
                                    INNER JOIN inventory i1 ON fc1.film_id = i1.inventory_id
                                    INNER JOIN rental r1 ON i1.inventory_id = r1.inventory_id
                                    INNER JOIN payment p1 ON p1.rental_id = r1.rental_id
                                 GROUP BY
                                    c1.category_id) cam ON cam.category_id = c2.category_id)
;



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
