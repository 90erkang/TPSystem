# 🏢 태평로빌딩 통합 관리 시스템

[![Java](https://img.shields.io/badge/Java-8-orange?logo=java)](https://www.java.com)
[![Spring](https://img.shields.io/badge/Spring_MVC-5.0.2-brightgreen?logo=spring)](https://spring.io)
[![MyBatis](https://img.shields.io/badge/MyBatis-3.5.9-blue)](https://mybatis.org)
[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?logo=mysql)](https://www.mysql.com)
[![Tomcat](https://img.shields.io/badge/Tomcat-9.x-yellow?logo=apachetomcat)](https://tomcat.apache.org)

건물 시설 관리팀을 위한 **사내 통합 관리 시스템**입니다.  
근태 관리, 시설 일지 작성, 계통도 열람, 사내 게시판, 직원 계정 관리(ADMIN) 기능을 제공합니다.

---
전체파일:https://drive.google.com/file/d/17aMYy3NG5JTalE2lGlx_DHruZOsKv27K/view?usp=drive_link
---
## 📑 목차

1. [주요 기능](#-주요-기능)
2. [기술 스택](#-기술-스택)
3. [아키텍처](#-아키텍처)
4. [DB 설계](#-db-설계)
5. [URL 구조 (라우팅)](#-url-구조-라우팅)
6. [MyBatis SQL 명세](#-mybatis-sql-명세)
7. [JSP 뷰 목록](#-jsp-뷰-목록)
8. [설치 및 실행](#-설치-및-실행)
9. [환경 설정](#-환경-설정)
10. [보안 주의사항](#-보안-주의사항)

---

## 🚀 주요 기능

### 1. 인증 및 세션 관리
- 사번(userid) + 비밀번호로 로그인
- HttpSession에 `member` 객체 저장 → 전 페이지 권한 판별에 사용
- 로그아웃 시 세션 전체 무효화
- 미로그인 상태에서 모든 내부 페이지 접근 시 `/login`으로 리다이렉트

### 2. 대시보드 (홈)
- 실시간 디지털 시계 (JavaScript setInterval)
- 빠른 출근/퇴근 버튼 (1클릭 근태 체크)
- 사내 게시판 최신글 5건 미리보기
- 나의 최근 근태 내역 1건 표시

### 3. 근태 관리
- 출근 등록: 오늘 이미 출근 기록이 있으면 중복 방지
  - 09:00 이전: **정상**, 이후: **지각** 자동 판정
- 퇴근 등록: `end_time` 업데이트
- 월별 근태 이력 전체 조회 (달력 형식)
- 이번 달 통계 카드: 출근 일수 / 정상 / 지각 / 결근·조퇴

### 4. 시설 계통도
- **수변전 계통도** (22.9kV 단선 결선도)
- **냉난방 공조 계통도** (중앙 HVAC)
- DB에 저장된 이미지 경로(`img_path`) 기반으로 동적 렌더링

### 5. 시설 운전 일지 (로그)
모든 일지는 `LOGS_TABLE` 단일 테이블에 `category` 컬럼으로 구분

| 일지 종류 | category 값 | 설명 |
|-----------|-------------|------|
| 일일 업무 일지 | `DAILY` | 민원 처리, 시설 점검, 일반 작업 |
| 수변전 운전 일지 | `ELEC` | 특고압·저압반 전력 계측 데이터 (시간대별) |
| 터보냉동기 일지 | `CHILLER` | 온도·압력·냉매 순환 계통 (2시간 주기) |
| 관류형 보일러 일지 | `BOILER` | 증기 압력·연소 상태 (2시간 주기) |

공통 기능:
- **엑셀 다운로드**: SheetJS(xlsx.js)로 HTML 테이블 → `.xlsx` 변환
- 아이콘: FontAwesome 6.4.2

### 6. 사내 게시판
- 목록 조회 (페이징, 10건씩)
- 글쓰기 / 상세 조회 (조회수 자동 증가) / 수정 / 삭제
- 작성자 본인만 수정·삭제 가능 (세션 userid 비교)

### 7. 관리자 모드 (ADMIN 전용)
- 전체 직원 목록 조회 (부서 / 상태 / 이름·사번 복합 필터)
- 직원 상세 정보 페이지
- 직원 정보 수정 (비밀번호, 부서, 직급, 권한, 상태 등 전항목)
- 신규 직원 등록
- 특정 직원 근태 이력 조회 + 이번 달 요약 통계

---

## 🛠 기술 스택

| 구분 | 기술 | 버전 |
|------|------|------|
| 언어 | Java | 8 |
| 프레임워크 | Spring MVC | 5.0.2.RELEASE |
| ORM | MyBatis + MyBatis-Spring | 3.5.9 / 2.0.7 |
| DB | MySQL | 8.0 |
| DB 드라이버 | mysql-connector-j | 8.0.33 |
| 뷰 | JSP + JSTL | 1.2 |
| JSON | Jackson Databind | 2.15.2 |
| 코드 간소화 | Lombok | 1.18.28 |
| 배포 | Apache Tomcat | 9.x (WAR) |
| 빌드 | Maven | 3.8.1 |
| 프론트엔드 | HTML/CSS/JS (Vanilla) | - |
| 아이콘 | FontAwesome | 6.4.2 (CDN) |
| 엑셀 | SheetJS (xlsx.js) | 0.18.5 (CDN) |

---

## 🏗 아키텍처

```
브라우저 (JSP + JSTL)
    │  HTTP 요청
    ▼
DispatcherServlet (web.xml: 모든 요청 "/" 처리)
    │
    ▼
OrderController (@Controller)
    │  @Autowired
    ▼
IDao (MyBatis Mapper Interface)
    │  SqlSession → IDoMapper.xml
    ▼
MySQL (mybatis_db)
```

**Spring 컨텍스트 구조:**
```
root-context.xml       → DataSource, SqlSessionFactory, SqlSession, MapperScanner 설정
servlet-context.xml    → DispatcherServlet, ViewResolver (/WEB-INF/views/*.jsp), 정적 자원
web.xml                → DispatcherServlet 등록, UTF-8 필터, welcome-file(index.jsp)
```

**패키지 구조 (com.spring):**
```
com.spring
├── controller
│   └── OrderController.java     ← 전체 요청 처리 단일 컨트롤러
├── dao
│   ├── IDao.java                ← MyBatis Mapper 인터페이스
│   └── IDoMapper.xml            ← SQL 쿼리 정의 파일
└── dto
    ├── MemberVO.java            ← 직원 정보
    ├── BoardVO.java             ← 게시글
    ├── AttendanceVO.java        ← 근태 기록
    ├── DiagramVO.java           ← 계통도 정보
    └── LogsVO.java              ← 운전 일지
```

---

## 🗄 DB 설계

데이터베이스명: `mybatis_db` (charset: utf8mb4)

### MEMBER (직원 정보 - 부모 테이블)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| userid | VARCHAR(20) PK | 사번 (로그인 ID) |
| userpwd | VARCHAR(100) | 비밀번호 (평문 저장⚠️) |
| username | VARCHAR(20) | 이름 |
| dept | VARCHAR(30) | 부서 (기계팀/전기팀/방재팀/설비팀/통신팀) |
| job_title | VARCHAR(20) | 직급 |
| role | VARCHAR(10) | 권한 (USER / ADMIN), 기본값: USER |
| status | VARCHAR(10) | 재직 상태 (재직/휴직/퇴사), 기본값: 재직 |
| email | VARCHAR(50) | 이메일 |
| phone | VARCHAR(20) | 연락처 |
| address | VARCHAR(200) | 주소 |
| regdate | DATE | 입사일, 기본값: CURRENT_DATE |

### BOARD (게시글 - MEMBER 자식)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| bno | INT AUTO_INCREMENT PK | 게시글 번호 |
| category | VARCHAR(10) | 카테고리 (기본값: GENERAL) |
| title | VARCHAR(200) | 제목 |
| content | TEXT | 본문 |
| writer | VARCHAR(20) FK→MEMBER.userid | 작성자 사번 |
| regdate | TIMESTAMP | 작성일시, 기본값: CURRENT_TIMESTAMP |
| viewcnt | INT | 조회수, 기본값: 0 |

### ATTENDANCE (근태 기록 - MEMBER 자식)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| ano | INT AUTO_INCREMENT PK | 근태 기록 번호 |
| userid | VARCHAR(20) FK→MEMBER.userid | 사번 |
| work_date | DATE | 근무 날짜, 기본값: CURRENT_DATE |
| start_time | TIME | 출근 시각 |
| end_time | TIME | 퇴근 시각 (NULL = 근무 중) |
| state | VARCHAR(10) | 상태 (정상/지각/결근/조퇴), 기본값: 정상 |

### DIAGRAM (계통도 정보)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| dno | INT AUTO_INCREMENT PK | 계통도 번호 |
| category | VARCHAR(20) | 종류 (ELECTRICAL / HVAC) |
| title | VARCHAR(100) | 계통도 제목 |
| img_path | VARCHAR(200) | 이미지 파일 경로 |
| regdate | DATETIME | 등록일시 |
| manager | VARCHAR(50) | 담당팀 |

### LOGS_TABLE (시설 운전 일지)

| 컬럼 | 타입 | 설명 |
|------|------|------|
| lno | INT AUTO_INCREMENT PK | 일지 번호 |
| category | VARCHAR(20) | 일지 종류 (DAILY/ELEC/CHILLER/BOILER) |
| log_date | VARCHAR(50) | 작성 날짜 (문자열) |
| writer | VARCHAR(50) | 작성자명 |
| worker | VARCHAR(255) | 작업자 (해당 시간대 근무자) |
| temp | VARCHAR(10) | 온도 (수변전 등에서 사용) |
| memo | TEXT | 특이사항 메모 |
| content | LONGTEXT | 계측 데이터 (JSON 또는 HTML 테이블 구조) |
| regdate | TIMESTAMP | DB 입력 시각 |

---

## 🗺 URL 구조 (라우팅)

모든 URL은 `OrderController` 단일 클래스에서 처리됩니다.

### 인증

| Method | URL | 설명 | 뷰 |
|--------|-----|------|-----|
| GET | `/login` | 로그인 페이지 | `login.jsp` |
| POST | `/loginCheck` | 로그인 검증 → 성공: `/dashboard`, 실패: `login.jsp` (msg) | - |
| GET | `/logout` | 세션 무효화 → `/login` 리다이렉트 | - |

### 대시보드

| Method | URL | 설명 | 뷰 |
|--------|-----|------|-----|
| GET | `/dashboard` | 홈 대시보드 (최신글 5건, 최근 근태 1건) | `index.jsp` |

### 근태 관리

| Method | URL | 설명 | 뷰 |
|--------|-----|------|-----|
| GET | `/attendance` | 근태 관리 페이지 (개인 전체 이력 + 월별 통계) | `attendance.jsp` |
| GET | `/attendance/checkIn` | 출근 등록 (중복 체크 → 정상/지각 자동 판정) → `/attendance` 리다이렉트 | - |
| GET | `/attendance/checkOut` | 퇴근 등록 (end_time 업데이트) → `/attendance` 리다이렉트 | - |

### 계통도

| Method | URL | 설명 | 뷰 |
|--------|-----|------|-----|
| GET | `/diagram` | 계통도 선택 메뉴 | `diagram.jsp` |
| GET | `/diagram/electrical` | 수변전 계통도 상세 | `diagram_elec.jsp` |
| GET | `/diagram/hvac` | 냉난방 공조 계통도 상세 | `diagram_hvac.jsp` |

### 시설 운전 일지

| Method | URL | 설명 | 뷰 |
|--------|-----|------|-----|
| GET | `/logs` | 일지 종류 선택 메뉴 | `logs_main.jsp` |
| GET | `/logs/list?category=` | 카테고리별 일지 목록 | `logs_list.jsp` / `logs_elec_list.jsp` / `logs_chiller_list.jsp` / `logs_boiler_list.jsp` |
| GET | `/logs/view?lno=` | 일지 상세 조회 | `logs_daily.jsp` / `logs_elec.jsp` / `logs_chiller.jsp` / `logs_boiler.jsp` |
| GET | `/logs/write?category=` | 일지 작성 폼 | (카테고리별 분기) |
| POST | `/logs/write` | 일지 저장 → `/logs/list?category=` 리다이렉트 | - |
| POST | `/logs/update` | 일지 수정 저장 | - |
| GET | `/logs/delete?lno=` | 일지 삭제 → `/logs/list?category=` 리다이렉트 | - |

### 사내 게시판

| Method | URL | 설명 | 뷰 |
|--------|-----|------|-----|
| GET | `/board` | 게시글 목록 (페이징, page 파라미터) | `board.jsp` |
| GET | `/board/write` | 게시글 작성 폼 | `board_write.jsp` |
| POST | `/board/register` | 게시글 저장 → `/board` 리다이렉트 | - |
| GET | `/board/detail?bno=` | 게시글 상세 (조회수 +1) | `board_detail.jsp` |
| GET | `/board/modify?bno=` | 게시글 수정 폼 | `board_modify.jsp` |
| POST | `/board/modify` | 수정 저장 → `/board/detail?bno=` 리다이렉트 | - |
| GET | `/board/delete?bno=` | 게시글 삭제 → `/board` 리다이렉트 | - |

### 관리자 모드 (ADMIN 전용)

| Method | URL | 설명 | 뷰 |
|--------|-----|------|-----|
| GET | `/admin` | 직원 목록 (부서/상태/이름·사번 필터) | `admin.jsp` |
| GET | `/admin/detail?userid=` | 직원 상세 정보 | `admin_detail.jsp` |
| GET | `/admin/edit?userid=` | 직원 정보 수정 폼 | `admin_edit.jsp` |
| POST | `/admin/memberUpdate` | 직원 정보 저장 → `/admin/detail?userid=` 리다이렉트 | - |
| GET | `/admin/register` | 신규 직원 등록 폼 | `admin_register.jsp` |
| POST | `/admin/memberWrite` | 신규 직원 저장 → `/admin` 리다이렉트 | - |
| GET | `/admin/attendance/detail?userid=` | 특정 직원 근태 이력 + 이번 달 요약 | `admin_attendance.jsp` |

---

## 📋 MyBatis SQL 명세

매퍼 파일: `com/spring/dao/IDoMapper.xml` (namespace: `com.spring.dao.IDao`)

### 인증

| ID | 타입 | SQL 요약 | 파라미터 |
|----|------|----------|----------|
| `loginDao` | SELECT | `WHERE userid=? AND userpwd=?` | userid, userpwd |

### 게시판

| ID | 타입 | SQL 요약 |
|----|------|----------|
| `listDao` | SELECT | 전체 게시글 목록 (최신순 DESC, LIMIT offset, size) |
| `countBoardDao` | SELECT | 게시글 전체 수 (페이징용) |
| `writeDao` | INSERT | 게시글 작성 (writer, content, title, NOW()) |
| `viewDao` | SELECT | 게시글 단건 조회 (bno) |
| `upHitDao` | UPDATE | 조회수 +1 (viewcnt = viewcnt + 1) |
| `modifyDao` | UPDATE | 제목·내용 수정 (bno 기준) |
| `deleteDao` | DELETE | 게시글 삭제 (bno) |

### 근태

| ID | 타입 | SQL 요약 |
|----|------|----------|
| `getMyAttendanceDao` | SELECT | 개인 전체 근태 이력 (최신순, DATE_FORMAT 포맷팅) |
| `checkTodayAttendance` | SELECT | 오늘 출근 기록 존재 여부 (COUNT) |
| `insertCheckInDao` | INSERT | 출근 등록 (userid, CURDATE(), CURTIME(), state) |
| `updateCheckOutDao` | UPDATE | 퇴근 시각 기록 (userid, CURDATE() 기준) |

### 직원 관리 (ADMIN)

| ID | 타입 | SQL 요약 |
|----|------|----------|
| `listMemberDao` | SELECT | 직원 목록 (부서/상태/이름·사번 동적 WHERE `<if>` 사용) |
| `registerMemberDao` | INSERT | 신규 직원 등록 (10개 파라미터) |
| `viewMemberDao` | SELECT | 직원 단건 조회 (userid) |
| `updateMemberDao` | UPDATE | 직원 정보 전체 수정 (10개 파라미터) |

### 계통도

| ID | 타입 | SQL 요약 |
|----|------|----------|
| `viewDiagramDao` | SELECT | 카테고리별 계통도 조회 (DATE_FORMAT 포함) |

### 시설 일지

| ID | 타입 | SQL 요약 |
|----|------|----------|
| `listLogsDao` | SELECT | 카테고리별 일지 목록 (log_date DESC, lno DESC) |
| `viewLogDao` | SELECT | 일지 단건 조회 (lno) |
| `writeLogDao` | INSERT | 일지 신규 작성 (7개 필드) |
| `updateLogDao` | UPDATE | 일지 수정 (worker, temp, content, memo) |
| `deleteLogDao` | DELETE | 일지 삭제 (lno) |

---

## 📁 JSP 뷰 목록

모든 뷰 파일 위치: `/WEB-INF/views/`

| 파일명 | 설명 |
|--------|------|
| `login.jsp` | 로그인 화면 (남색 그라데이션 배경, 중앙 카드 레이아웃) |
| `index.jsp` | 대시보드 홈 (실시간 시계, 빠른 근태, 최신 게시글, 최근 근태) |
| `attendance.jsp` | 근태 관리 (대형 시계, 출퇴근 버튼, 이달 통계, 이력 테이블) |
| `diagram.jsp` | 계통도 선택 메뉴 (카드형 UI) |
| `diagram_elec.jsp` | 수변전 계통도 상세 이미지 |
| `diagram_hvac.jsp` | 냉난방 공조 계통도 상세 이미지 |
| `logs_main.jsp` | 일지 종류 선택 메뉴 (4종 카드형, 반응형) |
| `logs_list.jsp` | 일일 업무 일지 목록 |
| `logs_daily.jsp` | 일일 업무 일지 작성·수정 폼 |
| `logs_elec_list.jsp` | 수변전 운전 일지 목록 |
| `logs_elec.jsp` | 수변전 운전 일지 작성·수정 폼 (시간대별 계측 테이블) |
| `logs_chiller_list.jsp` | 터보냉동기 일지 목록 |
| `logs_chiller.jsp` | 터보냉동기 운전 일지 작성·수정 폼 |
| `logs_boiler_list.jsp` | 관류형 보일러 일지 목록 |
| `logs_boiler.jsp` | 관류형 보일러 운전 일지 작성·수정 폼 |
| `board.jsp` | 게시판 목록 (페이징) |
| `board_write.jsp` | 게시글 작성 폼 |
| `board_detail.jsp` | 게시글 상세 (조회수, 수정·삭제 버튼) |
| `board_modify.jsp` | 게시글 수정 폼 |
| `admin.jsp` | 관리자 직원 목록 (복합 필터, 배지 표시) |
| `admin_detail.jsp` | 직원 상세 (프로필 + 2열 그리드 정보) |
| `admin_edit.jsp` | 직원 정보 수정 폼 (2열 그리드) |
| `admin_register.jsp` | 신규 직원 등록 폼 |
| `admin_attendance.jsp` | 특정 직원 근태 이력 + 이달 요약 카드 |
| `home.jsp` | Spring MVC 기본 생성 파일 (미사용) |

---

## ⚙️ 설치 및 실행

### 1. DB 설정
```sql
-- init.sql 실행
mysql -u root -p < init.sql
```

또는 MySQL 클라이언트에서:
```sql
SOURCE /경로/init.sql;
```

기본 ADMIN 계정이 자동 생성됩니다:
- **사번**: `admin`
- **비밀번호**: `1234`

### 2. DB 연결 정보 수정

`WEB-INF/spring/root-context.xml`에서 수정:
```xml
<property name="url"
  value="jdbc:mysql://127.0.0.1:3309/mybatis_db?serverTimezone=UTC&amp;useUnicode=true&amp;characterEncoding=utf8"/>
<property name="username" value="root"/>
<property name="password" value="여기에_비밀번호"/>
```
> **포트**: 기본 MySQL 포트는 `3306`입니다. 현재 설정은 `3309`이므로 환경에 맞게 변경하세요.

### 3. Tomcat 배포
1. Maven으로 WAR 빌드: `mvn clean package`
2. 생성된 `order1-0.0.1-SNAPSHOT.war`를 Tomcat `webapps/ROOT/`에 배포
3. (또는 Eclipse/IntelliJ에서 서버 직접 실행)

### 4. 접속
```
http://localhost:8080/
```

---

## 🔧 환경 설정

| 설정 파일 | 역할 | 주요 항목 |
|-----------|------|-----------|
| `web.xml` | 서블릿 설정 | DispatcherServlet, UTF-8 인코딩 필터, welcome-file |
| `root-context.xml` | 루트 컨텍스트 | DataSource, SqlSessionFactory, SqlSession, MapperScanner |
| `servlet-context.xml` | 서블릿 컨텍스트 | ViewResolver(prefix/suffix), 정적 자원 경로, 컴포넌트 스캔 |
| `IDoMapper.xml` | SQL 쿼리 | 모든 CRUD SQL 정의 |

---

## ⚠️ 보안 주의사항

| 항목 | 현재 상태 | 권고 조치 |
|------|-----------|-----------|
| 비밀번호 암호화 | ❌ 평문 저장 | BCrypt 등 단방향 해시 적용 |
| ADMIN 권한 검증 | ❌ 컨트롤러 레벨 미검증 (JSP에서만 메뉴 숨김) | `HttpSession`에서 role 확인 후 미승인 시 403 처리 |
| SQL Injection | ✅ MyBatis `#{}` 사용 (PreparedStatement) | - |
| XSS | ⚠️ JSP EL 직접 출력 다수 | `<c:out>`으로 이스케이프 처리 적용 |
| 세션 탈취 | ⚠️ HttpOnly, Secure 쿠키 미설정 | `web.xml` 또는 Tomcat 레벨에서 세션 쿠키 보안 설정 |
| DB 접속 정보 | ⚠️ root-context.xml에 평문 노출 | 환경변수 또는 외부 프로퍼티 파일로 분리 |

---

## 📂 프로젝트 파일 구조

```
ROOT/
├── META-INF/
│   ├── MANIFEST.MF
│   └── maven/com.spring/order1/
│       ├── pom.xml          ← Maven 의존성 정의
│       └── pom.properties
└── WEB-INF/
    ├── web.xml              ← 서블릿 컨테이너 설정
    ├── spring/
    │   ├── root-context.xml         ← DB, MyBatis 설정
    │   └── appServlet/
    │       └── servlet-context.xml  ← MVC, ViewResolver 설정
    ├── classes/
    │   └── com/spring/
    │       ├── controller/
    │       │   └── OrderController.java   ← 단일 컨트롤러 (전체 URL 처리)
    │       ├── dao/
    │       │   ├── IDao.java              ← MyBatis 매퍼 인터페이스
    │       │   └── IDoMapper.xml          ← SQL 쿼리 정의
    │       └── dto/
    │           ├── MemberVO.java
    │           ├── BoardVO.java
    │           ├── AttendanceVO.java
    │           ├── DiagramVO.java
    │           └── LogsVO.java
    ├── lib/                 ← JAR 라이브러리 (Spring, MyBatis, MySQL 등)
    └── views/               ← JSP 뷰 파일 24개
        ├── login.jsp
        ├── index.jsp        ← 대시보드
        ├── attendance.jsp
        ├── diagram*.jsp
        ├── logs_*.jsp
        ├── board*.jsp
        └── admin*.jsp
```
