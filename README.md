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
