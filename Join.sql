/*조인 종류
INNER JOIN : 양쪽에 모두 존재하는 데이터
LEFT JOIN : A,B 테이블 존재 A에다가 B를 추가,합침(본인 이해용)
RIGHT JOIN : 위에의 반
FULL OUTER JOIN : LEFT, RIGHT 합침
SELF JOIN : 자기 자신과 조인 */


--INNER JOIN
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;

--LEFT JOIN
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;

--RIGHT JOIN
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

--FULL OUTER JOIN(Mysql에서는 UNION)
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id

UNION

SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

--SELF JOIN
SELECT e.name AS employee, m.name AS manager
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id;
