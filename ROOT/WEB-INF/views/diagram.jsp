<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 권한에 따른 메뉴 노출 등 조건 로직 처리를 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>태평로빌딩 | 계통도 관리</title>

<%-- 사이드바 및 공통 레이아웃 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 카드 컨테이너: 카드들을 가로로 나열하고 간격을 설정 */
.card-container {
	display: flex;
	gap: 25px;
	margin-top: 20px;
}

/* 2. 계통도 선택 카드 개별 스타일 */
.diagram-card {
	flex: 1; /* 부모 컨테이너 안에서 동일한 너비를 가짐 */
	background: #fff;
	border-radius: 12px;
	padding: 50px 20px;
	text-align: center;
	cursor: pointer; /* 클릭 가능한 요소임을 표시 */
	border: 1px solid #eee;
	transition: all 0.3s ease; /* 부드러운 애니메이션 효과 전환 속도 */
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

/* 카드 마우스 오버(Hover) 시 효과: 살짝 떠오르며 그림자가 짙어짐 */
.diagram-card:hover {
	transform: translateY(-10px); /* 위로 10px 이동 */
	box-shadow: 0 12px 20px rgba(0, 0, 0, 0.1);
	border-color: #1a237e; /* 테두리 강조색 */
}

/* 3. 카드 내 아이콘 배경 원형 스타일 */
.icon-circle {
	width: 80px;
	height: 80px;
	background: #f0f2f5;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 20px;
	font-size: 2.5rem;
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
				<%-- 현재 페이지(계통도) 활성화 상태 표시 --%>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<li><a href="${pageContext.request.contextPath}/logs">📝 일지
						관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자(ADMIN) 권한 확인 후 전용 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > <strong>계통도 관리</strong>
				</div>
				<div class="user-info">
					<%-- 세션에 담긴 사용자 이름과 직급 출력 --%>
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<h2>계통도 조회</h2>
				<p style="color: #666;">주요 계통도를 선택하여 상세 내용을 확인하세요.</p>

				<div class="card-container">

					<div class="diagram-card"
						onclick="location.href='${pageContext.request.contextPath}/diagram/electrical'">
						<div class="icon-circle">⚡</div>
						<h3 style="color: #1a237e;">수변전실 계통도</h3>
						<p style="color: #888; margin-top: 10px;">특고압 수전 및 변압기 배전 계통</p>
					</div>

					<div class="diagram-card"
						onclick="location.href='${pageContext.request.contextPath}/diagram/hvac'">
						<div class="icon-circle">💨</div>
						<h3 style="color: #1a237e;">중앙 냉난방 계통도</h3>
						<p style="color: #888; margin-top: 10px;">냉동기, 관류형 보일러 및 공조 설비
							계통</p>
					</div>

				</div>
			</div>
		</main>
	</div>
</body>
</html>