<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 조건문, 반복문, 변수 처리를 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- JSTL Formatting 태그: 날짜 형식을 'yyyy-MM-dd' 등으로 변환하기 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 사내 게시판</title>
<%-- 사이드바 스타일시트 경로 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">
<style>
/* 1. 게시판 전용 스타일: 테이블 행 호버 효과 및 제목 셀 강조 */
.table tbody tr {
	transition: background-color 0.2s;
	cursor: pointer; /* 행 전체를 클릭 가능하도록 커서 변경 */
}

.table tbody tr:hover {
	background-color: #f1f3f9; /* 마우스 오버 시 연한 파란색 배경 */
}

.table td.title-cell {
	text-align: left; /* 제목은 왼쪽 정렬 */
	padding-left: 30px;
	color: #333;
	font-weight: 500;
}

/* 제목 호버 시 텍스트 밑줄 및 색상 변경 */
.table tr:hover td.title-cell {
	color: #1a237e;
	text-decoration: underline;
}

.table td {
	color: #666;
}

/* 2. 페이지네이션(Pagination) 영역 스타일 */
.pagination-area {
	display: flex;
	justify-content: center;
	margin-top: 30px;
	gap: 5px;
}

/* 개별 페이지 버튼 스타일 */
.page-btn {
	padding: 6px 12px;
	border: 1px solid #ddd;
	background: #fff;
	cursor: pointer;
	border-radius: 4px;
	font-size: 0.9rem;
	color: #333;
	transition: 0.2s;
}

.page-btn:hover {
	background: #f1f1f1;
}

/* 현재 활성화된 페이지 버튼 스타일 */
.page-btn.active {
	background: #1a237e;
	color: #fff;
	border-color: #1a237e;
	font-weight: bold;
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
				<%-- 사내 게시판 메뉴 활성화 표시 --%>
				<li><a href="${pageContext.request.contextPath}/board"
					class="active">📋 사내 게시판</a></li>
				<%-- 관리자 권한(ADMIN)인 경우 관리자 모드 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > <strong>사내 게시판</strong>
				</div>
				<div class="user-info">
					<%-- 로그인 세션 정보에 따른 동적 이름 출력 --%>
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
					<div
						style="display: flex; justify-content: space-between; margin-bottom: 20px; align-items: center;">
						<h2 style="color: #1a237e;">📋 사내 게시판</h2>
						<button
							style="padding: 10px 20px; background: #1a237e; color: #fff; border: none; border-radius: 5px; cursor: pointer; font-weight: bold;"
							onclick="location.href='${pageContext.request.contextPath}/board/write'">
							글쓰기 ✏️</button>
					</div>

					<table class="table">
						<thead>
							<tr>
								<th style="width: 80px">번호</th>
								<th>제목</th>
								<th style="width: 120px">작성자</th>
								<th style="width: 180px">작성일</th>
								<th style="width: 80px">조회</th>
							</tr>
						</thead>
						<tbody>
							<%-- 
								목록 반복 출력 (varStatus="status"를 통해 인덱스 활용) 
								items: Controller에서 전달받은 게시글 리스트
							--%>
							<c:forEach items="${boardList}" var="board" varStatus="status">
								<tr
									onclick="location.href='${pageContext.request.contextPath}/board/detail?bno=${board.bno}'">
									<%-- 
										★ 게시글 번호 계산 로직: 전체 개수에서 현재 페이지 이전의 개수를 빼고 인덱스를 차감하여 역순 번호 생성 
										공식: 전체게시글수 - ((현재페이지-1) * 한페이지당개수) - 현재인덱스
									--%>
									<td>${totalCount - ((currentPage - 1) * 5) - status.index}
									</td>
									<td class="title-cell">${board.title}</td>
									<td>${board.writer}</td>
									<%-- 날짜 포맷팅: 시/분까지 출력하도록 설정 --%>
									<td><fmt:formatDate value="${board.regdate}"
											pattern="yyyy-MM-dd HH:mm" timeZone="UTC" /></td>
									<td>${board.viewcnt}</td>
								</tr>
							</c:forEach>

							<%-- 게시글이 존재하지 않을 경우의 예외 처리 --%>
							<c:if test="${empty boardList}">
								<tr>
									<td colspan="5" style="text-align: center; padding: 50px;">등록된
										게시글이 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>

					<div class="pagination-area">
						<%-- [이전] 버튼: 1페이지보다 클 때만 노출 --%>
						<c:if test="${currentPage > 1}">
							<button class="page-btn"
								onclick="location.href='${pageContext.request.contextPath}/board?page=${currentPage - 1}'">
								&lt; 이전</button>
						</c:if>

						<%-- 페이지 숫자 반복 출력 --%>
						<c:forEach begin="${startPage}" end="${endPage}" var="pageNum">
							<c:choose>
								<%-- 현재 페이지인 경우 active 클래스 부여하여 강조 --%>
								<c:when test="${pageNum == currentPage}">
									<button class="page-btn active"
										onclick="location.href='${pageContext.request.contextPath}/board?page=${pageNum}'">
										${pageNum}</button>
								</c:when>
								<%-- 그 외 페이지는 일반 버튼으로 처리 --%>
								<c:otherwise>
									<button class="page-btn"
										onclick="location.href='${pageContext.request.contextPath}/board?page=${pageNum}'">
										${pageNum}</button>
								</c:otherwise>
							</c:choose>
						</c:forEach>

						<%-- [다음] 버튼: 현재 페이지가 마지막 페이지보다 작을 때만 노출 --%>
						<c:if test="${currentPage < totalPages}">
							<button class="page-btn"
								onclick="location.href='${pageContext.request.contextPath}/board?page=${currentPage + 1}'">
								다음 &gt;</button>
						</c:if>
					</div>

				</div>
			</div>
		</main>
	</div>
</body>
</html>