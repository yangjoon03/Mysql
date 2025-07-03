<details>
<summary><h2>Json으로 "," 태그 추출하기</h2></summary>

### 간단 요약  
JSON 형태로 변환하여 태그를 분리 후 삽입하는 과정입니다.

---

1. **movie 테이블을 `t`라는 별칭으로 불러옴**  
   영화의 고유 ID(`movie_id`)와 장르 문자열(`genres`)을 다룹니다.

2. **CONCAT + REPLACE로 `genres` 문자열을 JSON 배열 문자열로 변환**  
   예: `t.genres`가 `"Action,Comedy,Drama"`라면,  
   - 먼저 쌍따옴표 제거 → `Action,Comedy,Drama`  
   - 쉼표(,)를 `","`로 치환 → `Action","Comedy","Drama`  
   - 앞뒤로 `["` 와 `"]` 붙여서 → `["Action","Comedy","Drama"]`

3. **JSON_TABLE 함수로 JSON 배열을 테이블 형태로 변환**  
   `["Action","Comedy","Drama"]` → 3개의 행으로 분리되며,  
   각 행의 `tag` 컬럼에 각각 `Action`, `Comedy`, `Drama`가 들어있음

4. **JOIN JSON_TABLE(...) AS jt ON TRUE**  
   영화 한 행과 JSON 배열에서 분리된 장르 행들을 연결하여  
   영화 1개가 장르 여러 개로 확장된 여러 행이 만들어짐

5. **JOIN tags tg ON tg.name = TRIM(jt.tag)**  
   `tags` 테이블에서 이름(`name`)이 `jt.tag`와 일치하는 태그를 찾음  
   (공백 제거 후 정확히 비교)

6. **SELECT t.movie_id, tg.id AS tag_id**  
   각 영화와 매칭된 태그의 ID를 선택함

7. **INSERT IGNORE INTO item_tags (item_id, tag_id)**  
   선택된 `(movie_id, tag_id)` 쌍을 `item_tags` 테이블에 삽입  
   (중복 시 오류 없이 무시)

8. **WHERE t.genres IS NOT NULL AND t.genres != ''**  
   장르 정보가 없는 행(`NULL` 또는 빈 문자열)은 제외

</details>


<details>
<summary><h2>1.JOIN</h2></summary>


### employees 테이블
| emp_id | name | dept_id | manager_id |
|--------|------|---------|------------|
| 1 | 김철수 | 1 | 3 |
| 2 | 이영희 | 2 | 3 |
| 3 | 박부장 | 1 | NULL |
| 4 | 최민수 | 3 | 3 |
| 5 | 정수진 | NULL | 3 |

### departments 테이블
| dept_id | dept_name |
|---------|-----------|
| 1 | 개발팀 |
| 2 | 마케팅팀 |
| 3 | 영업팀 |
| 4 | 인사팀 |

---

## JOIN 결과

### 1. INNER JOIN
양쪽 테이블에 모두 존재하는 데이터만 조회
```sql
SELECT e.name, d.dept_name
FROM employees e
INNER JOIN departments d ON e.dept_id = d.dept_id;
```

| name | dept_name |
|------|-----------|
| 김철수 | 개발팀 |
| 이영희 | 마케팅팀 |
| 박부장 | 개발팀 |
| 최민수 | 영업팀 |

### 2. LEFT JOIN
왼쪽 테이블(employees)의 모든 데이터를 포함
```sql
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id;
```

| name | dept_name |
|------|-----------|
| 김철수 | 개발팀 |
| 이영희 | 마케팅팀 |
| 박부장 | 개발팀 |
| 최민수 | 영업팀 |
| 정수진 | NULL |

### 3. RIGHT JOIN
오른쪽 테이블(departments)의 모든 데이터를 포함
```sql
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

| name | dept_name |
|------|-----------|
| 김철수 | 개발팀 |
| 박부장 | 개발팀 |
| 이영희 | 마케팅팀 |
| 최민수 | 영업팀 |
| NULL | 인사팀 |

### 4. FULL OUTER JOIN (MySQL에서는 UNION 사용)
양쪽 테이블의 모든 데이터를 포함
```sql
SELECT e.name, d.dept_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
UNION
SELECT e.name, d.dept_name
FROM employees e
RIGHT JOIN departments d ON e.dept_id = d.dept_id;
```

| name | dept_name |
|------|-----------|
| 김철수 | 개발팀 |
| 이영희 | 마케팅팀 |
| 박부장 | 개발팀 |
| 최민수 | 영업팀 |
| 정수진 | NULL |
| NULL | 인사팀 |

### 5. SELF JOIN
같은 테이블 내에서 조인 (직원과 매니저 관계)
```sql
SELECT e.name AS employee, m.name AS manager
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id;
```

| employee | manager |
|----------|---------|
| 김철수 | 박부장 |
| 이영희 | 박부장 |
| 최민수 | 박부장 |
| 정수진 | 박부장 |

---

## JOIN 종류 요약

| JOIN 종류 | 설명 | 특징 |
|-----------|------|------|
| **INNER JOIN** | 양쪽 테이블에 모두 존재하는 데이터만 조회 | 교집합 |
| **LEFT JOIN** | 왼쪽 테이블의 모든 데이터 + 오른쪽 테이블의 매칭되는 데이터 | 왼쪽 테이블 기준 |
| **RIGHT JOIN** | 오른쪽 테이블의 모든 데이터 + 왼쪽 테이블의 매칭되는 데이터 | 오른쪽 테이블 기준 |
| **FULL OUTER JOIN** | 양쪽 테이블의 모든 데이터 포함 | 합집합 |
| **SELF JOIN** | 같은 테이블 내에서 자기 자신과 조인 | 계층 구조 표현 |
</details>


<br>

  
## 2.서브쿼리
* 다른 SQL문 안에 중첩된 SELECTE 문
```sql
-- 평균 나이보다 나이가 많은 사용자
SELECT name, age
FROM users
WHERE age > (
    SELECT AVG(age) FROM users
);
```
<br>


## 3.뷰
* 자주 사용하는 SELECTE 문을 가상의 테이블 처럼 저장
### 뷰 만들기
```sql
-- 나이별 사용자 수를 계산하는 뷰 생성
CREATE VIEW age_count_view AS
SELECT age, COUNT(*) AS count
FROM users
GROUP BY age;
```
### 뷰 사용하기
```sql
-- 뷰를 테이블처럼 사용
SELECT * FROM age_count_view WHERE count >= 2;
```
### 뷰 삭제하기
```sql
DROP VIEW age_count_view;
```



