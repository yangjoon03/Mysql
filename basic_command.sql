/*mysql 기본 명령어 모음
CREATE : 만들기
INSERT INTO : 데이터 삽입
SELECT : 데이터 조회
WHERE : 조건
UPDATE : 데이터 수정
DELETE : 데이터 삭
JOIN : 테이블 간 연결
ORDER BY ASC or DESC : 오름차순,내림차순 정렬
DISTINCT : 중복 제거
COUNT(*) : 개수
AVG(*) : 평균
MAX(*) : 최대 값
MIN(*) : 최소 값
GROUP BY : 그룹
HAVING : 그룹 조건
LIMIT : 조회 개수 제한
OFFSET : N칸 이후
BETWEEN : 범위 조건
IN : 여러 값 중 하나
LIKE : 문자열 검색 %, _
AS : 별칭
*/

--테이블 만들기
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT
);

--데이터 삽입
INSERT INTO users (id, name, age)
VALUES (1, '홍길동', 30);

--조건
SELECT * FROM users WHERE age > 25;

--데이터 수정
UPDATE users SET age = 31 WHERE id = 1;

--데이터 삭제
DELETE FROM users WHERE id = 1;

--테이블 간 연결
SELECT *
FROM orders
JOIN customers ON orders.customer_id = customers.id;

--정렬
--나이를 기준으로 오름차순 정렬
SELECT * FROM users ORDER BY age ASC;
--나이를 기준으로 내림차순 정렬
SELECT * FROM users ORDER BY age DESC;

--중복제거
SELECT DISTINCT name FROM users;

--COUNT, AVG, MAX, MIN
SELECT COUNT(*) FROM users;
SELECT AVG(age) FROM users;
SELECT MAX(age) FROM users;
SELECT MIN(age) FROM users;

--그룹
SELECT age, COUNT(*) 
FROM users
GROUP BY age;
/*설명 : 나이대 별로 몇명이 있는지*/

--그룹 조건
SELECT age, COUNT(*) 
FROM users
GROUP BY age
HAVING COUNT(*) >= 2;
/*설명 " 나이별로 2명 이상 있는 그룹만 출력*/

--조회 개수
SELECT * FROM users LIMIT 5;

--LIMIT
SELECT * FROM users OFFSET 5;

--BETWEEN
SELECT * FROM users WHERE age BETWEEN 20 AND 30; -- 범위 조건

--IN
SELECT * FROM users WHERE age IN (20, 25, 30); -- 여러 값 중 하나

--LIKE
SELECT * FROM users WHERE name LIKE '김%';    -- '김'으로 시작
SELECT * FROM users WHERE name LIKE '%수';    -- '수'로 끝남
SELECT * FROM users WHERE name LIKE '_길동';  -- 한 글자 + 길동

--AS : 별칭
SELECT name AS 이름, age AS 나이 FROM users;
-- 나이 * 12 값을 '월 나이'로 표시
SELECT name, age * 12 AS 월_나이 FROM users;


--서브쿼리 : WHERE
SELECT name, age
FROM users
WHERE age > (
    SELECT AVG(age) FROM users
);
/*설명 : 평균 나이보다 나이가 많은 사용자*/

--서브쿼리 : SELECT
SELECT name, age,
       (SELECT AVG(age) FROM users) AS avg_age
FROM users;
/*설명 : 각 사용자의 이름과 전체 평균 나이를 같이 보기*/

--서브쿼리 : FROM
SELECT age_group.age, age_group.count
FROM (
    SELECT age, COUNT(*) AS count
    FROM users
    GROUP BY age
) AS age_group
WHERE age_group.count >= 2;
/*설명 : 나이별 사용자 수를 세고, 그 결과를 기준으로 다시 조회*/

--뷰 만들기
CREATE VIEW age_count_view AS
SELECT age, COUNT(*) AS count
FROM users
GROUP BY age;
/*설명 : 나이별 사용자 수를 계산하는 뷰 생성*/

--뷰 사용
SELECT * FROM age_count_view WHERE count >= 2;

--뷰 삭제
DROP VIEW age_count_view;


