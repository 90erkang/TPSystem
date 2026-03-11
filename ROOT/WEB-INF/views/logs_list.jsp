<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 반복문(forEach), 조건문(if) 등을 사용하기 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 일지 목록</title>
<%-- 사이드바 및 공통 레이아웃 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">
<style>
/* 1. 테이블 행 호버 효과 및 클릭 커서 설정 */
.table tbody tr {
	transition: 0.2s;
	cursor: pointer;
}

.table tbody tr:hover {
	background-color: #f1f3f9;
}

/* 2. '새 일지 작성' 버튼 스타일 (Flexbox를 이용한 아이콘/텍스트 정렬) */
.btn-write {
	background: #1a237e;
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
	background: #0d165e;
}

/* 3. 카드 상단 타이틀 바 레이아웃 */
.card-top-row {
	display: flex;
	align-items: center;
	gap: 15px;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 1px solid #eee;
}

/* 4. 상단 카테고리 필터 탭 스타일 */
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

/* 탭 활성화(현재 선택된 카테고리) 시 스타일 */
.tab-item.active {
	background: #1a237e;
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
				<%-- 일지 관리 메뉴 활성화 상태 유지 --%>
				<li><a href="${pageContext.request.contextPath}/logs"
					class="active">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자 권한(ADMIN) 확인 후 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > 일지 관리 > <strong>일지 목록</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>
			<%-- 간편 메뉴 출력 --%>
			<div class="content">
				<div class="category-tabs">
					<a
						href="${pageContext.request.contextPath}/logs/list?category=DAILY"
						class="tab-item active">📅 일일 업무</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=ELECTRICITY"
						class="tab-item">⚡수변전</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=CHILLER"
						class="tab-item">❄️ 냉동기</a> <a
						href="${pageContext.request.contextPath}/logs/list?category=BOILER"
						class="tab-item">🔥 보일러</a>
				</div>
				<%-- 새 일지 작성 버튼 --%>
				<div class="card"
					style="background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

					<div class="card-top-row"
						style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; padding-bottom: 15px; border-bottom: 1px solid #eee;">
						<h3 style="margin: 0; color: #444;">📅 작성된 일지 내역</h3>
						<a href="${pageContext.request.contextPath}/logs/daily"
							class="btn-write">➕ 새 일지 작성</a>
					</div>
					<%-- 일지 내용 간편 보기 --%>
					<table class="table">
						<thead>
							<tr>
								<th width="15%">작성일자</th>
								<th width="30%">근무자</th>
								<th width="15%">작성자</th>
								<th width="10%">온도</th>
								<th width="20%">등록시간</th>
								<th width="10%">관리</th>
							</tr>
						</thead>
						<tbody>
							<%-- Controller에서 모델에 담아 보낸 'list' (LogsVO 리스트) 순회 출력 --%>
							<c:forEach items="${list}" var="log">
								<%-- 행 클릭 시 해당 일지의 상세 보기(/logs/view?lno=번호)로 이동 --%>
								<tr
									onclick="location.href='${pageContext.request.contextPath}/logs/view?lno=${log.lno}'">
									<td style="font-weight: bold; color: #1a237e;">${log.log_date}</td>
									<td>${log.worker}</td>
									<td>${log.writer}</td>
									<td>${log.temp}</td>
									<td style="color: #888; font-size: 0.85rem;">${log.regdate}</td>
									<td>
										<%-- 
											삭제 버튼: 
											event.stopPropagation()을 사용하여 행 클릭 이벤트(상세보기 이동)가 발생하는 것을 방지 
										--%>
										<button
											onclick="event.stopPropagation(); if(confirm('삭제하시겠습니까?')) location.href='${pageContext.request.contextPath}/logs/delete?lno=${log.lno}'"
											style="border: none; background: #f44336; color: #fff; border-radius: 4px; cursor: pointer; padding: 5px 10px;">삭제</button>
									</td>
								</tr>
							</c:forEach>

							<%-- 리스트가 비어있을 경우의 예외 처리 --%>
							<c:if test="${empty list}">
								<tr>
									<td colspan="6"
										style="padding: 40px; color: #999; text-align: center;">작성된
										일지가 없습니다.</td>
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