<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 조건문(if, choose), 반복문(forEach) 사용을 위한 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- JSTL Formatting 태그: 날짜/시간 포맷팅 기능을 제공 (본 페이지 하단 테이블 등에서 활용 가능) --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 근태 관리</title>

<%-- 사이드바 및 공통 레이아웃 스타일시트 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 상단 실시간 시계 및 출퇴근 버튼 영역 */
.timer-box {
	text-align: center;
	padding: 30px 0;
}

.timer {
	font-size: 3.5rem;
	font-weight: 800;
	color: #222;
	margin-bottom: 25px;
	letter-spacing: -1px;
}

.att-btns {
	display: flex;
	gap: 15px;
	justify-content: center;
}

/* 출퇴근 버튼 공통 스타일 */
.btn-att {
	padding: 15px 40px;
	border-radius: 8px;
	border: none;
	font-weight: bold;
	cursor: pointer;
	color: #fff;
	font-size: 1.1rem;
	transition: 0.2s;
}

/* 출근 버튼: 녹색 계열 */
.btn-in {
	background: #4caf50;
	box-shadow: 0 4px 10px rgba(76, 175, 80, 0.3);
}

.btn-in:hover {
	background: #43a047;
}

/* 퇴근 버튼: 빨간색 계열 */
.btn-out {
	background: #f44336;
	box-shadow: 0 4px 10px rgba(244, 67, 54, 0.3);
}

.btn-out:hover {
	background: #e53935;
}

/* 2. 상단 통계 카드 레이아웃 (이번 달 요약) */
.stats-container {
	display: flex;
	justify-content: space-between;
	gap: 20px;
	margin-bottom: 20px;
}

.stat-box {
	flex: 1;
	background: #f8f9fa;
	border-radius: 10px;
	padding: 20px;
	text-align: center;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.05);
}

.stat-title {
	font-size: 0.9rem;
	color: #666;
	margin-bottom: 10px;
}

.stat-value {
	font-size: 1.8rem;
	font-weight: bold;
	color: #1a237e;
}

/* 3. 테이블 내 근태 상태 표시 배지 */
.status-badge {
	padding: 4px 10px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: bold;
}

/* 상태별 배지 색상 (정상: 녹색, 지각: 빨강, 기타: 보라) */
.status-ok {
	background: #e8f5e9;
	color: #2e7d32;
}

.status-late {
	background: #ffebee;
	color: #c62828;
}

.status-absent {
	background: #f3e5f5;
	color: #7b1fa2;
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
				<%-- 현재 페이지(근태 관리) 활성화 표시 --%>
				<li><a href="${pageContext.request.contextPath}/attendance"
					class="active">⏰ 근태 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<li><a href="${pageContext.request.contextPath}/logs">📝 일지
						관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자 권한(ADMIN)일 때만 관리자 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > <strong>근태 관리</strong>
				</div>
				<div class="user-info">
					<%-- 세션에 담긴 현재 로그인 사용자 이름과 직급 출력 --%>
					<span style="font-weight: 600; color: #1a237e"> ${not empty member ? member.username : '직원'}
						${member.job_title} </span>님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card" style="margin-bottom: 20px;">
					<div class="timer-box">
						<div style="color: #666; margin-bottom: 10px; font-weight: 600">현재
							시간</div>
						<%-- 자바스크립트에 의해 실시간으로 변하는 영역 --%>
						<div class="timer" id="clock">00:00:00</div>
						<div class="att-btns">
							<%-- 출근/퇴근 클릭 시 각각의 매핑 주소로 이동 (insertCheckInDao / updateCheckOutDao 실행) --%>
							<button class="btn-att btn-in"
								onclick="location.href='${pageContext.request.contextPath}/attendance/checkIn'">출근하기</button>
							<button class="btn-att btn-out"
								onclick="location.href='${pageContext.request.contextPath}/attendance/checkOut'">퇴근하기</button>
						</div>
					</div>
				</div>

				<div class="stats-container">
					<div class="card stat-box">
						<div class="stat-title">이번 달 총 출근</div>
						<div class="stat-value">${summary.workCount}일</div>
					</div>
					<div class="card stat-box">
						<div class="stat-title">정상 출근</div>
						<div class="stat-value" style="color: #4caf50;">${summary.normalCount}회</div>
					</div>
					<div class="card stat-box">
						<div class="stat-title">지각</div>
						<div class="stat-value" style="color: #ff9800;">${summary.lateCount}회</div>
					</div>
					<div class="card stat-box">
						<div class="stat-title">결근/조퇴</div>
						<div class="stat-value" style="color: #f44336;">${summary.absentCount}회</div>
					</div>
				</div>

				<div class="card">
					<h3 style="margin-bottom: 20px">내 출퇴근 내역</h3>
					<table class="table">
						<thead>
							<tr>
								<th>일자</th>
								<th>출근시간</th>
								<th>퇴근시간</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
							<%-- 개인 근태 리스트(attendanceList) 반복 출력 --%>
							<c:forEach items="${attendanceList}" var="att">
								<tr>
									<td>${att.work_date}</td>
									<td>${att.start_time}</td>
									<%-- 퇴근 시간이 없는 경우(DB상 null) '근무중'으로 기본값 처리 --%>
									<td><c:out value="${att.end_time}" default="근무중" /></td>
									<td>
										<%-- 상태값(state)에 따라 배지 색상 및 텍스트 동적 변경 --%> <c:choose>
											<c:when test="${att.state eq '지각'}">
												<span class="status-badge status-late">지각</span>
											</c:when>
											<c:when test="${att.state eq '결근' || att.state eq '조퇴'}">
												<span class="status-badge status-absent">${att.state}</span>
											</c:when>
											<c:otherwise>
												<span class="status-badge status-ok">정상</span>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:forEach>
							<%-- 기록이 없을 때의 예외 처리 --%>
							<c:if test="${empty attendanceList}">
								<tr>
									<td colspan="4" style="text-align: center; padding: 20px;">출퇴근
										기록이 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>
				</div>
			</div>
		</main>
	</div>

	<%-- 실시간 디지털 시계 구현 스크립트 --%>
	<script>
		function updateClock() {
			const now = new Date();
			// ko-KR 로케일을 사용하여 한국 표준시에 맞는 24시간 형식 문자열 생성
			const timeString = now.toLocaleTimeString("ko-KR", {
				hour12 : false
			});
			document.getElementById("clock").innerText = timeString;
		}
		// 1초(1000ms)마다 updateClock 함수 반복 실행
		setInterval(updateClock, 1000);
		// 페이지 로드 즉시 한 번 실행 (초기 00:00:00 방지)
		updateClock();
	</script>
</body>
</html>
