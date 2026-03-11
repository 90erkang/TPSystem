<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 반복문(forEach), 조건문(choose) 등을 사용하기 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 관리자 모드</title>

<%-- 외부 사이드바 스타일시트 연결 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 관리자 전용 필터 바: 부서, 상태 선택 및 키워드 검색 영역 */
.filter-bar {
	background: #f8f9fa;
	padding: 20px;
	border-radius: 8px;
	margin-bottom: 25px;
	display: flex;
	align-items: center;
	gap: 12px;
	flex-wrap: nowrap; /* 항목들이 한 줄에 배치되도록 설정 */
}

.filter-group {
	display: flex;
	align-items: center;
	gap: 8px;
	white-space: nowrap;
}

.filter-bar select, .filter-bar input {
	padding: 10px 12px;
	border: 1px solid #ddd;
	border-radius: 6px;
	font-family: inherit;
	font-size: 0.95rem;
}

/* 2. 버튼 공통 및 개별 스타일 */
.btn {
	padding: 10px 20px;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	font-weight: bold;
	transition: 0.2s;
	font-size: 0.95rem;
	white-space: nowrap;
}

/* 검색 버튼: 검정색 계열 */
.btn-search {
	background: #333;
	color: #fff;
}

.btn-search:hover {
	background: #000;
}

/* 직원 등록 버튼: 진한 남색 */
.btn-create {
	background: #1a237e;
	color: #fff;
}

.btn-create:hover {
	background: #0d145a;
}

/* 수정 버튼: 흰색 배경에 파란 테두리 */
.btn-edit {
	padding: 5px 12px;
	background: #fff;
	border: 1px solid #007bff;
	color: #007bff;
	font-size: 0.85rem;
}

.btn-edit:hover {
	background: #007bff;
	color: #fff;
}

/* 3. 역할 및 상태 표시 배지(Badge) 스타일 */
.badge {
	padding: 4px 12px;
	border-radius: 20px;
	font-size: 0.8rem;
	font-weight: bold;
}

/* 권한 배지 색상 (ADMIN: 노랑, USER: 회색) */
.badge-admin {
	background: #fff3cd;
	color: #856404;
}

.badge-user {
	background: #e2e3e5;
	color: #383d41;
}

/* 상태 배지 색상 (재직: 초록, 기타: 빨강) */
.badge-work {
	background: #e8f5e9;
	color: #2e7d32;
}

.badge-out {
	background: #ffebee;
	color: #c62828;
}

/* 4. 테이블 행(Row) 호버 및 클릭 유도 효과 */
.table tbody tr {
	transition: 0.2s;
	cursor: pointer;
}

.table tbody tr:hover {
	background-color: #f1f3f9;
}

