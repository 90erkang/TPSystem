<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 목록 출력(forEach) 및 조건문(if) 처리를 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 보일러 일지 목록</title>

<%-- 사이드바 및 공통 레이아웃 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* [보일러 리스트 전용 스타일 정의] ========================================== */

/* 1. '새 일지 작성' 버튼 스타일: 보일러의 열기를 상징하는 붉은색(#c62828) 적용 */
.btn-write {
	background: #c62828;
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
	background: #b71c1c; /* 호버 시 더 짙은 붉은색 */
}

/* 2. 카드 상단 제목 바 레이아웃 (제목과 버튼을 양끝에 배치) */
.card-top-row {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 1px solid #eee;
}

/* 3. 상단 카테고리 필터 탭 스타일 */
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

/* 4. 활성화된 탭 (현재 보일러 페이지이므로 붉은색으로 강조 및 그림자 효과) */
.tab-item.active {
	background: #c62828;
	color: #fff;
	box-shadow: 0 2px 5px rgba(198, 40, 40, 0.3);
}

/* 테이블 공통 호버 효과 */
.table tbody tr {
	transition: 0.2s;
	cursor: pointer;
}

.table tbody tr:hover {
	background-color: #f1f3f9;
}
</style>
</head>
<body>
	<%-- 전체 애플리케이션 레이아웃 시작 --%>
	<div class="app-container">

		<%-- 좌측 사이드바 영역 --%>
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
				<%-- 일지 관리 메뉴를 활성(active) 상태로 유지 --%>
				<li><a href="${pageContext.request.contextPath}/logs"
					class="active">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자(ADMIN) 권한일 경우에만 전용 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<%-- 우측 메인 콘텐츠 본문 영역 --%>
		<main class="main-content">
			<%-- 헤더: 현재 페이지 위치(Breadcrumb)와 사용자 로그인 정보 --%>
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > 일지 관리 > <strong>보일러 운전 일지 목록</strong>
				</div>
				<div class="user-info">
					<%-- 로그인 세션에 저장된 사용자 이름과 직급 출력 --%>
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<%-- 실제 본문 내용 섹션 --%>
			<div class="content">

				<div class="category-tabs">
					<a
						href="${pageContext.request.contextPath}/logs/list?category=DAILY"
						class="tab-item ">📅 일일 업무</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=ELECTRICITY"
						class="tab-item">⚡수변전</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=CHILLER"
						class="tab-item">❄️ 냉동기</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=BOILER"
						class="tab-item active">🔥 보일러</a>
				</div>

				<div class="card"
					style="background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

					<%-- 카드 상단: 제목 및 등록 버튼 --%>
					<div class="card-top-row">
						<h3 style="margin: 0; color: #444;">🔥 보일러 운전 일지 내역</h3>
						<%-- 신규 보일러 작성 폼(/logs/boiler)으로 이동 --%>
						<a href="${pageContext.request.contextPath}/logs/boiler"
							class="btn-write">➕새 일지 작성</a>
					</div>

					<%-- 보일러 일지 목록 테이블 --%>
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
							<%-- Controller에서 모델에 담아 보낸 'list' (BOILER 카테고리 리스트) 반복 출력 --%>
							<c:forEach items="${list}" var="log">
								<%-- 행 클릭 시 해당 일지의 상세 보기 페이지로 이동 --%>
								<tr
									onclick="location.href='${pageContext.request.contextPath}/logs/view?lno=${log.lno}'">
									<%-- 보일러 테마에 맞춰 작성일자를 붉은색으로 강조 --%>
									<td style="font-weight: bold; color: #c62828;">${log.log_date}</td>
									<td>${log.worker}</td>
									<td>${log.writer}</td>
									<td>${log.temp}</td>
									<%-- 시스템에 실제 저장된 등록 일시 --%>
									<td style="color: #888; font-size: 0.85rem;">${log.regdate}</td>
									<td>
										<%-- 
											삭제 버튼: 
											- event.stopPropagation()을 호출하여 부모 <tr>의 onclick 이벤트(상세보기 이동)가 터지는 것을 방지 
											- 사용자에게 최종 삭제 여부를 확인하는 컨펌창 출력 
										--%>
										<button
											onclick="event.stopPropagation(); if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/logs/delete?lno=${log.lno}'"
											style="border: none; background: #f44336; color: #fff; border-radius: 4px; cursor: pointer; padding: 5px 10px;">삭제</button>
									</td>
								</tr>
							</c:forEach>

							<%-- 목록 데이터가 비어있을 경우의 예외 처리 --%>
							<c:if test="${empty list}">
								<tr>
									<td colspan="6"
										style="padding: 40px; color: #999; text-align: center;">
										작성된 보일러 일지가 없습니다.</td>
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