<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 조건문(if, choose), 반복문(forEach) 사용을 위해 필수 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 홈</title>

<%-- 외부 사이드바 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* ==========================================================
   1. 대시보드 전용 스타일 (Dashboard Layout Styles)
   ========================================================== */

/* 상단 카드 내 디지털 시계 스타일 */
.timer-small {
	font-size: 1.8rem;
	font-weight: 700;
	color: #1a237e; /* 강조를 위한 진한 남색 */
	margin-bottom: 15px;
	text-align: center;
}

/* 빠른 근태 버튼 컨테이너 (세로 배치) */
.quick-att-btns {
	display: flex;
	gap: 10px;
	flex-direction: column;
}

/* 퀵 버튼 공통 스타일 */
.btn-quick {
	padding: 12px;
	border-radius: 8px;
	border: none;
	font-weight: bold;
	cursor: pointer;
	color: #fff;
	font-size: 1rem;
	transition: 0.2s;
	text-align: center;
	text-decoration: none; /* a 태그 밑줄 제거 */
}

/* 출근하기 버튼: 초록색 및 부드러운 그림자 */
.btn-quick-in {
	background: #4caf50;
	box-shadow: 0 4px 6px rgba(76, 175, 80, 0.2);
}

/* 퇴근하기 버튼: 빨간색 및 부드러운 그림자 */
.btn-quick-out {
	background: #f44336;
	box-shadow: 0 4px 6px rgba(244, 67, 54, 0.2);
}

/* 버튼 마우스 오버 시 시각적 피드백 */
.btn-quick:hover {
	transform: translateY(-2px); /* 살짝 떠오르는 효과 */
	opacity: 0.9;
}

/* 게시판 테이블 행 호버 효과 */
.table tbody tr {
	transition: 0.2s;
	cursor: pointer;
}

.table tbody tr:hover {
	background-color: #f1f3f9;
}

/* 근태 상태 표시 배지(Badge) 공통 스타일 */
.status-badge {
	padding: 4px 10px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: bold;
}

/* 배지 색상 구분: 정상(녹색), 지각(빨강) */
.status-ok {
	background: #e8f5e9;
	color: #2e7d32;
}

