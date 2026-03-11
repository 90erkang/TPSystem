<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 조건문 및 데이터 출력을 위해 사용 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 수변전 설비 운전 일지</title>

<%-- 1. 외부 라이브러리 및 스타일시트 로드 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">
<%-- FontAwesome: 아이콘 사용 --%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<%-- SheetJS: HTML 테이블을 엑셀 파일로 변환해주는 라이브러리 --%>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<style>
/* [스타일 설정] ========================================== */

/* 상단 메타 정보 영역 (일자, 온도, 근무자 등) */
.log-meta {
	display: grid;
	grid-template-columns: repeat(4, 1fr); /* 4열 배치 */
	background: #f8f9fa;
	padding: 15px 0;
	border-radius: 8px;
	border: 1px solid #dee2e6;
	margin-bottom: 25px;
	align-items: center;
}

.meta-item {
	display: flex;
	justify-content: center;
	gap: 10px;
	border-right: 1px solid #e0e0e0; /* 항목 간 구분선 */
	font-weight: 600;
	color: #555;
}

.meta-item:last-child {
	border-right: none;
}

.meta-val {
	font-weight: 800;
	color: #1a237e;
}

/* 근무자 입력란 스타일 (투명 배경에 밑줄만 표시) */
.worker-input {
	border: none;
	border-bottom: 1px solid #ccc;
	text-align: center;
	font-weight: 800;
	width: 120px;
	background: transparent;
}

/* 섹션 헤더 (1. 시간대별 현황 등) */
.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 30px 0 10px;
}

.section-title {
	font-size: 1.1rem;
	font-weight: bold;
	border-left: 5px solid #1a237e; /* 제목 옆 파란 포인트 바 */
	padding-left: 10px;
}

/* 테이블 공통 스타일 */
table {
	width: 100%;
	border-collapse: collapse;
	background: #fff;
	border: 1px solid #ddd;
	table-layout: fixed; /* 열 너비 고정 */
}

th {
	background: #f0f2f5;
	padding: 8px 4px;
	border: 1px solid #ddd;
	font-size: 0.85rem;
	text-align: center;
	font-weight: bold;
}

td {
	padding: 4px;
	border: 1px solid #ddd;
	text-align: center;
}

/* 입력 필드 스타일 */
input[type="text"], input[type="number"], select {
	width: 100%;
	padding: 6px;
	border: 1px solid #ddd;
	border-radius: 4px;
	text-align: center;
	font-weight: bold;
}

/* 가로 스크롤이 필요한 대형 테이블 컨테이너 */
.scroll-table-container {
	overflow-x: auto;
	border: 1px solid #ddd;
	border-radius: 8px;
	background: #fff;
	margin-bottom: 20px;
}

/* 테이블 헤더 색상 구분 */
.main-header {
	background: #1a237e !important;
	color: #fff !important;
}

.sub-header-1 {
	background: #e8eaf6;
	color: #1a237e;
}

.sub-header-2 {
	background: #e3f2fd;
	color: #1565c0;
}

.flex-row {
	display: flex;
	gap: 20px;
	align-items: flex-start;
	margin-top: 10px;
}

.col-6 {
	flex: 6;
}

.col-4 {
	flex: 4;
}

/* 행 추가/삭제 버튼 */
.btn-add {
	background: #1a237e;
	color: #fff;
	padding: 6px 12px;
	border-radius: 4px;
	border: none;
	cursor: pointer;
	font-weight: bold;
}

.btn-del {
	background: #c62828;
	color: #fff;
	width: 24px;
	height: 24px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
}

/* 하단 버튼 영역 */
.footer-btns {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 30px;
	border-top: 1px solid #eee;
	padding-top: 20px;
}

.btn-action {
	padding: 12px 20px;
	border: none;
	border-radius: 6px;
	font-weight: bold;
	cursor: pointer;
	color: #fff;
	display: flex;
	align-items: center;
	gap: 6px;
}

