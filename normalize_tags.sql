/*드라마, 영화, 로맨스, 판타지
,로 구분이 되어있을 경우 mysql을 이용하여 테이블 나누기.
M:N구조로 변환*/


/*태그 목록*/
CREATE TABLE tags (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE
);

/*M:N 중간 테이블*/
CREATE TABLE item_tags (
    item_id INT,
    tag_id INT,
    PRIMARY KEY (item_id, tag_id),
    FOREIGN KEY (item_id) REFERENCES items(id),/*외래키*/
    FOREIGN KEY (tag_id) REFERENCES tags(id)
);
/*간단 설명 :같은 영화의 ID는 중복 가능, Tag는 중복 불가*/

/*Json으로 태그 추출*/
INSERT IGNORE INTO item_tags (item_id, tag_id)
SELECT
    t.movie_id,
    tg.id AS tag_id
FROM
    movie t/*실제 태그가 있는 테이블*/
    JOIN JSON_TABLE(
        CONCAT(
            '["',REPLACE(
                REPLACE(t.genres, '"', ''),
                ',', '","'
            ),
            '"]'
        ),
        '$[*]' COLUMNS (tag VARCHAR(255) PATH '$')
    ) AS jt
    ON TRUE
    JOIN tags tg ON tg.name = TRIM(jt.tag)
WHERE
    t.genres IS NOT NULL AND t.genres != '';

/*CONCAT('Hello', ' ', 'World') > Hello World*/
/*SELECT REPLACE('apple,banana,grape', ',', '|') > 'apple|banana|grape'  ;
첫 번째 인자: 원본 문자열
두 번째 인자: 바꾸고 싶은 대상 문자열(찾을 텍스트)
세 번째 인자: 바꿀 문자열(대체할 텍스트)*/
