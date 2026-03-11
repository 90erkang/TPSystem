<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 관리자 메뉴 노출 제어 등을 위해 사용 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 수변전실 계통도</title>

<%-- 사이드바 및 공통 레이아웃 스타일시트 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">

<style>
/* 1. 계통도 페이지 전용 레이아웃 스타일 */
.diagram-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 20px;
	padding-bottom: 15px;
	border-bottom: 1px solid #eee;
}

/* 도면이 화면보다 넓을 경우를 대비한 가로 스크롤 박스 */
.diagram-scroll-box {
	width: 100%;
	overflow-x: auto; /* 내용이 박스보다 크면 스크롤 바 생성 */
	padding: 10px 0;
	text-align: center; /* 도면을 중앙에 배치 */
}

/* 2. 인쇄 버튼 스타일 */
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

/* 3. ★ 인쇄 전용 설정 (브라우저 인쇄 시 적용) ★ */
@media print {
	/* 사이드바, 헤더, 인쇄 버튼 등 UI 요소는 인쇄물에서 제외 */
	.sidebar, .header, .btn-print {
		display: none !important;
	}
	/* 메인 콘텐츠 영역을 전체 폭으로 확장 */
	.app-container {
		display: block;
	}
	.main-content {
		margin-left: 0;
		padding: 0;
	}
	/* 카드 박스의 그림자와 테두리 제거하여 깨끗한 도면 출력 */
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
				<%-- 현재 페이지(계통도) 활성화 상태 유지 --%>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️ 계통도</a></li>
				<li><a href="${pageContext.request.contextPath}/logs">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋 사내 게시판</a></li>
				<%-- 관리자 권한 확인 후 관리자 메뉴 노출 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<main class="main-content">
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > 계통도 관리 > <strong>수변전실 계통도</strong>
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
						<h3 style="margin: 0; color: #333;">22.9kV 수변전실 계통도</h3>
						<%-- 브라우저의 인쇄 대화상자를 호출하는 함수 --%>
						<button class="btn-print" onclick="window.print()">🖨️
							계통도 인쇄</button>
					</div>

					<div class="diagram-scroll-box">
						<div class="mermaid">
							graph TD

%% 스타일 정의: 전압 단계별 색상 구분
classDef hv fill:#f9f,stroke:#333,stroke-width:2px
classDef lv fill:#ccf,stroke:#333,stroke-width:2px
classDef tr fill:#ff9,stroke:#333,stroke-width:2px
classDef gnd fill:#fff,stroke:#333,stroke-width:1px,stroke-dasharray:5 5

%% 1. 특고압 인입부 및 수전반 (22.9kV 라인)
KEPCO["한전 인입 (22.9kV CNCV-W)"]:::hv --> LBS

subgraph HVPanel["특고압 수전반 (HV Panel)"]
  LBS["LBS<br />부하개폐기"]:::hv --> HV_BUS_1["특고압 모선"]
  HV_BUS_1 --> MOF["MOF<br />계기용변성기"]:::hv
  MOF -.-> DM["DM<br />전력량계"]
  HV_BUS_1 --> PT["PT<br />계기용변압기"]:::hv
  PT -.-> V_METER["V/VS<br />전압계"]
  HV_BUS_1 --> LA["LA<br />피뢰기<br />(18kV)"]:::hv
  LA -.-> GND1["제1종 접지"]:::gnd
  HV_BUS_1 --> VCB["VCB<br />진공차단기"]:::hv
  VCB --> CT["CT<br />변류기"]:::hv
  CT -.-> OCR["OCR/OCGR<br />과전류계전기"]
  CT -.-> A_METER["A/AS<br />전류계"]
  CT --> HV_MAIN_BUS["특고압 메인 모선"]
end

HV_MAIN_BUS --> PF1["PF-1<br />전력퓨즈"]:::hv
HV_MAIN_BUS --> PF2["PF-2<br />전력퓨즈"]:::hv

%% 2. 변압기 (특고압을 저압으로 변환)
PF1 --> TR1["TR-1 (No.1 변압기)<br />3Φ 22.9kV / 380-220V<br />(Δ-Y 결선)"]:::tr
PF2 --> TR2["TR-2 (No.2 변압기)<br />3Φ 22.9kV / 380-220V<br />(Δ-Y 결선)"]:::tr
TR1 -.-> GND2_1["제2종 접지 (N상)"]:::gnd
TR2 -.-> GND2_2["제2종 접지 (N상)"]:::gnd

%% 3. 저압부 및 배전반 (380/220V 라인)
TR1 --> ACB1["ACB-1<br />기중차단기"]:::lv
TR2 --> ACB2["ACB-2<br />기중차단기"]:::lv

subgraph LVPanel["저압 배전반 (LV Panel)"]
  ACB1 --> LV_BUS_A["전등(LN)/전열(RN)"]
  ACB2 --> LV_BUS_B["동력/비상동력"]
  
  %% Bank 1: 전등 및 전열 부하
  LV_BUS_A --> MCCB1["MCCB<br />LV-1 (전등)<br />───────<br />LN20<br /> LN19<br /> LN18<br /> LN17<br /> LN16<br /> LN15<br /> LN14<br /> LN13<br /> LN12<br /> LN11<br /> LN10<br /> LN9<br /> LN8<br /> LN7<br /> LN6<br /> LN5<br /> LN4<br /> LN3<br /> LN2<br /> LN1<br />"]:::lv
  LV_BUS_A --> MCCB2["MCCB<br />LV-2 (전열)<br />───────<br />RN20<br /> RN19<br /> RN18<br /> RN17<br /> RN16<br /> RN15<br /> RN14<br /> RN13<br /> RN12<br /> RN11<br /> RN10<br /> RN9<br /> RN8<br /> RN7<br /> RN6<br /> RN5<br /> RN4<br /> RN3<br /> RN2<br /> RN1<br />"]:::lv
  LV_BUS_A --> MCCB3["MCCB<br />LV-3 (예비)<br />───────<br />전기차 충전소<br />웅진 실외기<br />Spare<br />Spare"]:::lv
  
  %% Bank 2: 동력 및 비상발전기 부하
  LV_BUS_B --> MCCB4["MCCB<br />LV-4 (동력)<br />───────<br />AHU-6<br />AHU-5<br />AHU-4<br />AHU-3<br />AHU-2<br />AHU-1"]:::lv
  LV_BUS_B --> MCCB5["MCCB<br />LV-5 (비상발전기)<br />───────<br />EDG-1<br />EDG-2"]:::lv
end

%% 범례: 도면 해석을 돕기 위한 색상 가이드
subgraph Legend["범례 (Legend)"]
  HV_LEGEND["특고압 22.9kV"]:::hv
  TR_LEGEND["변압기"]:::tr
  LV_LEGEND["저압 380/220V"]:::lv
end
						</div>
					</div>
				</div>
			</div>
		</main>
	</div>

	<%-- Mermaid 라이브러리 로드 및 초기화 스크립트 --%>
	<script type="module">
        import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
        mermaid.initialize({ 
            startOnLoad: true,
            theme: 'default', // 기본 테마 설정
            securityLevel: 'loose' 
        });
    </script>
</body>
</html>