/* [인쇄 설정] 인쇄 시 불필요한 요소 숨김 처리 */
@media print {
	.sidebar, .header, .no-print, .footer-btns, .btn-add, .btn-del {
		display: none !important;
	}
	.main-content {
		margin: 0;
		padding: 0;
	}
	.log-meta {
		border: none;
	}
	.scroll-table-container {
		border: none;
		overflow: visible;
	}
	th, td, input, select {
		border: 1px solid #000 !important;
		font-size: 9px !important;
		padding: 2px !important;
	}
	.col-del {
		display: none;
	} /* 삭제 버튼 열 숨김 */
}
</style>
</head>
<body>
	<%-- 전체 애플리케이션의 레이아웃을 감싸는 최상위 컨테이너 --%>
	<div class="app-container">

		<%-- 좌측 사이드바 메뉴 영역 --%>
		<aside class="sidebar">
			<%-- 시스템 로고 및 홈 이동 링크 --%>
			<a href="${pageContext.request.contextPath}/dashboard"
				class="sidebar-logo">태평로빌딩</a>
			<%-- 네비게이션 메뉴 리스트 --%>
			<ul class="sidebar-menu">
				<li><a href="${pageContext.request.contextPath}/dashboard">🏠
						홈</a></li>
				<li><a href="${pageContext.request.contextPath}/attendance">⏰
						근태 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/diagram">🏗️
						계통도</a></li>
				<%-- 현재 메뉴인 일지 관리를 활성화(active) 상태로 표시 --%>
				<li><a
					href="${pageContext.request.contextPath}/logs/list?category=ELECTRICITY"
					class="active">📝 일지 관리</a></li>
				<li><a href="${pageContext.request.contextPath}/board">📋
						사내 게시판</a></li>

				<%-- 관리자(ADMIN) 권한일 경우에만 노출되는 관리자 전용 메뉴 --%>
				<c:if test="${sessionScope.member.role == 'ADMIN'}">
					<li><a href="${pageContext.request.contextPath}/admin"
						class="admin-menu">⚙️ 관리자 모드</a></li>
				</c:if>
			</ul>
		</aside>

		<%-- 실제 데이터가 표시되는 메인 콘텐츠 영역 --%>
		<main class="main-content">
			<%-- 상단 헤더: 브레드크럼(경로) 및 로그인 사용자 정보 표시 --%>
			<header class="header">
				<div class="breadcrumb">
					관리 시스템 > 일지 관리 > 수변전 일지 목록 > <strong>수변전 일지</strong>
				</div>
				<div class="user-info">
					<%-- 현재 로그인한 사용자의 성함과 직급을 출력 --%>
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
				</div>
			</header>

			<%-- 일지 작성/수정 폼이 담기는 본문 영역 --%>
			<div class="content">
				<%-- 입체감 있는 카드 디자인 컨테이너 --%>
				<div class="card"
					style="background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);">

					<%-- 상단 메타 정보 바 (일자, 온도, 근무자, 작성자) --%>
					<div class="log-meta">
						<%-- 작성 일자 표시 (신규 시 빈칸, 수정 시 저장된 날짜) --%>
						<div class="meta-item">
							<i class="fas fa-calendar-alt"></i> 일자: <span id="realTimeDate"
								class="meta-val">${not empty logData.log_date ? logData.log_date : ''}</span>
						</div>
						<%-- 기상 API 또는 저장된 온도가 표시되는 영역 --%>
						<div class="meta-item">
							<i class="fas fa-temperature-half"></i> 외기온도: <span
								class="meta-val" id="realTimeTemp" style="color: #007bff">${not empty logData.temp ? logData.temp : '측정중...'}</span>
						</div>
						<%-- 실제 현장 근무자 성함 입력 --%>
						<div class="meta-item">
							<i class="fas fa-users"></i> 근무자: <input type="text"
								id="worker_ui" class="worker-input" value="${logData.worker}"
								placeholder="이름">
						</div>
						<%-- 시스템에 로그인하여 기록을 남기는 주체 (로그인 유저) --%>
						<div class="meta-item">
							<i class="fas fa-user-check"></i> 작성자: <span class="meta-val">${not empty logData.writer ? logData.writer : member.username}</span>
						</div>
					</div>

					<%-- 서버로 데이터를 전송할 메인 폼 태그 --%>
					<form action="${pageContext.request.contextPath}/logs/write"
						method="post" id="finalForm">
						<%-- [수정 모드 처리] 기존 일지 번호(lno)가 있을 경우 서버로 함께 전송 --%>
						<c:if test="${not empty logData}">
							<input type="hidden" name="lno" value="${logData.lno}">
						</c:if>

						<%-- [서버 전송용 히든 필드들] --%>
						<input type="hidden" name="category" value="ELECTRICITY">
						<%-- 카테고리 고정 --%>
						<input type="hidden" name="log_date" id="hidden_date">
						<%-- 날짜 --%>
						<input type="hidden" name="writer" value="${member.username}">
						<%-- 작성자 --%>
						<input type="hidden" name="worker" id="hidden_worker">
						<%-- 근무자 --%>
						<input type="hidden" name="temp" id="hidden_temp">
						<%-- 온도 --%>
						<input type="hidden" name="content" id="hidden_content">
						<%-- JSON 수치 데이터 --%>
						<input type="hidden" name="memo" value="">
						<%-- 기타 메모 --%>

						<%-- 서버에서 로드한 기존의 상세 수치(JSON)를 임시로 담아두는 숨김 박스 --%>
						<div id="server-data" style="display: none;">${logData.content}</div>

						<%-- 1. 전력 수치 기록 섹션 --%>
						<div class="section-header">
							<div class="section-title">1. 시간대별 운전 현황</div>
							<button type="button" class="btn-add no-print"
								onclick="addTimeRow()">+ 시간대 추가</button>
						</div>
						<%-- 대형 테이블 가로 스크롤 컨테이너 --%>
						<div class="scroll-table-container">
							<%-- 특고압/저압 모선별 수치를 적는 메인 테이블 (1800px 광폭) --%>
							<table id="readingsTable" style="min-width: 1800px;">
								<colgroup>
									<col style="width: 100px;">
									<col span="5" style="width: 70px;">
									<col span="3" style="width: 70px;">
									<col span="3" style="width: 70px;">
									<col span="3" style="width: 70px;">
									<col span="3" style="width: 70px;">
									<col span="3" style="width: 70px;">
									<col style="width: 50px;" class="col-del">
								</colgroup>
								<thead>
									<%-- 복합 헤더 구조 (rowspan, colspan 활용) --%>
									<tr>
										<th rowspan="2" class="main-header"
											style="position: sticky; left: 0; z-index: 10;">시간</th>
										<th colspan="5" class="sub-header-1">MAIN VCB</th>
										<th colspan="3" class="sub-header-2">LV 1-1</th>
										<th colspan="3" class="sub-header-2">LV 2-1</th>
										<th colspan="3" class="sub-header-2">LV 3-1</th>
										<th colspan="3" class="sub-header-2">LV 4-1</th>
										<th colspan="3" class="sub-header-2">LV 5-1</th>
										<th rowspan="2" class="no-print col-del">삭제</th>
									</tr>
									<tr>
										<%-- 세부 항목들 (KV, A, MW, PF, HZ, V, KW 등) --%>
										<th>KV</th>
										<th>A</th>
										<th>MW</th>
										<th>PF</th>
										<th>HZ</th>
										<th>V</th>
										<th>A</th>
										<th>KW</th>
										<th>V</th>
										<th>A</th>
										<th>KW</th>
										<th>V</th>
										<th>A</th>
										<th>KW</th>
										<th>V</th>
										<th>A</th>
										<th>KW</th>
										<th>V</th>
										<th>A</th>
										<th>KW</th>
									</tr>
								</thead>
								<%-- 스크립트에 의해 행(Row)이 동적으로 삽입될 바디 --%>
								<tbody id="readingsBody"></tbody>
							</table>
						</div>

						<%-- 하단 2단 레이아웃 (온도 및 사용량) --%>
						<div class="flex-row">
							<%-- 좌측 6: 변압기(TR) 온도 기록부 --%>
							<div class="col-6">
								<div class="section-header" style="margin-top: 0;">
									<div class="section-title">2. TR 온도 (℃)</div>
									<button type="button" class="btn-add no-print"
										onclick="addTrRow()">+ 행 추가</button>
								</div>
								<table id="trTable">
									<colgroup>
										<col style="width: 20%">
										<col span="5" style="width: 14%">
										<col style="width: 10%" class="col-del">
									</colgroup>
									<thead>
										<tr>
											<th>시간</th>
											<th>TR-1</th>
											<th>TR-2</th>
											<th>TR-3</th>
											<th>TR-4</th>
											<th>TR-5</th>
											<th class="no-print col-del">삭제</th>
										</tr>
									</thead>
									<tbody id="trBody"></tbody>
								</table>
							</div>

							<%-- 우측 4: 당일 전력 사용량 및 비상 발전기용 경유 현황 --%>
							<div class="col-4">
								<div class="section-header" style="margin-top: 0;">
									<div class="section-title">3. 금일 총 사용량 (KWH)</div>
								</div>
								<table id="usageTable">
									<thead>
										<tr>
											<th>유효전력</th>
											<th>무효전력</th>
											<th>역률(%)</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><input type="number" step="0.1"></td>
											<td><input type="number" step="0.1"></td>
											<td><input type="number" step="0.1"></td>
										</tr>
									</tbody>
								</table>

								<div class="section-header">
									<div class="section-title">4. 발전기용 경유</div>
								</div>
								<table id="dieselTable">
									<thead>
										<tr>
											<th>구분</th>
											<th>상태 / 수량</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>경유 탱크 이상 유무</th>
											<td><select><option>정상</option>
													<option>이상 발견</option></select></td>
										</tr>
										<tr>
											<th>잔여 경유량 (L)</th>
											<td><input type="number" placeholder="L 단위 입력"></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

						<%-- 5. 법정 및 자체 점검 항목 리스트 --%>
						<div class="section-header">
							<div class="section-title">5. 점검 사항</div>
						</div>
						<table id="checkTable">
							<colgroup>
								<col style="width: 8%">
								<col>
								<col style="width: 15%">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<th>점 검 내 용</th>
									<th>결 과</th>
								</tr>
							</thead>
							<tbody>
								<%-- 수변전실 일상 점검 필수 7개 항목 --%>
								<tr>
									<td>1</td>
									<td style="text-align: left; padding-left: 15px;">변압기 이상
										소음, 진동, 과열, 냄새 여부</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>2</td>
									<td style="text-align: left; padding-left: 15px;">VCB, ACB
										차단기 개폐 표시 및 이상음 여부</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>3</td>
									<td style="text-align: left; padding-left: 15px;">콘덴서 외관
										부풀음, 누유 및 과열 여부</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>4</td>
									<td style="text-align: left; padding-left: 15px;">배전반 지시
										계기 상태 및 각종 램프 점등 상태</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>5</td>
									<td style="text-align: left; padding-left: 15px;">수변전실 실내
										온도 및 환기 상태</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>6</td>
									<td style="text-align: left; padding-left: 15px;">[비상발전기]
										연료 상태(50% 이상) 및 밸브 OPEN 여부</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>7</td>
									<td style="text-align: left; padding-left: 15px;">[비상발전기]
										배터리 전압(24V 이상) 및 단자 접속 상태</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
							</tbody>
						</table>

						<%-- 하단 컨트롤 버튼 바 (인쇄 시 제외) --%>
						<div class="footer-btns no-print">
							<%-- 목록으로 돌아가기 --%>
							<button type="button" class="btn-action"
								style="background: #666;"
								onclick="location.href='${pageContext.request.contextPath}/logs/list?category=ELECTRICITY'">
								<i class="fas fa-list"></i> 목록으로
							</button>
							<%-- 현재 입력된 데이터를 취합하여 DB에 저장 (함수 호출) --%>
							<button type="button" class="btn-action"
								style="background: #2e7d32" onclick="collectAndSubmit()">
								<i class="fas fa-save"></i> DB 저장하기
							</button>
							<%-- 현재 테이블 내용을 엑셀 파일로 추출 --%>
							<button type="button" class="btn-action"
								style="background: #1b5e20" onclick="downloadExcel()">
								<i class="fas fa-file-excel"></i> 엑셀
							</button>
							<%-- 브라우저 인쇄 다이얼로그 호출 --%>
							<button type="button" class="btn-action"
								style="background: #455a64" onclick="window.print()">
								<i class="fas fa-print"></i> 인쇄
							</button>
						</div>
					</form>
				</div>
			</div>
		</main>
	</div>
	<script>
    /**
     * [1. 페이지 시작]
     * 사용자가 일지 페이지를 열자마자 웹 브라우저가 가장 먼저 실행하는 부분입니다.
     * 각종 기본 세팅(날짜, 날씨, 기존 데이터 불러오기)을 자동으로 수행합니다.
     */
    window.onload = function() {
        // 1-1. [날짜 자동 입력]
        var dateSpan = document.getElementById('realTimeDate');
        if (dateSpan.innerText.trim() === "") {
            dateSpan.innerText = new Date().toLocaleDateString('ko-KR', { 
                year : 'numeric', month : '2-digit', day : '2-digit', weekday : 'short' 
            });
        }
        
        // 1-2. [OpenAPIWeather 연결]
        getRealTimeWeather();

        // 1-3. [기존 데이터 복구] 만약 새 글이 아니라 '수정' 중이라면, 예전에 저장한 내용을 표에 다시 채워넣습니다.
        var jsonDiv = document.getElementById('server-data'); // DB에서 가져온 긴 글자 보따리(JSON)
        if (jsonDiv && jsonDiv.innerText.trim() !== "") {
            try {
                // 한 줄의 긴 글자로 된 데이터를 다시 '데이터 상자' 형태로 풉니다.
                var data = JSON.parse(jsonDiv.innerText);
                
                // 시간대별 운전 현황 표 복구 (내용이 있으면 한 줄씩 추가, 없으면 빈 줄 하나 추가)
                if(data.readings && data.readings.length > 0) { 
                    data.readings.forEach(function(rowData) { addTimeRow(rowData); }); 
                } else { addTimeRow(); }
                
                // TR(변압기) 온도 표 복구
                if(data.trTemps && data.trTemps.length > 0) { 
                    data.trTemps.forEach(function(rowData) { addTrRow(rowData); }); 
                } else { addTrRow(); }
                
                // 나머지 고정된 표(사용량, 경유, 점검사항)들도 보따리 안의 내용으로 채웁니다.
                if(data.usage) fillInputs('usageTable', data.usage);
                if(data.diesel) fillInputs('dieselTable', data.diesel);
                if(data.check) fillInputs('checkTable', data.check);
            } catch (e) { 
                console.error("데이터를 불러오는 중에 실수가 있었나봐요! (JSON 에러):", e); 
                addTimeRow(); addTrRow(); 
            }
        } else {
            // 새로 작성하는 글이라면 일단 빈 줄 하나씩을 만들어 줍니다.
            addTimeRow(); addTrRow(); 
        }
    };

    /**
     * [2. 실시간 날씨]
     * OpenWeatherMap 기상대에 연락해서 현재 기온을 가져옵니다.
     */
    function getRealTimeWeather() {
        var savedTemp = "${logData.temp}"; // 이미 저장된 온도가 있는지 확인
        if (!savedTemp || savedTemp === "" || savedTemp === "측정중...") {
            // 사용자의 기상청 출입 키 (API 키)
            var API_KEY = "0c862b868fb02194dd5814a77179567a"; 
            // 서울 중구 좌표를 기준으로 날씨를 요청합니다.
            fetch("https://api.openweathermap.org/data/2.5/weather?lat=37.5626&lon=126.9766&appid=" + API_KEY + "&units=metric")
                .then(res => {
                    if(!res.ok) throw new Error("기상대 응답 실패!"); // 인터넷 연결 확인
                    return res.json();
                })
                .then(data => {
                    var temp = data.main.temp.toFixed(1); // 소수점 한자리 (예: 15.6)
                    var el = document.getElementById('realTimeTemp');
                    if(el) {
                        el.innerText = temp + "°C";
                        // 온도가 너무 낮으면 남색, 높으면 빨강으로 글자색을 바꿉니다.
                        el.style.color = (temp < 10 ? "#1a237e" : (temp > 25 ? "#c62828" : "#007bff"));
                    }
                    // 나중에 DB에 저장할 수 있도록 숨겨진 입력칸에도 온도를 적어둡니다.
                    document.getElementById('hidden_temp').value = temp + "°C";
                })
                .catch(err => {
                    console.error("날씨 로드 실패 사유:", err);
                    document.getElementById('realTimeTemp').innerText = "정보 없음";
                });
        } else {
            // 이미 저장된 데이터가 있다면 새로 물어보지 않고 그 값을 사용합니다.
            document.getElementById('hidden_temp').value = savedTemp;
        }
    }

    /**
     * [3. 동적 줄 추가 - 운전 현황]
     */
    function addTimeRow(rowData) {
        var tbody = document.getElementById('readingsBody');
        var row = document.createElement('tr'); // 새 '줄(Row)' 만들기
        
        // 맨 왼쪽 '시간' 칸 만들기 (스크롤해도 고정되도록 스타일 적용)
        var html = '<td style="background:#fff; position: sticky; left: 0; z-index: 5;"><input type="text" placeholder="시간" value="' + (rowData ? rowData[0] : '') + '"></td>';
        
        // 나머지 20개의 수치 입력칸(KV, A, KW 등)을 한 번에 반복문으로 만듭니다.
        for(var i=1; i<=20; i++) { 
            html += '<td><input type="number" step="0.1" value="' + (rowData ? rowData[i] : '') + '"></td>'; 
        }
        
        // 마지막 '삭제' 버튼 칸 만들기
        html += '<td class="no-print col-del"><button type="button" class="btn-del" onclick="delRow(this)"><i class="fas fa-times"></i></button></td>';
        
        row.innerHTML = html; // 조립된 칸들을 줄에 넣기
        tbody.appendChild(row); // 표에 최종적으로 줄 붙이기
    }

    /**
     * [4. 동적 줄 추가 - TR 온도]
     */
    function addTrRow(rowData) {
        var tbody = document.getElementById('trBody');
        var row = document.createElement('tr');
        var html = '<td><input type="text" placeholder="시간" value="' + (rowData ? rowData[0] : '') + '"></td>';
        for(var i=1; i<=5; i++) { 
            html += '<td><input type="number" step="0.1" value="' + (rowData ? rowData[i] : '') + '"></td>'; 
        }
        html += '<td class="no-print col-del"><button type="button" class="btn-del" onclick="delRow(this)"><i class="fas fa-times"></i></button></td>';
        row.innerHTML = html;
        tbody.appendChild(row);
    }

    /**
     * [5. 줄 삭제]
     */
    function delRow(btn) { btn.closest('tr').remove(); }

    /**
     * [6. 고정 표 내용 채우기]
     */
    function fillInputs(tableId, values) { 
        var inputs = document.querySelectorAll('#' + tableId + ' input, #' + tableId + ' select'); 
        inputs.forEach(function(input, index) { 
            if (values[index] !== undefined) input.value = values[index]; 
        }); 
    }

    /**
     * [7. 데이터 최종 수집 및 서버 전송]
     * "DB 저장하기" 버튼을 누르면 작동합니다. 
     * 여기저기 흩어진 표의 값들을 하나의 보따리(JSON)로 묶어서 서버보냄.
     */
    function collectAndSubmit() {
        // [수집 1] 유동적인 표(Row)의 데이터
        var scrapeRows = function(id) { 
            var rows = document.querySelectorAll('#' + id + ' tr'); 
            var data = []; 
            rows.forEach(function(row) { 
                var rowVal = []; 
                row.querySelectorAll('input').forEach(function(input) { rowVal.push(input.value); }); 
                data.push(rowVal); // 한 줄의 데이터를 리스트로 저장
            }); 
            return data; 
        };
        
        // [수집 2] 고정된 표의 데이터
        var scrapeTable = function(id) { 
            var inputs = document.querySelectorAll('#' + id + ' input, #' + id + ' select'); 
            return Array.from(inputs).map(function(input) { return input.value; }); 
        };

        // [수집 3] 모든 데이터를 하나의 객체로 분류
        var dataObj = { 
            readings: scrapeRows('readingsBody'), 
            trTemps: scrapeRows('trBody'), 
            usage: scrapeTable('usageTable'), 
            diesel: scrapeTable('dieselTable'), 
            check: scrapeTable('checkTable') 
        };

     // 전송 전, 윗부분에 적힌 날짜, 근무자, 온도 정보를 최종 확인합니다.
        document.getElementById('hidden_date').value = document.getElementById('realTimeDate').innerText;
        document.getElementById('hidden_worker').value = document.getElementById('worker_ui').value;
        if(!document.getElementById('hidden_temp').value) document.getElementById('hidden_temp').value = document.getElementById('realTimeTemp').innerText;
        
        // 객체를 JSON 문자열로 변환합니다.
        document.getElementById('hidden_content').value = JSON.stringify(dataObj); 
        
        // 신규 등록인지 수정인지 판단해서 주소를 정하고 전송합니다.
        var form = document.getElementById('finalForm');
        var lno = "${logData.lno}"; // 기존 번호가 있으면 '수정', 없으면 '등록'
        form.action = (lno && lno !== "") ? "${pageContext.request.contextPath}/logs/update" : "${pageContext.request.contextPath}/logs/write";
     // 서버로 데이터 저장(최종)
        form.submit();
    }

    /**
     * [8. 엑셀 변환]
     * 화면의 표들을 엑셀 파일로 바꿔서 내 컴퓨터로 다운로드해 줍니다.
     */
    function downloadExcel() {
        var wb = XLSX.utils.book_new(); // 새 엑셀 문서(워크북) 생성
        
        // 각 표(Table)를 이름표(운전현황, TR온도 등)를 붙인 개별 시트로 추가합니다.
        XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('readingsTable')), "운전현황");
        XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('trTable')), "TR온도");
        XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('usageTable')), "사용량");
        XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('dieselTable')), "경유");
        XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('checkTable')), "점검사항");
        
        // 파일 이름을 정하고 최종적으로 저장합니다.
        XLSX.writeFile(wb, "수변전일지_" + new Date().toLocaleDateString('ko-KR').replace(/[. ]/g, "") + ".xlsx");
    }
</script>
</body>
</html>