.table tr:hover td strong {
	color: #1a237e;
	text-decoration: underline;
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
				<li><a href="${pageContext.request.contextPath}/logs">📝 일지
						관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 현재 페이지 활성화 상태 표시 --%>
				<li><a href="${pageContext.request.contextPath}/admin"
					class="admin-menu">⚙️ 관리자 모드</a></li>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > <strong>관리자 모드</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e">${not empty member ? member.username : '직원'}
						${member.job_title} </span>님 반갑습니다.
					<button class="btn-logout"
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<h2 style="margin-bottom: 25px; color: #d32f2f">⚙️ 직원 계정 관리</h2>

				<%-- 카드 섹션: 검색 조건과 테이블 리스트를 감싸는 컨테이너 --%>
				<div class="card">

					<%-- 1. 검색 및 필터 폼: GET 방식을 사용하여 현재 검색 조건을 URL에 유지 --%>
					<form action="${pageContext.request.contextPath}/admin"
						method="get" class="filter-bar">

						<div class="filter-group">
							<label>부서</label> <select name="searchDept">
								<option value="">전체</option>
								<%-- param 객체를 통해 사용자가 선택했던 값을 유지(selected) --%>
								<option value="기계팀"
									${param.searchDept eq '기계팀' ? 'selected' : ''}>기계팀</option>
								<option value="전기팀"
									${param.searchDept eq '전기팀' ? 'selected' : ''}>전기팀</option>
								<option value="방재팀"
									${param.searchDept eq '방재팀' ? 'selected' : ''}>방재팀</option>
								<option value="설비팀"
									${param.searchDept eq '설비팀' ? 'selected' : ''}>설비팀</option>
								<option value="통신팀"
									${param.searchDept eq '통신팀' ? 'selected' : ''}>통신팀</option>
							</select>
						</div>

						<div class="filter-group">
							<label>상태</label> <select name="searchStatus">
								<option value="">전체</option>
								<option value="재직"
									${param.searchStatus eq '재직' ? 'selected' : ''}>재직</option>
								<option value="휴직"
									${param.searchStatus eq '휴직' ? 'selected' : ''}>휴직</option>
								<option value="퇴사"
									${param.searchStatus eq '퇴사' ? 'selected' : ''}>퇴사</option>
							</select>
						</div>

						<div class="filter-group" style="flex-grow: 1">
							<input type="text" name="searchKeyword"
								value="${param.searchKeyword}" placeholder="사번 또는 이름으로 검색"
								style="width: 100%" />
						</div>

						<button type="submit" class="btn btn-search">검색</button>

						<%-- 신규 직원 등록 페이지 이동 버튼 --%>
						<button type="button" class="btn btn-create"
							onclick="location.href='${pageContext.request.contextPath}/admin/register'">
							직원 등록</button>
					</form>

					<%-- 2. 직원 데이터 리스트 테이블 --%>
					<table class="table">
						<thead>
							<tr>
								<th>사번</th>
								<th>이름</th>
								<th>부서</th>
								<th>직급</th>
								<th>권한</th>
								<th>상태</th>
								<th>입사일</th>
								<th>관리</th>
							</tr>
						</thead>
						<tbody>
							<%-- Controller에서 전달받은 memberList를 순회하며 행 생성 --%>
							<c:forEach items="${memberList}" var="mem">
								<%-- 행 클릭 시 해당 직원의 상세 정보 페이지로 이동 --%>
								<tr
									onclick="location.href='${pageContext.request.contextPath}/admin/detail?userid=${mem.userid}'">
									<td>${mem.userid}</td>
									<td><strong>${mem.username}</strong></td>
									<td>${mem.dept}</td>
									<td>${mem.job_title}</td>

									<%-- 권한 표시: ADMIN과 USER 구분 배지 --%>
									<td><c:choose>
											<c:when test="${mem.role eq 'ADMIN'}">
												<span class="badge badge-admin">ADMIN</span>
											</c:when>
											<c:otherwise>
												<span class="badge badge-user">USER</span>
											</c:otherwise>
										</c:choose></td>

									<%-- 상태 표시: 재직 여부에 따른 배지 색상 구분 --%>
									<td><c:choose>
											<c:when test="${mem.status eq '재직'}">
												<span class="badge badge-work">재직</span>
											</c:when>
											<c:otherwise>
												<span class="badge badge-out">${mem.status}</span>
											</c:otherwise>
										</c:choose></td>

									<td>${mem.regdate}</td>

									<td>
										<%-- 
											수정 버튼 클릭 시 상세 페이지로의 이동(tr onclick)을 방지하기 위해 
											event.stopPropagation() 사용 
										--%>
										<button class="btn btn-edit"
											onclick="event.stopPropagation(); location.href='${pageContext.request.contextPath}/admin/edit?userid=${mem.userid}'">
											수정</button>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

					<div
						style="display: flex; justify-content: center; margin-top: 30px; gap: 8px;">
						<button class="btn" style="background: #eee">이전</button>
						<button class="btn" style="background: #1a237e; color: #fff">1</button>
						<button class="btn" style="background: #eee">다음</button>
					</div>

				</div>
			</div>
		</main>
	</div>
</body>
</html>