.status-late {
	background: #ffebee;
	color: #c62828;
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
				<%-- 현재 페이지(홈) 활성화 상태 표시 --%>
				<li><a href="${pageContext.request.contextPath}/dashboard"
					class="active">🏠 홈</a></li>
				<li><a href="${pageContext.request.contextPath}/attendance">⏰
						근태 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<li><a href="${pageContext.request.contextPath}/logs">📝 일지
						관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>

				<%-- 관리자 권한(ADMIN)을 가진 세션 사용자에게만 관리자 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > <strong>홈</strong>
				</div>
				<div class="user-info">
					<%-- 현재 로그인한 사용자명과 직급 출력 --%>
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div
					style="display: flex; gap: 25px; align-items: stretch; margin-bottom: 25px;">

					<%-- [좌측 위젯] 빠른 근태 체크 카드 --%>
					<div class="card"
						style="flex: 1; margin-bottom: 0; display: flex; flex-direction: column; justify-content: center;">
						<h3
							style="margin-bottom: 10px; text-align: center; font-size: 0.9rem; color: #666;">빠른
							근태 체크</h3>
						<%-- 자바스크립트에 의해 실시간으로 업데이트되는 시계 영역 --%>
						<div class="timer-small" id="clock">00:00:00</div>
						<div class="quick-att-btns">
							<%-- 
								출퇴근 로직 연동: 
								클릭 시 컨트롤러의 /attendance/checkIn 및 /checkOut 매핑 주소 호출 
							--%>
							<a href="${pageContext.request.contextPath}/attendance/checkIn"
								class="btn-quick btn-quick-in">출근하기</a> <a
								href="${pageContext.request.contextPath}/attendance/checkOut"
								class="btn-quick btn-quick-out">퇴근하기</a>
						</div>
					</div>

					<%-- [우측 위젯] 사내 게시판 최신글 목록 카드 --%>
					<div class="card" style="flex: 2; margin-bottom: 0">
						<div
							style="display: flex; justify-content: space-between; margin-bottom: 20px;">
							<h3>사내 게시판 (최신글)</h3>
							<%-- 게시판 전체 목록으로 이동하는 링크 --%>
							<a href="${pageContext.request.contextPath}/board"
								style="font-size: 0.85rem; color: #666; text-decoration: none">더보기
								></a>
						</div>
						<table class="table">
							<thead>
								<tr>
									<th>제목</th>
									<th>작성자</th>
									<th>날짜</th>
								</tr>
							</thead>
							<tbody>
								<%-- Controller에서 넘겨준 latestPosts 리스트를 순회하며 렌더링 --%>
								<c:forEach items="${latestPosts}" var="post">
									<tr
										onclick="location.href='${pageContext.request.contextPath}/board/detail?bno=${post.bno}'">
										<td style="text-align: left; padding-left: 15px;">${post.title}</td>
										<td>${post.writer}</td>
										<td>${post.regdate}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>

				<%-- 하단 영역: 로그인한 사용자의 가장 최근 근태 기록 1건 표시 --%>
				<div class="card">
					<h3 style="margin-bottom: 15px">나의 최근 근태 내역</h3>
					<table class="table">
						<thead>
							<tr>
								<th>날짜</th>
								<th>출근 시간</th>
								<th>퇴근 시간</th>
								<th>상태</th>
							</tr>
						</thead>
						<tbody>
							<c:choose>
								<%-- 최근 기록(recentAtt 객체)이 존재하는 경우 --%>
								<c:when test="${not empty recentAtt}">
									<tr>
										<td style="font-weight: 600;">${recentAtt.work_date}</td>
										<td style="color: #2e7d32;">${recentAtt.start_time}</td>
										<%-- 
											c:out default 속성을 사용하여 
											퇴근 시간(end_time)이 null일 경우 '근무 중'으로 표시 
										--%>
										<td style="color: #c62828;"><c:out
												value="${recentAtt.end_time}" default="근무 중" /></td>
										<td>
											<%-- 상태값(state)에 따른 배지 출력 분기 로직 --%> <c:choose>
												<c:when test="${recentAtt.state eq '지각'}">
													<span class="status-badge status-late">지각</span>
												</c:when>
												<c:when
													test="${recentAtt.state eq '결근' || recentAtt.state eq '조퇴'}">
													<%-- 결근/조퇴 시 보라색 배지 (status-absent 클래스는 CSS에 정의 필요) --%>
													<span class="status-badge status-absent">${recentAtt.state}</span>
												</c:when>
												<c:otherwise>
													<span class="status-badge status-ok">정상</span>
												</c:otherwise>
											</c:choose>
										</td>
									</tr>
								</c:when>
								<%-- 최근 기록이 전혀 없는 신규 사용자 등을 위한 예외 처리 --%>
								<c:otherwise>
									<tr>
										<td colspan="4"
											style="text-align: center; padding: 30px; color: #999;">
											최근 근태 기록이 없습니다.</td>
									</tr>
								</c:otherwise>
							</c:choose>
						</tbody>
					</table>
				</div>
			</div>
		</main>
	</div>

	<%-- 실시간 디지털 시계 자바스크립트 로직 --%>
	<script>
		function updateClock() {
			// 현재 시간을 'HH:mm:ss' 24시간 형식으로 텍스트 교체
			document.getElementById("clock").innerText = new Date()
					.toLocaleTimeString("ko-KR", {
						hour12 : false
					});
		}
		// 1초(1000ms)마다 updateClock 함수 반복 호출
		setInterval(updateClock, 1000);
		// 페이지 초기 로드 시 시계 즉시 표시
		updateClock();
	</script>
</body>
</html>