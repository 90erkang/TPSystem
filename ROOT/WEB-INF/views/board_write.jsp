<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 권한 확인(c:if) 등 조건 로직을 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>태평로빌딩 | 글쓰기</title>

<%-- 사이드바 및 레이아웃 관련 공통 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 작성 폼 레이아웃: 항목들을 수직(column) 방향으로 정렬 */
.write-form {
	display: flex;
	flex-direction: column;
	gap: 20px;
}

/* 2. 입력 그룹 스타일: 라벨과 입력창 사이의 간격 및 정렬 정의 */
.form-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.form-group label {
	font-weight: 600;
	color: #1a237e; /* 신뢰감을 주는 진한 남색 강조 */
	font-size: 0.95rem;
}

/* 3. 인풋 및 텍스트 영역 공통 스타일 */
.form-group input, .form-group textarea {
	padding: 12px 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 1rem;
	font-family: inherit;
}

/* 본문 입력창: 작성 편의를 위해 최소 높이 400px 확보 및 가독성 높은 줄간격 설정 */
.form-group textarea {
	min-height: 400px;
	line-height: 1.6;
	resize: vertical; /* 사용자가 필요에 따라 세로 길이를 조절 가능 */
}

/* 4. 하단 버튼 영역 스타일: 등록하기 버튼을 우측으로 배치 */
.write-buttons {
	display: flex;
	justify-content: flex-end;
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

/* 취소 버튼 스타일 (현재 버튼은 미구현이나 클래스 정의 유지) */
.btn-cancel {
	background: #eee;
	color: #333;
}

/* 등록 버튼 스타일: 진한 남색 배경 */
.btn-save {
	background: #1a237e;
	color: #fff;
}

.btn:hover {
	opacity: 0.8;
	transform: translateY(-1px); /* 마우스 오버 시 살짝 떠오르는 효과 */
}
</style>
</head>
<body>
	<div class="app-container">
		<%-- 좌측 사이드바 영역 --%>
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
				<%-- 현재 게시판 메뉴 활성화 표시 --%>
				<li><a href="${pageContext.request.contextPath}/board"
					class="active">📋 사내 게시판</a></li>
				<%-- 관리자(ADMIN) 권한이 있는 경우에만 관리자 모드 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<%-- 우측 메인 콘텐츠 영역 --%>
		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					사내 게시판 > <strong>글쓰기</strong>
				</div>
				<div class="user-info">
					<%-- 세션에 저장된 사용자 이름과 직급 출력 (비어있을 경우 '직원'으로 기본값 처리) --%>
					<span style="font-weight: 600; color: #1a237e"> ${not empty member ? member.username : '직원'}
						${member.job_title} </span>님 반갑습니다.
					<button class="btn-logout"
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card">
					<h2 style="margin-bottom: 25px; color: #1a237e;">📝 새 게시글 작성</h2>

					<%-- 
						글 등록 폼 시작 
						method: 본문 대용량 데이터 전송을 위해 POST 방식 사용
						action: 글 등록을 처리할 컨트롤러의 매핑 주소
					--%>
					<form action="${pageContext.request.contextPath}/board/register"
						method="post" class="write-form">

						<%-- 제목 입력 필드: required 속성으로 빈 제목 전송 방지 --%>
						<div class="form-group">
							<label>제목</label> <input type="text" name="title" required>
						</div>

						<%-- 작성자 정보 영역 --%>
						<div class="form-group">
							<label>작성자</label>
							<%-- 
								★ 중요: 실제 DB(BOARD 테이블)의 writer 컬럼은 외래키인 'userid'를 참조함
								사용자에게는 보이지 않지만, 서버로 'userid'를 전송하기 위해 hidden 타입 사용 
							--%>
							<input type="hidden" name="writer" value="${member.userid}">

							<%-- 화면에는 직관적으로 인지할 수 있도록 작성자의 성함을 표시 (수정 불가) --%>
							<input type="text" value="${member.username}" readonly
								style="background: #f8f9fa; color: #888; cursor: not-allowed;">
						</div>

						<%-- 본문 내용 입력 영역 --%>
						<div class="form-group">
							<label>내용</label>
							<textarea name="content" required></textarea>
						</div>

						<%-- 폼 제출 버튼 영역 --%>
						<div class="write-buttons">
							<button type="submit" class="btn btn-save">등록하기</button>
						</div>
					</form>
				</div>
			</div>
		</main>
	</div>
</body>
</html>