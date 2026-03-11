<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 신규 직원 등록</title>

<%-- ★ 핵심 수정 1: /css/ 폴더 제거 (사용자님 설정에 맞춤) --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css" />

<style>
/* 등록 폼 전용 스타일 */
.edit-form {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 25px;
}

.form-group {
	display: flex;
	flex-direction: column;
	gap: 8px;
}

.form-group.full-width {
	grid-column: span 2;
}

.form-group label {
	font-weight: 600;
	color: #1a237e;
	font-size: 0.9rem;
}

.form-group label span {
	color: #d32f2f;
	margin-left: 3px;
} /* 필수 표시 */
.form-group input, .form-group select {
	padding: 12px 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 1rem;
	font-family: inherit;
}

.form-group input:focus {
	border-color: #1a237e;
	outline: none;
	box-shadow: 0 0 0 3px rgba(26, 35, 126, 0.1);
}

/* 버튼 영역 */
.btn-group {
	margin-top: 40px;
	display: flex;
	gap: 12px;
	justify-content: flex-end;
	padding-top: 25px;
	border-top: 1px solid #eee;
}

.btn {
	padding: 12px 30px;
	border-radius: 6px;
	font-weight: 600;
	cursor: pointer;
	border: none;
	font-size: 1rem;
	transition: 0.2s;
}

.btn-cancel {
	background: #eee;
	color: #333;
}

.btn-save {
	background: #2e7d32;
	color: #fff;
} /* 등록은 초록색 계열로 강조 */
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
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리자 > <strong>신규 직원 등록</strong>
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
				<div class="card">
					<h2 style="margin-bottom: 30px; color: #1a237e">👤 신규 직원 등록</h2>

					<form class="edit-form"
						action="${pageContext.request.contextPath}/admin/register"
						method="post">
						<div class="form-group">
							<label>사번 (아이디)<span>*</span></label> <input type="text"
								name="userid" placeholder="예: 2025000" required />
						</div>

						<div class="form-group">
							<label>초기 비밀번호<span>*</span></label> <input type="password"
								name="userpwd" placeholder="비밀번호 설정" required />
						</div>

						<div class="form-group">
							<label>이름<span>*</span></label> <input type="text"
								name="username" placeholder="성명을 입력하세요" required />
						</div>

						<div class="form-group">
							<label>부서<span>*</span></label> <select name="dept" required>
								<option value="" disabled selected>부서 선택</option>
								<option value="기계팀">기계팀</option>
								<option value="전기팀">전기팀</option>
								<option value="방재팀">방재팀</option>
								<option value="설비팀">설비팀</option>
								<option value="통신팀">통신팀</option>
							</select>
						</div>

						<div class="form-group">
							<label>직급<span>*</span></label>
							<%-- ★ 핵심 수정 2: DB 컬럼명과 일치하게 jobTitle -> job_title 로 변경 --%>
							<select name="job_title" required>
								<option value="" disabled selected>직급 선택</option>
								<option value="기사">기사</option>
								<option value="주임">주임</option>
								<option value="대리">대리</option>
								<option value="과장">과장</option>
								<option value="차장">차장</option>
								<option value="부장">부장</option>
								<option value="소장">소장</option>
								<option value="사장">사장</option>
							</select>
						</div>

						<div class="form-group">
							<label>시스템 권한<span>*</span></label> <select name="role" required>
								<option value="USER">일반 사용자 (USER)</option>
								<option value="ADMIN">관리자 (ADMIN)</option>
							</select>
						</div>

						<div class="form-group">
							<label>연락처</label> <input type="text" name="phone"
								placeholder="010-0000-0000" />
						</div>

						<div class="form-group">
							<label>이메일</label> <input type="email" name="email"
								placeholder="example@taepyeong.com" />
						</div>

						<div class="form-group full-width">
							<label>주소</label> <input type="text" name="address"
								placeholder="상세 주소를 입력하세요" />
						</div>

						<div class="btn-group full-width">
							<button type="button" class="btn btn-cancel"
								onclick="history.back()">취소</button>
							<button type="submit" class="btn btn-save">직원 등록 완료</button>
						</div>
					</form>
				</div>
			</div>
		</main>
	</div>
</body>
</html>
