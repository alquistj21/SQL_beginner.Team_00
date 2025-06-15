CREATE TABLE routes (point1 CHAR(1), point2 CHAR(1), cost INT); 
INSERT INTO routes (point1, point2, cost)
VALUES ('a', 'b', 10),
       ('b', 'a', 10),
       ('a', 'd', 20),
       ('d', 'a', 20),
       ('a', 'c', 15),
       ('c', 'a', 15),
       ('b', 'd', 25),
       ('d', 'b', 25),
       ('c', 'd', 30),
       ('d', 'c', 30),
       ('b', 'c', 35),
       ('c', 'b', 35);
WITH recursive nodes AS (
SELECT CONCAT('{', point1) AS tour, point1, point2, cost
FROM routes
WHERE point1 = 'a'
UNION ALL
SELECT CONCAT(nodes.tour, ',', routes.point1) AS tour, routes.point1, routes.point2, nodes.cost + routes.cost
FROM nodes
JOIN routes ON nodes.point2 = routes.point1
WHERE tour NOT LIKE CONCAT('%', routes.point1, '%')
)
SELECT cost AS total_cost, CONCAT(tour, ',', point2, '}') AS tour
FROM nodes
WHERE point2 = 'a' AND LENGTH(tour) = (SELECT MAX(LENGTH(tour)) FROM nodes)
AND cost = (SELECT MIN(cost) FROM nodes WHERE point2 = 'a' AND LENGTH(tour) = (SELECT MAX(LENGTH(tour)) FROM nodes))
ORDER BY total_cost, tour;