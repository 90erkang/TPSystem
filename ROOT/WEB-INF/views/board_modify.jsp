<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 관리자 메뉴 노출 여부 등을 제어하기 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>태평로빌딩 | 글 수정</title>

<%-- 사이드바 및 공통 레이아웃 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 수정 폼 레이아웃: 항목들을 세로로 나열 */
.write-form {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

/* 2. 입력 그룹 스타일: 라벨과 입력창 간격 조절 */
.form-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.form-group label {
	font-weight: 600;
	color: #1a237e; /* 강조를 위한 진한 남색 */
	font-size: 0.95rem;
}

/* 3. 인풋 및 텍스트에어리어 공통 스타일 */
.form-group input, .form-group textarea {
	padding: 12px 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 1rem;
	font-family: inherit;
}

/* 본문 입력창: 최소 높이 설정 및 세로 크기 조절 허용 */
.form-group textarea {
	min-height: 400px;
	line-height: 1.6;
	resize: vertical;
}

/* 4. 하단 버튼 영역 스타일 */
.write-buttons {
	display: flex;
	justify-content: flex-end; /* 우측 정렬 */
	gap: 10px;
	margin-top: 30px;
	padding-top: 20px;
	border-top: 1px solid #eee;
}

.btn {
	padding: 12px 25px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	border: none;
	font-size: 1rem;
	transition: 0.2s;
}

.btn-cancel {
	background: #eee;
	color: #333;
}

.btn-save {
	background: #1a237e;
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
				<%-- 현재 게시판 메뉴 활성화 상태 유지 --%>
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
					사내 게시판 > <strong>글 수정</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e;">${member.username}
						${member.job_title}</span>님 반갑습니다.
					<button class="btn-logout"
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card">
					<h2 style="margin-bottom: 25px; color: #1a237e;">📝 게시글 수정</h2>

					<%-- 
						수정 처리 폼 시작 
						method: 대용량 데이터 전송을 위해 POST 방식 사용
						action: 수정을 처리할 서버 컨트롤러 매핑 주소
					--%>
					<form action="${pageContext.request.contextPath}/board/modify"
						method="post" class="write-form">

						<%-- 
							★ 핵심: 수정 대상 게시글의 번호(bno) 
							화면에는 보이지 않지만, 서버로 전송되어 어떤 글을 수정할지 식별하는 기준이 됨
						--%>
						<input type="hidden" name="bno" value="${board.bno}">

						<%-- 제목 입력: 기존 제목이 value에 세팅됨 --%>
						<div class="form-group">
							<label>제목</label> <input type="text" name="title"
								value="${board.title}" required>
						</div>

						<%-- 작성자 입력: 기존 작성자가 세팅되며, 수정할 수 없도록 readonly 설정 --%>
						<div class="form-group">
							<label>작성자</label> <input type="text" name="writer"
								value="${board.writer}" readonly
								style="background: #f8f9fa; color: #888; cursor: not-allowed;">
						</div>

						<%-- 본문 입력: <textarea> 태그 사이에 기존 내용 출력 --%>
						<div class="form-group">
							<label>내용</label>
							<textarea name="content" required>${board.content}</textarea>
						</div>

						<div class="write-buttons">
							<%-- 취소 버튼: 브라우저의 이전 페이지(상세 보기)로 이동 --%>
							<button type="button" class="btn btn-cancel"
								onclick="history.back()">취소</button>
							<%-- 수정완료 버튼: form 데이터를 전송(submit) --%>
							<button type="submit" class="btn btn-save">수정완료</button>
						</div>
					</form>
				</div>
			</div>
		</main>
	</div>
</body>
</html>