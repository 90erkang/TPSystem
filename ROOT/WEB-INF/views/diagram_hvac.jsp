<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 관리자 권한에 따른 메뉴 노출 제어 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 중앙 냉난방 공조 계통도</title>

<%-- 사이드바 및 공통 레이아웃 스타일시트 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 계통도 헤더 스타일: 제목과 인쇄 버튼 배치 */
.diagram-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 1px solid #eee;
}

/* 2. 도면 스크롤 영역: 대형 도면이 깨지지 않도록 가로 스크롤 허용 */
.diagram-scroll-box {
	width: 100%;
	overflow-x: auto; /* 내용이 넘치면 가로 스크롤 생성 */
	padding: 10px 0;
	text-align: center; /* 도면 중앙 정렬 */
}

/* 3. 인쇄용 버튼 스타일 */
.btn-print {
	background: #1a237e;
	color: white;
	border: none;
	padding: 8px 16px;
	border-radius: 5px;
	cursor: pointer;
	font-weight: bold;
	font-size: 0.9rem;
	transition: 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 5px;
}

.btn-print:hover {
	background: #0d165e;
	transform: translateY(-2px);
}

/* 4. ★ 인쇄 모드 최적화 설정 (@media print) ★ */
@media print {
	/* 인쇄 시 불필요한 사이드바, 헤더, 버튼을 숨김 */
	.sidebar, .header, .btn-print {
		display: none !important;
	}
	/* 도면이 전체 페이지를 차지하도록 레이아웃 조정 */
	.app-container {
		display: block;
	}
	.main-content {
		margin-left: 0;
		padding: 0;
	}
	/* 카드 박스 효과 제거하여 가독성 증대 */
	.card {
		box-shadow: none;
		border: none;
	}
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
				<li><a href="${pageContext.request.contextPath}/dashboard">🏠 홈</a></li>
				<li><a href="${pageContext.request.contextPath}/attendance">⏰ 근태 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️ 계통도</a></li>
				<li><a href="${pageContext.request.contextPath}/logs">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋 사내 게시판</a></li>
				<%-- 관리자 권한(ADMIN) 확인 후 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > 계통도 관리 > <strong> 중앙 냉난방 공조 계통도</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						style="margin-left: 10px; padding: 5px 10px; border: 1px solid #ff5252; color: #ff5252; background: none; border-radius: 4px; cursor: pointer;">
						로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card">
					<div class="diagram-header">
						<h3 style="margin: 0;">💨 중앙 냉난방 공조 계통도</h3>
						<div>
							<%-- 브라우저 기본 인쇄창 호출 --%>
							<button class="btn-print" onclick="window.print()">🖨️
								계통도 인쇄</button>
						</div>
					</div>

					<div class="diagram-scroll-box">
						<div class="mermaid">
graph TD

%% 스타일 정의
classDef steam fill:#ffebee,stroke:#c62828,stroke-width:2px;
classDef cooling fill:#e8f5e9,stroke:#2e7d32,stroke-width:2px;
classDef chilled fill:#e3f2fd,stroke:#1565c0,stroke-width:2px;
classDef ahu fill:#fff,stroke:#333,stroke-width:3px;
classDef device fill:#fff,stroke:#333,stroke-width:2px;
classDef brine fill:#f3e5f5,stroke:#7b1fa2,stroke-width:2px;

%% 1. 통합 난방 계통
subgraph SG1["통합 난방 계통"]
  TANK["응축수 탱크"]:::chilled
  FP1["급수 펌프 No.1"]:::device
  FP2["급수 펌프 No.2"]:::device
  B1["관류형 보일러 No.1"]:::steam
  B2["관류형 보일러 No.2"]:::steam
  S_HEADER["메인 스팀 헤더"]:::steam
  HEX1["열교환기 No.1"]:::device
  HEX2["열교환기 No.2"]:::device
  AHU_S["난방 배관"]:::steam

  TANK --> FP1
  TANK --> FP2
  FP1 --> B1
  FP1 --> B2
  FP2 --> B1
  FP2 --> B2
  B1 --> S_HEADER
  B2 --> S_HEADER
  S_HEADER --> HEX1
  S_HEADER --> HEX2
  HEX1 --> AHU_S
  HEX2 --> AHU_S
end

%% 2. 통합 냉방 계통
subgraph SG2["통합 냉방 계통"]
  CT1["냉각탑 No.1"]:::cooling
  CT2["냉각탑 No.2"]:::cooling
  CP1["냉각수 펌프 No.1"]:::device
  CP2["냉각수 펌프 No.2"]:::device
  CH_C1["터보냉동기 No.1(응축기 파트)"]:::cooling
  CH_C2["터보냉동기 No.2(응축기 파트)"]:::cooling
  BP1["브라인 펌프 No.1"]:::brine
  BP2["브라인 펌프 No.2"]:::brine
  CH_E1["터보냉동기 No.1(증발기 파트)"]:::chilled
  CH_E2["터보냉동기 No.2(증발기 파트)"]:::chilled
  LP1["냉수 펌프 No.1"]:::device
  LP2["냉수 펌프 No.2"]:::device
  AHU_C["냉방 배관"]:::chilled

  CT1 <--> CP1
  CT1 <--> CP2
  CT2 <--> CP1
  CT2 <--> CP2
  CP1 <--> CH_C1
  CP1 <--> CH_C2
  CP2 <--> CH_C1
  CP2 <--> CH_C2
  CH_C1 <--> BP1
  CH_C2 <--> BP2
  BP1 <--> CH_E1
  BP2 <--> CH_E2
  CH_E1 <--> LP1
  CH_E2 <--> LP2
  LP1 <--> AHU_C
  LP2 <--> AHU_C
end

%% 3. 최종 공조 공급
FAN["공조기 AHU<br/>────────<br/>AHU1(B1F~3F)<br/>AHU2(4F~7F)<br/>AHU3(8F~11F)<br/>AHU4(12F~15F)<br/>AHU5(16F~18F)<br/>AHU6(19F~20F)"]:::ahu

AHU_S --> FAN
AHU_C --> FAN
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

	<%-- Mermaid 모듈 로드 및 초기화 --%>
	<script type="module">
        import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
        mermaid.initialize({ 
            startOnLoad: true,
            theme: 'default',
            flowchart: { useMaxWidth: false } // 도면 크기가 잘리지 않도록 설정
        });
    </script>
</body>
</html>