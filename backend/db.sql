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
USE scoula_db

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