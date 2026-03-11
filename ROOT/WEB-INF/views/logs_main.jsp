<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 권한 확인 및 로직 처리를 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>태평로빌딩 | 일지 관리</title>

<%-- 사이드바 및 공통 UI 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 일지 선택 카드 컨테이너: Flex 박스를 사용하여 카드들을 가로로 배치 */
.card-container {
	display: flex;
	flex-wrap: wrap; /* 화면 너비에 따라 자동 줄바꿈 허용 */
	gap: 25px; /* 카드 간 간격 */
	margin-top: 20px;
}

/* 2. 일지 개별 카드 스타일 */
.log-card {
	flex: 1;
	min-width: calc(25% - 20px); /* 4개가 한 줄에 균등하게 나오도록 너비 계산 */
	background: #fff;
	border-radius: 12px;
	padding: 40px 20px;
	text-align: center;
	cursor: pointer; /* 클릭 가능한 요소임을 표시 */
	border: 1px solid #eee;
	transition: all 0.3s ease; /* 애니메이션 전환 속도 */
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
}

/* 카드 마우스 오버(Hover) 시 효과: 위로 떠오르며 테두리 색상 강조 */
.log-card:hover {
	transform: translateY(-10px);
	box-shadow: 0 12px 20px rgba(0, 0, 0, 0.1);
	border-color: #2e7d32; /* 일지 시스템의 메인 테마색인 초록색 적용 */
}

/* 3. 카드 내 이모지 아이콘 원형 배경 스타일 */
.icon-circle {
	width: 70px;
	height: 70px;
	background: #f0f2f5;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 20px;
	font-size: 2.2rem;
}

/* 텍스트 가독성 조절 */
h3 {
	margin-bottom: 10px;
}

p {
	font-size: 0.9rem;
	line-height: 1.4;
}

/* 4. 반응형 레이아웃: 태블릿 등 작은 화면에서는 2개씩 배치되도록 조정 */
@media ( max-width : 1024px) {
	.log-card {
		min-width: calc(50% - 25px);
	}
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
				<%-- 현재 페이지(일지 관리) 활성화 상태 표시 --%>
				<li><a href="${pageContext.request.contextPath}/logs"
					class="active">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자 권한(ADMIN) 확인 후 관리자 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>
		<%-- 메인 콘텐츠 영역: 실제 페이지의 데이터와 카드 메뉴가 배치되는 곳 --%>
		<main class="main-content">

			<%-- 헤더 영역: 현재 페이지의 위치(Breadcrumb)와 사용자 정보/로그아웃 버튼 배치 --%>
			<header class="header">
				<%-- 브레드크럼: 사용자의 현재 탐색 경로 표시 --%>
				<div class="breadcrumb">
					관리 시스템 > <strong>일지 관리</strong>
				</div>

				<%-- 사용자 정보 영역: 로그인한 사용자의 이름과 직급 표시 --%>
				<div class="user-info">
					<%-- Controller에서 전달된 member 객체의 성함과 직급을 EL 표현식으로 출력 --%>
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.

					<%-- 로그아웃 버튼: 클릭 시 세션을 종료하는 logout 경로로 이동 --%>
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<%-- 실제 페이지 내용 시작 --%>
			<div class="content">
				<h2>시설 관리 일지</h2>
				<p style="color: #666;">작성 및 조회가 필요한 일지 항목을 선택하세요.</p>

				<%-- 일지 종류별 카드 컨테이너: CSS Flexbox를 통해 가로로 정렬됨 --%>
				<div class="card-container">

					<%-- [카드 1] 일일 업무 일지: 민원 및 일반 점검 기록 --%>
					<div class="log-card"
						<%-- 특정 카테고리 없이 전체 목록(혹은 일반 목록)을 요청 --%>
						onclick="location.href='${pageContext.request.contextPath}/logs/list'">
						<div class="icon-circle">📅</div>
						<h3 style="color: #2e7d32;">일일 업무 일지</h3>
						<p style="color: #888;">
							민원 처리, 시설 점검 및<br>일반 작업 내용 기록
						</p>
					</div>

					<%-- [카드 2] 수변전 일지: 전기 계측 데이터 관리 --%>
					<div class="log-card"
						<%-- category=ELEC 파라미터를 넘겨 전기 관련 일지만 필터링 --%>
						onclick="location.href='${pageContext.request.contextPath}/logs/list?category=ELEC'">
						<div class="icon-circle"
							style="background: #f7f706; color: #2e7d32;">⚡</div>
						<h3 style="color: #2e7d32;">수변전 일지</h3>
						<p style="color: #888;">
							특고압 및 저압반<br>전력 계측 데이터 관리
						</p>
					</div>

					<%-- [카드 3] 터보냉동기 일지: 냉방 계통 수치 기록 --%>
					<div class="log-card"
						<%-- category=CHILLER 파라미터를 넘겨 냉동기 관련 일지만 필터링 --%>
						onclick="location.href='${pageContext.request.contextPath}/logs/list?category=CHILLER'">
						<div class="icon-circle"
							style="background: #e8f5e9; color: #2e7d32;">❄️</div>
						<h3 style="color: #2e7d32;">터보냉동기 일지</h3>
						<p style="color: #888;">
							냉동기 온도, 압력 및<br>순환 계통 2시간 주기 기록
						</p>
					</div>

					<%-- [카드 4] 관류형 보일러 일지: 난방 계통 수치 기록 --%>
					<div class="log-card"
						<%-- category=BOILER 파라미터를 넘겨 보일러 관련 일지만 필터링 --%>
						onclick="location.href='${pageContext.request.contextPath}/logs/list?category=BOILER'">
						<div class="icon-circle"
							style="background: #ffebee; color: #c62828;">🔥</div>
						<h3 style="color: #c62828;">관류형 보일러 일지</h3>
						<p style="color: #888;">
							보일러 증기 압력 및<br>연소 상태 2시간 주기 기록
						</p>
					</div>

				</div>
			</div>
		</main>
	</div>
</body>
</html>