<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 제어문(if, choose), 반복문(forEach) 등을 사용하기 위함 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- JSTL Formatting 태그 라이브러리: 날짜, 숫자 형식화 등을 사용하기 위함 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 직원 근태 기록</title>

<%-- 사이드바 전용 외부 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css" />

<style>
/* 1. 상단 요약 바 레이아웃 */
.summary-bar {
	display: flex;
	gap: 20px;
	margin-bottom: 25px;
}

/* 2. 요약 카드 개별 스타일 (출근일수, 지각 등) */
.summary-card {
	flex: 1;
	background: #f8f9fa;
	padding: 25px;
	border-radius: 10px;
	text-align: center;
}

.summary-label {
	color: #666;
	font-size: 0.9rem;
	margin-bottom: 10px;
}

.summary-value {
	font-size: 1.6rem;
	font-weight: bold;
	color: #1a237e; /* 강조를 위한 진한 남색 */
}

/* 3. 근태 상태 표시 배지 */
.status-badge {
	padding: 6px 12px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: bold;
}

/* 상태별 색상 정의 (성공/위험/경고) */
.badge-ok {
	background: #e8f5e9;
	color: #2e7d32; /* 정상 출근: 초록 계열 */
}

.badge-late {
	background: #ffebee;
	color: #c62828; /* 지각: 빨강 계열 */
}

.badge-absent {
	background: #f3e5f5;
	color: #7b1fa2; /* 결근/조퇴: 보라 계열 */
}

/* 4. 버튼 공통 스타일 */
.btn {
	padding: 12px 25px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	border: none;
	font-size: 0.95rem;
	margin-top: 30px;
}

.btn-gray {
	background: #eee;
	color: #333;
}

.btn-gray:hover {
	background: #ddd;
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
				<li><a href="${pageContext.request.contextPath}/logs">📝
						일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 세션의 권한이 ADMIN인 경우에만 관리자 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="active admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리자 > 직원 상세 > <strong>근태 기록</strong>
				</div>
				<div class="user-info">
					<%-- 현재 로그인한 사용자의 이름과 직급 표시 --%>
					<span style="font-weight: 600; color: #1a237e">${not empty member ? member.username : '직원'}
						${member.job_title} </span>님 반갑습니다.
					<button class="btn-logout"
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card">
					<%-- 조회 대상인 직원의 정보 표시 --%>
					<h2 style="margin-bottom: 25px">[${targetUser.username}
						${targetUser.job_title}] 근태 이력 조회</h2>

					<div class="summary-bar">
						<div class="summary-card">
							<div class="summary-label">이번 달 출근</div>
							<div class="summary-value">${summary.workCount}일</div>
						</div>

						<div class="summary-card">
							<div class="summary-label">정상 출근</div>
							<div class="summary-value" style="color: #2e7d32">${summary.normalCount}회</div>
						</div>

						<div class="summary-card">
							<div class="summary-label">지각</div>
							<div class="summary-value" style="color: #d32f2f">${summary.lateCount}회</div>
						</div>

						<div class="summary-card">
							<div class="summary-label">결근/조퇴</div>
							<div class="summary-value" style="color: #7b1fa2">${summary.absentCount}회</div>
						</div>
					</div>

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
							<%-- attendanceList를 반복하며 행 생성 --%>
							<c:forEach items="${attendanceList}" var="att">
								<tr>
									<td>${att.work_date}</td>
									<td>${att.start_time}</td>
									<%-- 퇴근 시간이 비어있을 경우 '-' 표시 --%>
									<td><c:out value="${att.end_time}" default="-" /></td>
									<td>
										<%-- 근태 상태(state) 값에 따라 다른 배지 출력 --%> <c:choose>
											<c:when test="${att.state eq '지각'}">
												<span class="status-badge badge-late">지각</span>
											</c:when>
											<c:when test="${att.state eq '결근'}">
												<span class="status-badge badge-absent">결근</span>
											</c:when>
											<c:otherwise>
												<span class="status-badge badge-ok">정상출근</span>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							</c:forEach>

							<%-- 근태 기록 데이터가 하나도 없을 경우의 처리 --%>
							<c:if test="${empty attendanceList}">
								<tr>
									<td colspan="4" style="text-align: center; padding: 40px;">근태
										기록이 없습니다.</td>
								</tr>
							</c:if>
						</tbody>
					</table>

					<button class="btn btn-gray" onclick="history.back()">이전
						화면으로</button>
				</div>
			</div>
		</main>
	</div>
</body>
</html>