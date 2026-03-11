<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 반복문, 조건문, 변수 처리 등을 위해 필수 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 냉동기 일지 목록</title>

<%-- 사이드바 및 레이아웃 공통 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* [리스트 페이지 전용 스타일] ========================================== */

/* 1. 테이블 행 호버 및 커서 스타일 */
.table tbody tr {
	transition: 0.2s;
	cursor: pointer; /* 행 전체 클릭 가능함을 암시 */
}

.table tbody tr:hover {
	background-color: #f1f3f9; /* 마우스 오버 시 연한 파란색 배경 */
}

/* 2. '새 일지 작성' 버튼 스타일: 냉동기 테마색(초록) 적용 */
.btn-write {
	background: #2e7d32;
	color: #fff;
	padding: 10px 20px;
	border-radius: 6px;
	text-decoration: none;
	font-weight: bold;
	display: inline-flex;
	align-items: center;
	gap: 6px;
	font-size: 0.95rem;
	border: none;
	cursor: pointer;
	transition: 0.2s;
}

.btn-write:hover {
	background: #1b5e20; /* 호버 시 더 짙은 초록색 */
}

/* 3. 카드 상단 타이틀 바 레이아웃 (제목과 버튼 양끝 배치) */
.card-top-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 1px solid #eee;
}

/* 4. 상단 카테고리 전환 탭 스타일 */
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

/* 현재 활성화된 탭(냉동기) 강조 스타일 */
.tab-item.active {
	background: #2e7d32;
	color: #fff;
	box-shadow: 0 2px 5px rgba(46, 125, 50, 0.3);
}
</style>
</head>
<body>
	<div class="app-container">
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
				<%-- 일지 관리 메뉴 활성화 표시 --%>
				<li><a href="${pageContext.request.contextPath}/logs"
					class="active">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자(ADMIN)일 경우에만 관리자 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > 일지 관리 > <strong>냉동기 운전 일지 목록</strong>
				</div>
				<div class="user-info">
					<%-- 현재 로그인한 사용자의 이름과 직급 출력 --%>
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="category-tabs">
					<a
						href="${pageContext.request.contextPath}/logs/list?category=DAILY"
						class="tab-item ">📅 일일 업무</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=ELECTRICITY"
						class="tab-item">⚡수변전</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=CHILLER"
						class="tab-item active">❄️ 냉동기</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=BOILER"
						class="tab-item">🔥 보일러</a>
				</div>

				<div class="card"
					style="background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

					<div class="card-top-row">
						<h3 style="margin: 0; color: #444;">❄️ 냉동기 운전 일지 내역</h3>
						<%-- 신규 냉동기 일지 작성 폼으로 이동 --%>
						<a href="${pageContext.request.contextPath}/logs/chiller"
							class="btn-write">➕새 일지 작성</a>
					</div>

					<table class="table">
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
							<%-- Controller에서 전달받은 'list' (냉동기 일지 리스트) 순회 --%>
							<c:forEach items="${list}" var="log">
								<%-- 행 클릭 시 상세 페이지(lno 기준)로 이동 --%>
								<tr
									onclick="location.href='${pageContext.request.contextPath}/logs/view?lno=${log.lno}'">
									<%-- 작성일자를 초록색으로 강조하여 냉동기 일지임을 표시 --%>
									<td style="font-weight: bold; color: #2e7d32;">${log.log_date}</td>
									<td>${log.worker}</td>
									<td>${log.writer}</td>
									<td>${log.temp}</td>
									<%-- 시스템 등록 시각 출력 --%>
									<td style="color: #888; font-size: 0.85rem;">${log.regdate}</td>
									<td>
										<%-- 
											삭제 버튼: 
											event.stopPropagation()을 호출하여 부모 <tr>의 onclick 이벤트(상세보기 이동)가 터지지 않게 방지 
										--%>
										<button
											onclick="event.stopPropagation(); if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/logs/delete?lno=${log.lno}'"
											style="border: none; background: #f44336; color: #fff; border-radius: 4px; cursor: pointer; padding: 5px 10px;">삭제</button>
									</td>
								</tr>
							</c:forEach>

							<%-- 데이터가 없을 경우 출력될 안내 메시지 --%>
							<c:if test="${empty list}">
								<tr>
									<td colspan="6"
										style="padding: 40px; color: #999; text-align: center;">
										작성된 냉동기 일지가 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
				<%-- .card 종료 --%>
			</div>
			<%-- .content 종료 --%>
		</main>
		<%-- .main-content 종료 --%>
	</div>
	<%-- .app-container 종료 --%>
</body>
</html>