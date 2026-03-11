<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 조건문(c:if) 등을 사용하여 동적으로 화면을 제어하기 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 직원 정보 수정</title>

<%-- 사이드바 공통 스타일시트 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">
<style>
/* 1. 수정 폼 레이아웃: CSS Grid를 이용한 2열 배열 */
.edit-form {
	display: grid;
	grid-template-columns: 1fr 1fr; /* 좌우 1:1 비율 */
	gap: 25px;
}

/* 2. 입력 항목 스타일: 라벨과 인풋을 세로로 정렬 */
.form-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

/* 라벨 스타일 */
.form-group label {
	font-weight: 600;
	color: #1a237e;
	font-size: 0.9rem;
}

/* 입력창 및 셀렉트 박스 공통 스타일 */
.form-group input, .form-group select {
	padding: 12px 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 1rem;
	font-family: inherit;
}

/* 읽기 전용(사번) 입력창 스타일: 배경색을 흐리게 하고 커서를 금지 모양으로 변경 */
.readonly-input {
	background-color: #f8f9fa;
	color: #888;
	cursor: not-allowed;
}

/* 3. 하단 버튼 영역: 2열을 모두 차지(span 2)하도록 설정 */
.btn-group {
	grid-column: span 2;
	margin-top: 40px;
	display: flex;
	gap: 12px;
	justify-content: flex-end;
	padding-top: 25px;
	border-top: 1px solid #eee;
}

.btn {
	padding: 12px 28px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	border: none;
	font-size: 1rem;
	transition: 0.2s;
}

/* 취소 버튼 스타일 */
.btn-cancel {
	background: #eee;
	color: #333;
}

/* 저장 버튼 스타일: 진한 남색으로 강조 */
.btn-save {
	background: #1a237e;
	color: #fff;
}

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
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<li><a href="${pageContext.request.contextPath}/logs">📝
						일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>
				<%-- 관리자(ADMIN) 권한일 때만 관리자 모드 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리자 > 직원 상세 > <strong>정보 수정</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e">${not empty member ? member.username : '직원'}
						${member.job_title} </span>님 반갑습니다.
					<button class="btn-logout"
						onclick="location.href='${pageContext.request.contextPath}/logout'">로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card">
					<h2 style="margin-bottom: 30px; color: #d32f2f">⚙️ 직원 계정 정보 수정</h2>

					<%-- 
						데이터 수정 폼 시작 
						action: 수정을 처리할 서버 컨트롤러의 매핑 주소
						method: 데이터 전송 시 POST 방식 사용
					--%>
					<form
						action="${pageContext.request.contextPath}/admin/memberUpdate"
						method="post" class="edit-form">

						<%-- 1행: 사번(수정불가) | 이름 --%>
						<div class="form-group">
							<label>사번 (아이디)</label>
							<%-- 사번은 Primary Key이므로 수정할 수 없도록 readonly 설정 --%>
							<input type="text" name="userid" value="${memberInfo.userid}"
								class="readonly-input" readonly />
						</div>
						<div class="form-group">
							<label>이름</label> <input type="text" name="username"
								value="${memberInfo.username}" required />
						</div>

						<%-- 2행: 비밀번호 | 부서 --%>
						<div class="form-group">
							<label>비밀번호 수정</label> <input type="password" name="userpwd"
								value="${memberInfo.userpwd}" placeholder="새 비밀번호 입력" required />
						</div>
						<div class="form-group">
							<label>부서</label> <select name="dept" required>
								<%-- EL의 삼항 연산자를 사용하여 기존 부서가 선택(selected)되도록 처리 --%>
								<option value="기계팀"
									${memberInfo.dept eq '기계팀' ? 'selected' : ''}>기계팀</option>
								<option value="전기팀"
									${memberInfo.dept eq '전기팀' ? 'selected' : ''}>전기팀</option>
								<option value="방재팀"
									${memberInfo.dept eq '방재팀' ? 'selected' : ''}>방재팀</option>
								<option value="설비팀"
									${memberInfo.dept eq '설비팀' ? 'selected' : ''}>설비팀</option>
								<option value="통신팀"
									${memberInfo.dept eq '통신팀' ? 'selected' : ''}>통신팀</option>
							</select>
						</div>

						<%-- 3행: 직급 | 시스템 권한 --%>
						<div class="form-group">
							<label>직급</label> <select name="job_title">
								<%-- c:if 태그를 사용하여 해당 직급이 선택(selected)되도록 처리 --%>
								<option value="기사"
									<c:if test="${memberInfo.job_title eq '기사'}">selected</c:if>>기사</option>
								<option value="주임"
									<c:if test="${memberInfo.job_title eq '주임'}">selected</c:if>>주임</option>
								<option value="대리"
									<c:if test="${memberInfo.job_title eq '대리'}">selected</c:if>>대리</option>
								<option value="과장"
									<c:if test="${memberInfo.job_title eq '과장'}">selected</c:if>>과장</option>
								<option value="차장"
									<c:if test="${memberInfo.job_title eq '차장'}">selected</c:if>>차장</option>
								<option value="부장"
									<c:if test="${memberInfo.job_title eq '부장'}">selected</c:if>>부장</option>
								<option value="팀장"
									<c:if test="${memberInfo.job_title eq '팀장'}">selected</c:if>>팀장</option>
								<option value="소장"
									<c:if test="${memberInfo.job_title eq '소장'}">selected</c:if>>소장</option>
								<option value="사장"
									<c:if test="${memberInfo.job_title eq '사장'}">selected</c:if>>사장</option>
							</select>
						</div>
						<div class="form-group">
							<label>시스템 권한</label> <select name="role">
								<option value="USER"
									<c:if test="${memberInfo.role eq 'USER'}">selected</c:if>>일반
									사용자 (USER)</option>
								<option value="ADMIN"
									<c:if test="${memberInfo.role eq 'ADMIN'}">selected</c:if>>관리자
									(ADMIN)</option>
							</select>
						</div>

						<%-- 4행: 재직 상태 | 연락처 --%>
						<div class="form-group">
							<label>상태</label> <select name="status">
								<option value="재직"
									<c:if test="${memberInfo.status eq '재직'}">selected</c:if>>재직</option>
								<option value="휴직"
									<c:if test="${memberInfo.status eq '휴직'}">selected</c:if>>휴직</option>
								<option value="퇴사"
									<c:if test="${memberInfo.status eq '퇴사'}">selected</c:if>>퇴사</option>
							</select>
						</div>
						<div class="form-group">
							<label>연락처</label> <input type="text" name="phone"
								value="${memberInfo.phone}" />
						</div>

						<%-- 5행: 이메일 | 주소 --%>
						<div class="form-group">
							<label>이메일</label> <input type="email" name="email"
								value="${memberInfo.email}" />
						</div>
						<div class="form-group">
							<label>주소</label> <input type="text" name="address"
								value="${memberInfo.address}" />
						</div>

						<%-- 하단 버튼: 이전 페이지 이동 및 폼 제출 --%>
						<div class="btn-group">
							<button type="button" class="btn btn-cancel"
								onclick="history.back()">취소</button>
							<button type="submit" class="btn btn-save">수정 내용 저장</button>
						</div>
					</form>
				</div>
			</div>
		</main>
	</div>
</body>
</html>