<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 조건문(c:if) 및 데이터 출력(c:out) 기능을 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 직원 상세 정보</title>

<%-- 외부 사이드바 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 프로필 상단 영역: 사진(아이콘)과 핵심 정보를 가로로 배치 */
.profile-header {
	display: flex;
	align-items: center;
	gap: 30px;
	margin-bottom: 30px;
	padding-bottom: 20px;
	border-bottom: 2px solid #eee;
}

/* 프로필 기본 이미지(아이콘) 스타일 */
.profile-img {
	width: 120px;
	height: 120px;
	background: #e0e0e0;
	border-radius: 50%; /* 원형 모양 */
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 3rem;
	color: #fff;
}

/* 2. 상세 정보 그리드: 2단 열 구성 */
.info-grid {
	display: grid;
	grid-template-columns: 1fr 1fr; /* 좌우 동일 비율 */
	gap: 20px;
}

/* 개별 정보 항목 줄 스타일 */
.info-item {
	display: flex;
	border-bottom: 1px solid #f0f0f0;
	padding: 12px 0;
}

/* 정보 라벨(제목) 스타일 */
.info-label {
	width: 120px;
	font-weight: bold;
	color: #666;
}

/* 3. 하단 버튼 영역 스타일 */
.btn-group {
	margin-top: 40px;
	display: flex;
	gap: 12px;
	justify-content: flex-end; /* 우측 정렬 */
}

.btn {
	padding: 12px 24px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	border: none;
	transition: 0.2s;
	font-size: 0.95rem;
}

/* 각 버튼별 고유 색상 설정 */
.btn-blue {
	background: #1a237e;
	color: #fff;
}

.btn-gray {
	background: #eee;
	color: #333;
}

.btn-edit-line {
	background: #fff;
	border: 1px solid #007bff;
	color: #007bff;
}

/* 버튼 마우스 오버 시 시각 효과 */
.btn:hover {
	opacity: 0.8;
	transform: translateY(-1px);
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
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<%-- 로그인 사용자가 관리자(ADMIN)일 때만 관리자 모드 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리자 > <strong>직원 상세 정보</strong>
				</div>
				<div class="user-info">
					<%-- 세션에 저장된 로그인 사용자 이름과 직급 --%>
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
					<div class="profile-header">
						<div class="profile-img">👤</div>
						<div>
							<%-- 
								Controller에서 넘겨준 'memberInfo' 객체(MemberVO) 데이터를 바인딩
								상세 정보 대상 직원의 이름, 직급, 사번, 부서 출력 
							--%>
							<h2 style="font-size: 1.8rem">
								${memberInfo.username} <span
									style="font-size: 1rem; color: #888">${memberInfo.job_title}</span>
							</h2>
							<p style="color: #666; margin-top: 5px">사번:
								${memberInfo.userid} | ${memberInfo.dept}</p>
						</div>
					</div>

					<div class="info-grid">
						<div class="info-item">
							<div class="info-label">이메일</div>
							<div>${memberInfo.email}</div>
						</div>
						<div class="info-item">
							<div class="info-label">연락처</div>
							<div>${memberInfo.phone}</div>
						</div>
						<div class="info-item">
							<div class="info-label">입사일</div>
							<div>${memberInfo.regdate}</div>
						</div>
						<div class="info-item">
							<div class="info-label">권한</div>
							<div>${memberInfo.role}</div>
						</div>
						<div class="info-item">
							<div class="info-label">주소</div>
							<div>${memberInfo.address}</div>
						</div>
						<div class="info-item">
							<div class="info-label">상태</div>
							<div>${memberInfo.status}</div>
						</div>
					</div>

					<div class="btn-group">
						<%-- 1. 목록으로: 관리자 메인(직원 리스트) 페이지로 이동 --%>
						<button class="btn btn-gray"
							onclick="location.href='${pageContext.request.contextPath}/admin'">
							목록으로</button>

						<%-- 2. 근태 기록 보기: 쿼리 스트링으로 사번(userid)을 전달하여 해당 직원의 출퇴근 이력 조회 --%>
						<button class="btn btn-blue"
							onclick="location.href='${pageContext.request.contextPath}/admin/attendance/detail?userid=${memberInfo.userid}'">
							근태 기록 보기</button>

						<%-- 3. 정보 수정하기: 쿼리 스트링으로 사번(userid)을 전달하여 수정 폼 페이지로 이동 --%>
						<button class="btn btn-edit-line"
							onclick="location.href='${pageContext.request.contextPath}/admin/edit?userid=${memberInfo.userid}'">
							정보 수정하기</button>
					</div>
				</div>
			</div>
		</main>
	</div>
</body>
</html>
