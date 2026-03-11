<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 반복문(forEach), 조건문(if), 세션 권한 확인 등을 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>태평로빌딩 | 수변전 운전 일지 목록</title>

<%-- 사이드바 및 레이아웃 공통 스타일시트 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* [리스트 페이지 전용 스타일 정의] ========================================== */

/* 1. 테이블을 감싸는 카드형 컨테이너 스타일 */
.table-container {
	background: #fff;
	border-radius: 12px;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
	padding: 30px;
}

/* 2. 리스트 상단부 (제목과 작성 버튼 배치) */
.list-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	border-bottom: 1px solid #eee;
	padding-bottom: 15px;
}

/* 3. '새 일지 작성' 버튼 스타일: 수변전은 주황색(#FF9800) 강조 */
.btn-write {
	background: #FF9800;
	color: #fff;
	padding: 10px 20px;
	border-radius: 6px;
	text-decoration: none;
	font-weight: bold;
	transition: 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 5px;
}

.btn-write:hover {
	background: #F57C00; /* 호버 시 더 짙은 주황색 */
}

/* 4. 개별 행 삭제 버튼 스타일 */
.btn-delete {
	background: #e53935;
	color: #fff;
	border: none;
	padding: 6px 12px;
	border-radius: 4px;
	cursor: pointer;
	font-weight: bold;
	font-size: 0.85rem;
	transition: 0.2s;
}

.btn-delete:hover {
	background: #c62828;
}

/* 5. 데이터 테이블 기본 스타일 */
.list-table {
	width: 100%;
	border-collapse: collapse;
	text-align: center;
}

.list-table th {
	background: #f8f9fa;
	padding: 12px;
	border-bottom: 2px solid #eee;
	color: #444;
	font-weight: bold;
}

.list-table td {
	padding: 15px;
	border-bottom: 1px solid #eee;
	color: #555;
}

/* 테이블 행 마우스 오버 시 효과 */
.list-table tr:hover {
	background-color: #f1f3f9;
	cursor: pointer;
	transition: 0.2s;
}

/* 6. 카테고리 필터 탭 스타일 */
.category-tabs {
	display: flex;
	gap: 10px;
	margin-bottom: 20px;
}

.tab-item {
	padding: 10px 20px;
	border-radius: 20px;
	text-decoration: none;
	font-weight: bold;
	color: #666;
	background: #e0e0e0;
	transition: 0.2s;
	font-size: 0.95rem;
}

.tab-item:hover {
	background: #d0d0d0;
	color: #333;
}

/* 활성화된 탭 (현재 수변전 페이지이므로 주황색 강조) */
.tab-item.active {
	background: #FF9800;
	color: #fff;
	box-shadow: 0 2px 5px rgba(46, 125, 50, 0.3);
}
</style>
</head>
<body>
	<%-- 전체 애플리케이션 레이아웃 시작 --%>
	<div class="app-container">

		<%-- 좌측 사이드바 네비게이션 --%>
		<aside class="sidebar">
			<a href="${pageContext.request.contextPath}/dashboard"
				class="sidebar-logo">태평로빌딩</a>
			<ul class="sidebar-menu">
				<li><a href="${pageContext.request.contextPath}/dashboard">🏠
						홈</a></li>
				<li><a href="${pageContext.request.contextPath}/attendance">⏰
						근태 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<%-- 일지 관리 메뉴를 활성(active) 상태로 표시 --%>
				<li><a href="${pageContext.request.contextPath}/logs"
					class="active">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자(ADMIN)일 때만 관리자 전용 메뉴 출력 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > 일지 관리 > <strong>수변전 일지 목록</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button class="btn-logout"
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; border: 1px solid #ff5252; color: #ff5252; background: none; padding: 4px 8px; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>
			<div class="content">

				<div class="category-tabs">
					<a
						href="${pageContext.request.contextPath}/logs/list?category=DAILY"
						class="tab-item ">📅 일일 업무</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=ELECTRICITY"
						class="tab-item active">⚡수변전</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=CHILLER"
						class="tab-item">❄️ 냉동기</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=BOILER"
						class="tab-item">🔥 보일러</a>
				</div>

				<div class="table-container">
					<%-- 상단 타이틀 및 등록 버튼 --%>
					<div class="list-header">
						<h3 style="margin: 0; color: #333;">⚡ 수변전 일지 목록</h3>
						<%-- 신규 일지 작성 페이지(/logs/elec)로 연결 --%>
						<a href="${pageContext.request.contextPath}/logs/elec"
							class="btn-write">➕ 새 일지 작성</a>
					</div>

					<%-- 실제 목록 테이블 --%>
					<table class="list-table">
						<thead>
							<tr>
								<th width="15%">작성일자</th>
								<th width="30%">근무자</th>
								<th width="15%">작성자</th>
								<th width="10%">외기온도</th>
								<th width="20%">등록시간</th>
								<th width="10%">관리</th>
							</tr>
						</thead>
						<tbody>
							<%-- Controller에서 모델에 담아 보낸 'list' 반복 출력 --%>
							<c:forEach items="${list}" var="log">
								<%-- 행 클릭 시 해당 일지의 상세 보기 페이지로 이동 --%>
								<tr
									onclick="location.href='${pageContext.request.contextPath}/logs/view?lno=${log.lno}'">
									<%-- 작성 일자 강조 --%>
									<td style="font-weight: bold; color: #2e7d32;">${log.log_date}</td>
									<td>${log.worker}</td>
									<td>${log.writer}</td>
									<td>${log.temp}</td>
									<%-- 시스템에 실제로 등록된 시간 --%>
									<td style="color: #888; font-size: 0.85rem;">${log.regdate}</td>
									<td>
										<%-- 
											삭제 버튼: 
											- event.stopPropagation()을 사용하여 tr의 onclick 이벤트(상세보기 이동)가 터지는 것을 방지 
											- confirm으로 사용자 삭제 의사 재확인
										--%>
										<button
											onclick="event.stopPropagation(); if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/logs/delete?lno=${log.lno}'"
											style="border: none; background: #f44336; color: #fff; border-radius: 4px; cursor: pointer; padding: 5px 10px;">삭제</button>
									</td>
								</tr>
							</c:forEach>

							<%-- 목록 데이터가 하나도 없을 경우의 예외 처리 --%>
							<c:if test="${empty list}">
								<tr>
									<td colspan="6"
										style="padding: 40px; color: #999; text-align: center;">
										작성된 수변전 일지가 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>
		</main>
	</div>
</body>
</html>