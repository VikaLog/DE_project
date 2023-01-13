/*
 Завдання на SQL до лекції 03.
 */


/*
1.
Вивести кількість фільмів в кожній категорії.
Результат відсортувати за спаданням.
*/
SELECT
    c.name                   AS category_name
    ,COUNT(f.film_id)        AS film_count
FROM
    category                 AS c
    INNER JOIN film_category AS fc
        ON c.category_id = fc.category_id
    INNER JOIN film          AS f
        ON fc.film_id = f.film_id
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
	actor                                   AS a
	INNER JOIN film_actor                   AS fa
	    ON a.actor_id = fa.actor_id
    INNER JOIN (
                SELECT                            -- films with count of rents
                    i1.film_id
                    ,COUNT(r1.rental_date)  AS films_count
                FROM
                    inventory               AS i1
                    INNER JOIN rental       AS r1
                        ON i1.inventory_id = r1.inventory_id
                GROUP BY
                    i1.film_id
                )                           AS f_top
        ON f_top.film_id = fa.film_id
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
    c3.name                  AS film_category
FROM
    category                 AS c3
    INNER JOIN film_category AS fc3
        ON c3.category_id = fc3.category_id
    INNER JOIN inventory     AS i3
        ON fc3.film_id = i3.inventory_id
    INNER JOIN rental        AS r3
        ON i3.inventory_id = r3.inventory_id
    INNER JOIN payment       AS p3
        ON p3.rental_id = r3.rental_id
GROUP BY
    c3.name
HAVING SUM(p3.amount) = (
                         SELECT              -- select max amount of category
                             MAX(cam.category_amount)        AS max_category_amount
                         FROM
                             category                        AS c2
                         INNER JOIN
                                 (
                                 SELECT      -- categories with their amounts
                                    c1.category_id
                                    ,SUM(p1.amount)          AS category_amount
                                 FROM
                                    category                 AS c1
                                    INNER JOIN film_category AS fc1
                                        ON c1.category_id = fc1.category_id
                                    INNER JOIN inventory     AS i1
                                        ON fc1.film_id = i1.inventory_id
                                    INNER JOIN rental        AS r1
                                        ON i1.inventory_id = r1.inventory_id
                                    INNER JOIN payment       AS p1
                                        ON p1.rental_id = r1.rental_id
                                 GROUP BY
                                    c1.category_id
                                 )                           AS cam
                                     ON cam.category_id = c2.category_id
                         )
;



/*
4.
Вивести назви фільмів, яких не має в inventory.
Запит має бути без оператора IN
*/
SELECT
    f.title
FROM film               AS f
    LEFT JOIN inventory AS i
        ON f.film_id = i.film_id
WHERE i.inventory_id IS NULL
;


/*
5.
Вивести топ 3 актори, які найбільше зʼявлялись в категорії фільмів “Children”.
*/
SELECT
	CONCAT(a.last_name, ', ', a.first_name) AS actors
FROM
	actor                                   AS a
	INNER JOIN film_actor                   AS fa
	    ON a.actor_id = fa.actor_id
    INNER JOIN film_category                AS fc
        ON fc.film_id = fa.film_id
    INNER JOIN category                     AS c
        ON c.category_id = fc.category_id
    INNER JOIN film                         AS f
        ON f.film_id = fa.film_id
WHERE
    c.name = 'Children'
GROUP BY
    actors
ORDER BY COUNT(f.film_id) DESC
LIMIT 3
;
