<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그 라이브러리: 로그인 실패 메시지 출력 등 조건 처리를 위해 선언 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 로그인</title>

<%-- 공통 사이드바 관련 CSS 연결 (로그인 페이지에서도 폰트 등 기초 스타일 공유 목적) --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 바디 레이아웃 설정: 
   - 배경에 짙은 남색 계열의 선형 그라데이션 적용 
   - display: flex를 사용하여 로그인 카드를 화면 정중앙에 배치 
*/
body {
	background: linear-gradient(135deg, #1a237e 0%, #3949ab 100%);
	display: flex;
	align-items: center;
	justify-content: center;
	height: 100vh;
	margin: 0;
	overflow: hidden; /* 배경 스크롤 방지 */
}

/* 로그인 입력 폼을 감싸는 카드형 박스 스타일 */
.login-card {
	width: 400px;
	background: #fff;
	border-radius: 15px;
	box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); /* 입체감을 위한 그림자 */
	padding: 50px 40px;
	text-align: center;
}

/* 상단 로고 텍스트 스타일 */
.login-logo {
	font-size: 2rem;
	font-weight: 800;
	color: #1a237e;
	margin-bottom: 10px;
	letter-spacing: 1px;
}

/* 환영 문구 서브 텍스트 스타일 */
.login-sub {
	color: #666;
	font-size: 0.9rem;
	margin-bottom: 40px;
}

/* 입력창(ID/PW)과 라벨을 감싸는 그룹 스타일 */
.input-group {
	margin-bottom: 20px;
	text-align: left;
}

/* 입력창 상단 라벨 스타일 */
.input-group label {
	display: block;
	font-size: 0.85rem;
	color: #444;
	margin-bottom: 8px;
	font-weight: 600;
}

/* 실제 텍스트/패스워드 입력 필드 스타일 */
.input-group input {
	width: 100%;
	padding: 12px 15px;
	border: 1px solid #ddd;
	border-radius: 8px;
	font-size: 1rem;
	transition: 0.3s; /* 상태 변경 시 부드러운 전환 효과 */
}

/* 입력창 클릭(Focus) 시 테두리 및 그림자 효과 */
.input-group input:focus {
	border-color: #1a237e;
	outline: none;
	box-shadow: 0 0 0 3px rgba(26, 35, 126, 0.1);
}

/* 로그인 제출 버튼 스타일 */
.btn-login {
	width: 100%;
	padding: 15px;
	background: #1a237e;
	color: #fff;
	border: none;
	border-radius: 8px;
	font-size: 1.1rem;
	font-weight: bold;
	cursor: pointer;
	transition: 0.3s;
	margin-top: 10px;
}

/* 로그인 버튼 마우스 오버 시 효과 */
.btn-login:hover {
	background: #0d145a; /* 더 진한 남색으로 변경 */
	transform: translateY(-2px); /* 살짝 떠오르는 효과 */
	box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
}
</style>
</head>
<body>
	<%-- 중앙 로그인 카드 레이아웃 --%>
	<div class="login-card">
		<div class="login-logo">태평로빌딩</div>
		<div class="login-sub">통합 관리 시스템에 오신 것을 환영합니다.</div>

		<%-- 
			데이터 전송 폼 시작 
			action: 컨트롤러의 로그인 검증 경로(/loginCheck) 호출
			method: 비밀번호 보안을 위해 반드시 POST 방식 사용 
		--%>
		<form action="${pageContext.request.contextPath}/loginCheck"
			method="post">

			<%-- 사번(ID) 입력 섹션 --%>
			<div class="input-group">
				<label for="userid">사번(ID)</label>
				<%-- required 속성으로 빈 값 전송 방지 --%>
				<input type="text" id="userid" name="userid" placeholder="사번을 입력하세요"
					required />
			</div>

			<%-- 비밀번호 입력 섹션 --%>
			<div class="input-group">
				<label for="userpwd">비밀번호</label>
				<%-- type="password"를 사용하여 마스킹 처리 --%>
				<input type="password" id="userpwd" name="userpwd"
					placeholder="비밀번호를 입력하세요" required />
			</div>

			<%-- 폼 전송 버튼 --%>
			<button type="submit" class="btn-login">로그인</button>
		</form>

		<%-- 
			로그인 실패 시 처리 로직:
			Controller에서 Model에 'msg'를 담아 보냈을 경우에만 빨간색 텍스트 출력 
		--%>
		<c:if test="${not empty msg}">
			<div style="color: red; margin-top: 10px; font-size: 0.9rem;">${msg}</div>
		</c:if>

		<%-- 하단 안내 텍스트 --%>
		<div style="margin-top: 20px; font-size: 0.8rem; color: #999;">
			계정 및 비밀번호 분실 시 관리자에게 문의하세요.</div>
	</div>
</body>
</html>