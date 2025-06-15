WITH recursive nodes AS (
SELECT CONCAT ('{', point1) AS tour, point1, point2, cost
FROM routes
WHERE point1 = 'a'
UNION ALL
SELECT CONCAT (nodes.tour, ',', routes.point1) AS tour, routes.point1, routes.point2, nodes.cost + routes.cost
FROM nodes
JOIN routes ON nodes.point2 = routes.point1
WHERE tour NOT LIKE CONCAT ('%', routes.point1, '%'))
SELECT cost AS total_cost, CONCAT (tour, ',', point2, '}') as tour
FROM nodes
WHERE point2 = 'a' AND LENGTH (tour) = (SELECT MAX(LENGTH(tour))
FROM nodes)
ORDER BY total_cost, tour;