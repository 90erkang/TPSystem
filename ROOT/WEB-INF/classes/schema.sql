-- 1. DB 생성 및 선택
CREATE DATABASE IF NOT EXISTS mybatis_db;
USE mybatis_db;
-- 2. 기존 테이블 삭제 (순서 엄수: 자식 -> 부모)
DROP TABLE IF EXISTS ATTENDANCE;
DROP TABLE IF EXISTS BOARD;
DROP TABLE IF EXISTS LOGS_TABLE;
DROP TABLE IF EXISTS MEMBER;
-- 3. MEMBER 테이블 생성 (부모)
CREATE TABLE MEMBER (
    userid VARCHAR(20) PRIMARY KEY,
    userpwd VARCHAR(100) NOT NULL,
    username VARCHAR(20) NOT NULL,
    dept VARCHAR(30) NOT NULL,
    job_title VARCHAR(20) NOT NULL,
    role VARCHAR(10) DEFAULT 'USER',
    status VARCHAR(10) DEFAULT '재직',
    email VARCHAR(50),
    phone VARCHAR(20),
    address VARCHAR(200),
    regdate DATE DEFAULT (CURRENT_DATE)
);
-- 4. BOARD 테이블 생성 (자식 1)
CREATE TABLE BOARD (
    bno INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(10) DEFAULT 'GENERAL',
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    writer VARCHAR(20) NOT NULL,
    regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    viewcnt INT DEFAULT 0,
    CONSTRAINT FK_BOARD_WRITER FOREIGN KEY (writer) REFERENCES MEMBER(userid)
);
-- 5. ATTENDANCE 테이블 생성 (자식 2)
CREATE TABLE ATTENDANCE (
    ano INT AUTO_INCREMENT PRIMARY KEY,
    userid VARCHAR(20) NOT NULL,
    work_date DATE DEFAULT (CURRENT_DATE),
    start_time TIME,
    end_time TIME,
    state VARCHAR(10) DEFAULT '정상',
    CONSTRAINT FK_ATT_USERID FOREIGN KEY (userid) REFERENCES MEMBER(userid)
);
-- 1. 계통도 정보를 저장할 테이블 생성
CREATE TABLE DIAGRAM (
    dno INT AUTO_INCREMENT PRIMARY KEY,
    category VARCHAR(20) NOT NULL, -- 'ELECTRICAL' 또는 'HVAC' 구분
    title VARCHAR(100),            -- 도면 제목
    img_path VARCHAR(200),         -- 이미지 경로 (필요 시 사용)
    regdate DATETIME DEFAULT NOW(),-- 등록일
    manager VARCHAR(50)            -- 관리 책임자
);
-- 기존 테이블이 있다면 삭제 (주의: 데이터 날아감)
-- DROP TABLE IF EXISTS LOGS_TABLE;

CREATE TABLE LOGS_TABLE (
    lno         INT AUTO_INCREMENT PRIMARY KEY,
    category    VARCHAR(20) NOT NULL,
    log_date    VARCHAR(50) NOT NULL,              -- 20 -> 50으로 확장
    writer      VARCHAR(50) NOT NULL,
    worker      VARCHAR(255),                      -- "강ㅁ동윤, 최다니엘" 통합 저장
    temp        VARCHAR(10),
    memo        TEXT,
    content     LONGTEXT,                          -- JSON 데이터
    regdate     TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
drop table board;
-- 6. 테스트 데이터 입력 (접속 확인용)
INSERT INTO MEMBER (userid, userpwd, username, dept, job_title, role)
VALUES ('admin', '1234', '관리자', '기계팀', '팀장', 'ADMIN');
INSERT INTO BOARD (title, content, writer) 
VALUES ('태평로빌딩 통합관리 시스템 공지', '정상적으로 가동 중입니다.', 'admin');
INSERT INTO ATTENDANCE (userid, start_time, state) 
VALUES ('admin', '08:55:00', '정상');
INSERT INTO DIAGRAM (category, title, img_path, manager) 
VALUES ('ELECTRICAL', '22.9kV 수변전 설비 단선 결선도', 'elec_map.png', '전기팀');
INSERT INTO DIAGRAM (category, title, img_path, manager) 
VALUES ('HVAC', '중앙 냉난방 공조 계통도', 'hvac_map.png', '기계팀');
-- 7. 안전 모드(안전모드가 걸려있는 곳에 사용)
SET SQL_SAFE_UPDATES = 0;  -- 안전 모드 해제
SET SQL_SAFE_UPDATES = 1;  -- 안전 모드 켜기
-- 8. 외래키 검사 끄기 
SET FOREIGN_KEY_CHECKS = 0;
SET FOREIGN_KEY_CHECKS = 1;
-- 9. 원하는 데이터 조작관련
TRUNCATE TABLE ATTENDANCE; -- 근태 기록 싹 지움
TRUNCATE TABLE board;
TRUNCATE TABLE member;
UPDATE BOARD SET viewcnt = 0; -- 행 칼럼의 값을 0 만약 한곳만 지우고 싶으면 where 조건문 사용 WHERE bno > 0
-- 10. 테이블 열람
SELECT * FROM MEMBER;      -- 직원 테이블 전체 보기
SELECT * FROM BOARD;       -- 게시판 테이블 전체 보기
SELECT * FROM ATTENDANCE;  -- 근태 테이블 전체 보기