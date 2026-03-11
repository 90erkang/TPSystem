<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 조건문(c:if)과 데이터 출력 등을 처리하기 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- JSTL Formatting 태그: DB의 Timestamp 데이터를 원하는 날짜 형식으로 출력하기 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 게시글 상세</title>

<%-- 사이드바 및 공통 UI 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 상세 페이지 상단(제목 및 정보) 스타일 */
.detail-header {
	border-bottom: 2px solid #eee;
	padding-bottom: 20px;
	margin-bottom: 30px;
}

.detail-title {
	font-size: 1.8rem;
	font-weight: 700;
	color: #1a237e; /* 강조를 위한 진한 남색 */
	margin-bottom: 15px;
}

.detail-info {
	display: flex;
	gap: 20px;
	color: #666;
	font-size: 0.95rem;
}

.detail-info span b {
	color: #333;
	margin-right: 5px;
}

/* 2. 게시글 본문 영역 스타일 */
.detail-content {
	min-height: 300px;
	line-height: 1.8;
	font-size: 1.05rem;
	color: #444;
	padding: 10px 0;
	word-break: break-all; /* 긴 단어 강제 줄바꿈 */
	white-space: pre-wrap; /* DB에 저장된 줄바꿈(\n)을 화면에 그대로 반영 */
}

/* 3. 하단 버튼 영역 스타일 */
.detail-buttons {
	display: flex;
	justify-content: space-between; /* 목록 버튼과 수정/삭제 버튼을 양끝으로 배치 */
	margin-top: 50px;
	padding-top: 20px;
	border-top: 1px solid #eee;
}

.btn {
	padding: 10px 20px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	border: none;
	transition: 0.2s;
	font-size: 0.95rem;
}

.btn-list {
	background: #eee;
	color: #333;
}

.btn-edit {
	background: #3949ab;
	color: #fff;
	margin-right: 5px;
}

.btn-delete {
	background: #d32f2f;
	color: #fff;
}

.btn:hover {
	opacity: 0.8;
	transform: translateY(-1px);
}
</style>
</head>
<body>
	<div class="app-container">
		<aside class="sidebar">
			<div>
				<a href="${pageContext.request.contextPath}/dashboard"
					class="sidebar-logo">태평로빌딩</a>
			</div>
			<ul class="sidebar-menu">
				<li><a href="${pageContext.request.contextPath}/dashboard">🏠
						홈</a></li>
				<li><a href="${pageContext.request.contextPath}/attendance">⏰
						근태 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<li><a href="${pageContext.request.contextPath}/logs">📝 일지
						관리</a></li>
				<%-- 사내 게시판 메뉴 활성화 상태 표시 --%>
				<li><a href="${pageContext.request.contextPath}/board"
					class="active">📋 사내 게시판</a></li>
				<%-- 관리자 권한 확인 후 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					사내 게시판 > <strong>상세 보기</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span>님 반갑습니다.
					<button class="btn-logout"
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card">
					<div class="detail-header">
						<%-- Controller에서 보낸 'board' 객체의 데이터 출력 --%>
						<h1 class="detail-title">${board.title}</h1>
						<div class="detail-info">
							<span><b>작성자</b> ${board.writer}</span>
							<%-- fmt:formatDate를 사용하여 날짜를 연-월-일 시:분 형식으로 변환 --%>
							<span><b>작성일</b> <fmt:formatDate value="${board.regdate}"
									pattern="yyyy-MM-dd HH:mm" /></span> <span><b>조회수</b>
								${board.viewcnt}</span>
						</div>
					</div>

					<%-- white-space: pre-wrap 스타일 덕분에 작성 시 입력한 엔터가 그대로 표시됨 --%>
					<div class="detail-content">${board.content}</div>

					<div class="detail-buttons">
						<button class="btn btn-list"
							onclick="location.href='${pageContext.request.contextPath}/board'">
							목록으로</button>

						<div>
							<%-- 
								권한 체크 로직:
								1. 로그인한 유저의 이름이 작성자와 같거나
								2. 로그인한 유저의 권한이 'ADMIN'인 경우에만 수정/삭제 버튼 노출
							--%>
							<c:if
								test="${member.username eq board.writer || member.role eq 'ADMIN'}">
								<button class="btn btn-edit"
									onclick="location.href='${pageContext.request.contextPath}/board/modify?bno=${board.bno}'">수정하기</button>
								<%-- 삭제 전 자바스크립트 confirm창으로 사용자 의사 재확인 --%>
								<button class="btn btn-delete"
									onclick="if(confirm('정말 삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/board/delete?bno=${board.bno}'">삭제하기</button>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>
</body>
</html>