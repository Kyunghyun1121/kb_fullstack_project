-- 기존 테이블 삭제
use scoula_db;


-- 사용자 기본 정보 테이블
create table tbl_member
(
    username    varchar(50) primary key, -- 사용자 ID (기본키)
    password    varchar(128) not null,   -- 암호화된 비밀번호 (BCrypt)
    email       varchar(50)  not null,   -- 이메일 주소
    reg_date    datetime default now(),  -- 등록일시
    update_date datetime default now()   -- 수정일시
);


-- 사용자 권한 정보 테이블
create table tbl_member_auth
(
    username varchar(50) not null, -- 사용자 ID (외래키)
    auth     varchar(50) not null, -- 권한 문자열 (ROLE_ADMIN, ROLE_MANAGER, ROLE_MEMBER 등)
    primary key (username, auth),  -- 복합 기본키
    constraint fk_authorities_users foreign key (username) references tbl_member (username)
);

-- 테스트 사용자 추가 (비밀번호: 1234)
insert into tbl_member(username, password, email)
values
    ('admin',  '$2a$10$EsIMfxbJ6NuvwX7MDj4WqOYFzLU9U/lddCyn0nic5dFo3VfJYrXYC', 'admin@galapgos.org'),
    ('user0',  '$2a$10$EsIMfxbJ6NuvwX7MDj4WqOYFzLU9U/lddCyn0nic5dFo3VfJYrXYC', 'user0@galapgos.org'),
    ('user1',  '$2a$10$EsIMfxbJ6NuvwX7MDj4WqOYFzLU9U/lddCyn0nic5dFo3VfJYrXYC', 'user1@galapgos.org'),
    ('user2',  '$2a$10$EsIMfxbJ6NuvwX7MDj4WqOYFzLU9U/lddCyn0nic5dFo3VfJYrXYC', 'user2@galapgos.org'),
    ('user3',  '$2a$10$EsIMfxbJ6NuvwX7MDj4WqOYFzLU9U/lddCyn0nic5dFo3VfJYrXYC', 'user3@galapgos.org'),
    ('user4',  '$2a$10$EsIMfxbJ6NuvwX7MDj4WqOYFzLU9U/lddCyn0nic5dFo3VfJYrXYC', 'user4@galapgos.org');


-- 권한 데이터 추가
insert into tbl_member_auth(username, auth)
values
-- ADMIN (최고관리자): 모든 권한 보유
('admin', 'ROLE_ADMIN'),
('admin', 'ROLE_MANAGER'),
('admin', 'ROLE_MEMBER'),

-- MANAGER (일반관리자): 관리자 + 일반회원 권한
('user0', 'ROLE_MANAGER'),
('user0', 'ROLE_MEMBER'),

-- MEMBER (일반회원): 기본 권한만
('user1', 'ROLE_MEMBER'),
('user2', 'ROLE_MEMBER'),
('user3', 'ROLE_MEMBER'),
('user4', 'ROLE_MEMBER');




/* 게시글 조회 + 첨부파일 조회 테스트 */
USE scoula_db;

-- 테스트용 게시글 삽입
INSERT INTO tbl_board (title, content, writer)
VALUES ('첨부 파일 테스트', '첨부파일 테스트 내용', '테스터');

-- 테스트 게시글에 샘플 첨부파일 데이터 삽입
INSERT INTO tbl_board_attachment(filename, path, content_type, size, bno)
VALUES
    ('cat1.jpg', 'c:\upload\board\cat1-1749870568385.jpg', 'image/jpeg',283580, (SELECT MAX(no) FROM tbl_board)),
    ('cat2.jpg', 'c:\upload\board\cat2-1749870568395.jpg', 'image/jpeg',166577, (SELECT MAX(no) FROM tbl_board)),
    ('cat3.jpg', 'c:\upload\board\cat3-1749870568401.jpg', 'image/jpeg',119049, (SELECT MAX(no) FROM tbl_board)),
    ('cat4.jpg', 'c:\upload\board\cat4-1749870568407.jpg', 'image/jpeg',193510, (SELECT MAX(no) FROM tbl_board)),
    ('cat5.jpg', 'c:\upload\board\cat5-1749870568412.jpg', 'image/jpeg',186751, (SELECT MAX(no) FROM tbl_board));



-- 게시글과 첨부파일을 조인하여 조회
SELECT b.*,
       a.no as ano, a.bno, a.filename, a.path,
       a.content_type, a.size, a.reg_date as a_reg_date
FROM tbl_board b
         LEFT OUTER JOIN tbl_board_attachment a ON b.no = a.bno
WHERE b.no = (SELECT MAX(no) FROM tbl_board)
ORDER BY filename;


DROP TABLE IF EXISTS tbl_board_attachment;

CREATE TABLE tbl_board_attachment
(
    no INTEGER AUTO_INCREMENT PRIMARY KEY, -- PK
    filename VARCHAR(256) NOT NULL, -- 원본 파일 명
    path VARCHAR(256) NOT NULL, -- 서버에서의 파일 경로
    content_type VARCHAR(56), -- content-type
    size INTEGER, -- 파일의 크기
    bno INTEGER NOT NULL, -- 게시글 번호, FK
    reg_date DATETIME DEFAULT now(),
    CONSTRAINT FOREIGN KEY (bno) REFERENCES tbl_board (no) ON DELETE CASCADE
);



DROP TABLE IF EXISTS tbl_travel_image;
DROP TABLE IF EXISTS tbl_travel;

# 여행지 테이블
CREATE TABLE tbl_travel
(
    no          INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    district    VARCHAR(50)        NOT NULL,
    title       VARCHAR(512)       NOT NULL,
    description TEXT,
    address     VARCHAR(512),
    phone       VARCHAR(256)
);


# 여행지 이미지 테이블
CREATE TABLE tbl_travel_image
(
    no        INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
    filename  VARCHAR(512)       NOT NULL,
    travel_no INT,
    CONSTRAINT FOREIGN KEY (travel_no) REFERENCES tbl_travel (no)
        ON DELETE CASCADE
);




-- 001-1.jpg부터 112-5.jpg까지 총 560개 파일명 INSERT
-- MySQL의 재귀 CTE(Common Table Expression) 사용 (MySQL 8.0 이상만 가능)
INSERT INTO tbl_travel_image (filename, travel_no)
WITH RECURSIVE file_generator AS (
    -- 초기값: 첫 번째 파일 (001-1.jpg)
    SELECT 1 as x, 1 as y

    UNION ALL

    -- 재귀 부분: 다음 파일명 생성
    SELECT
        CASE
            WHEN y < 5 THEN x      -- y가 5보다 작으면 x 유지
            ELSE x + 1             -- y가 5이면 x 증가
            END as x,
        CASE
            WHEN y < 5 THEN y + 1  -- y가 5보다 작으면 y 증가
            ELSE 1                 -- y가 5이면 1로 리셋
            END as y
    FROM file_generator
    WHERE x <= 112 AND NOT (x = 112 AND y = 5)  -- 112-5까지만 생성
)
SELECT
    CONCAT(LPAD(x, 3, '0'), '-', y, '.jpg') as filename,
    x as travel_no  -- travel_no는 나중에 UPDATE로 설정
FROM file_generator
WHERE x <= 112;

