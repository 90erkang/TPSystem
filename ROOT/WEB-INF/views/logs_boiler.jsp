<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 조건문(c:if) 및 데이터 출력을 위해 사용 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 보일러 운전 일지</title>

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">
<%-- FontAwesome: 아이콘 라이브러리 --%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<%-- SheetJS: HTML 테이블을 엑셀 파일로 변환 및 다운로드 --%>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<style>
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
	align-items: center;
	gap: 10px;
	font-size: 0.95rem;
	border-right: 1px solid #e0e0e0; /* 항목 사이 구분선 */
	color: #555;
	font-weight: 600;
}

.meta-item:last-child {
	border-right: none;
}

.meta-val {
	font-weight: 800;
	color: #1a237e;
	font-size: 1rem;
}

/* 근무자 입력 필드 (밑줄 디자인) */
.worker-input {
	border: none;
	background: transparent;
	font-weight: 800;
	outline: none;
	width: 120px;
	font-size: 1rem;
	border-bottom: 1px solid #ccc;
	text-align: center;
	font-family: "Pretendard", sans-serif;
}

.worker-input:focus {
	border-bottom: 2px solid #1a237e;
}

/* 섹션 타이틀 포인트 */
.section-title {
	font-size: 1.1rem;
	font-weight: bold;
	margin: 25px 0 10px 0;
	border-left: 5px solid #1a237e;
	padding-left: 10px;
	color: #333;
}

/* 테이블 공통 디자인 */
table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 0;
	table-layout: fixed;
	background: #fff;
	border: 1px solid #ddd;
}

th {
	background: #f0f2f5;
	padding: 10px 5px;
	border: 1px solid #ddd;
	font-size: 0.9rem;
	text-align: center;
	color: #444;
	font-weight: bold;
	vertical-align: middle;
}

td {
	padding: 5px;
	border: 1px solid #ddd;
	text-align: center;
	vertical-align: middle;
}

/* 1호기(남색), 2호기(녹색) 배경색 구분 */
.bg-u1 {
	background: #e8eaf6;
	color: #1a237e;
}

.bg-u2 {
	background: #e8f5e9;
	color: #2e7d32;
}

/* 입력창 통일 스타일 */
input[type="text"], input[type="number"], select {
	width: 100%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
	text-align: center;
	font-weight: bold;
	font-size: 0.95rem;
}

input:focus, select:focus {
	border-color: #1a237e;
	outline: none;
	background: #fdfdfd;
}

/* 자동 계산 결과 등 읽기 전용 필드 */
input[readonly] {
	background-color: #f1f1f1;
	color: #555;
	cursor: default;
}

/* 종합 메모장 영역 */
.memo-area {
	width: 100%;
	border: 1px solid #ddd;
	border-radius: 4px;
	padding: 15px;
	font-size: 1rem;
	min-height: 100px;
	resize: none;
	box-sizing: border-box;
}

/* 하단 실행 버튼 영역 */
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
	font-size: 0.95rem;
}

/* [인쇄 전용 설정] 인쇄 시 사이드바 및 버튼 숨김, 폰트 조절 */
@media print {
	@page {
		size: A4 landscape;
		margin: 10mm;
	}
	.sidebar, .header, .no-print, .footer-btns {
		display: none !important;
	}
	.main-content {
		margin: 0;
		padding: 0;
	}
	.log-meta {
		border: none;
		padding: 0;
		display: flex;
		justify-content: space-between;
	}
	.meta-item {
		border: none;
	}
	th, td, input, select {
		border: 1px solid #000 !important;
		font-size: 11px !important;
		padding: 4px !important;
	}
	.section-title {
		border-left-color: #000;
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
				<li><a href="${pageContext.request.contextPath}/logs"
					class="active">📝 일지 관리</a></li>
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
					관리 시스템 > 일지 관리 > 보일러 운전 일지 목록 > <strong>보일러 운전 일지</strong>
				</div>
				<div class="user-info">
					<span style="font-weight: 600; color: #1a237e">${member.username}
						${member.job_title}</span> 님 반갑습니다.
					<button
						onclick="location.href='${pageContext.request.contextPath}/logout'"
						class="btn-logout">로그아웃</button>
				</div>
			</header>

			<div class="content">
				<div class="card"
					style="background: #fff; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);">

					<div class="log-meta">
						<div class="meta-item">
							<i class="fas fa-calendar-alt" style="color: #666"></i> <span>일자:</span>
							<span id="realTimeDate" class="meta-val">${logData.log_date}</span>
						</div>
						<div class="meta-item">
							<i class="fas fa-temperature-half" style="color: #666"></i> <span>외기온도:</span>
							<span class="meta-val" id="realTimeTemp" style="color: #007bff">${not empty logData.temp ? logData.temp : '측정중...'}</span>
						</div>
						<div class="meta-item">
							<i class="fas fa-users" style="color: #666"></i> <span>근무자:</span>
							<input type="text" id="worker_ui" class="worker-input"
								placeholder="이름" value="${logData.worker}">
						</div>
						<div class="meta-item">
							<i class="fas fa-user-check" style="color: #666"></i> <span>작성자:</span>
							<span class="meta-val">${not empty logData.writer ? logData.writer : member.username}</span>
						</div>
					</div>

					<form
						action="${pageContext.request.contextPath}/logs/${not empty logData ? 'update' : 'write'}"
						method="post" id="finalForm">
						<%-- 수정 시에만 lno(PK)를 전달 --%>
						<c:if test="${not empty logData}">
							<input type="hidden" name="lno" value="${logData.lno}">
						</c:if>

						<%-- 서버 전송용 히든 필드들 --%>
						<input type="hidden" name="category" value="BOILER"> <input
							type="hidden" name="log_date" id="hidden_date"> <input
							type="hidden" name="writer" value="${member.username}"> <input
							type="hidden" name="worker" id="hidden_worker"> <input
							type="hidden" name="temp" id="hidden_temp"> <input
							type="hidden" name="content" id="hidden_content">
						<%-- 모든 테이블 데이터가 JSON으로 담길 위치 --%>

						<%-- 수정 모드일 때 서버에서 불러온 JSON 데이터를 보관하는 위치 --%>
						<div id="server-data" style="display: none;">${logData.content}</div>

						<div class="section-title">1. 운전 현황 데이터</div>
						<table id="mainTable">
							<colgroup>
								<col style="width: 16%">
								<col style="width: 14%">
								<col style="width: 8%">
								<col span="4" style="width: 15.5%">
							</colgroup>
							<thead>
								<tr>
									<th rowspan="2">항 목</th>
									<th rowspan="2">판정기준</th>
									<th rowspan="2">단위</th>
									<th colspan="2" class="bg-u1">1 호 기</th>
									<th colspan="2" class="bg-u2">2 호 기</th>
								</tr>
								<tr>
									<th class="bg-u1">기 동</th>
									<th class="bg-u1">정 지</th>
									<th class="bg-u2">기 동</th>
									<th class="bg-u2">정 지</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<th>증기 압력</th>
									<td>6 이하</td>
									<td>kg/㎠</td>
									<td><input type="number" step="0.1"></td>
									<%-- 온도및 압력은 0.1단위로 측정 --%>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
								</tr>
								<tr>
									<th>가스압력 1차</th>
									<td>35</td>
									<td>Kpa</td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
								</tr>
								<tr>
									<th>가스압력 2차</th>
									<td>4</td>
									<td>Kpa</td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
								</tr>
								<tr>
									<th>현재 압력</th>
									<td>차단압력 ↓</td>
									<td>kg/㎠</td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
								</tr>
								<tr>
									<th>관체 온도</th>
									<td>210 이하</td>
									<td>℃</td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
								</tr>
								<tr>
									<th>스케일 온도</th>
									<td>200 이하</td>
									<td>℃</td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
								</tr>
								<tr>
									<th>배기 온도</th>
									<td>190 이하</td>
									<td>℃</td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
									<td><input type="number" step="0.1"></td>
								</tr>
								<tr>
									<th>헷더 압력</th>
									<td>2.5 이하</td>
									<td>kg/㎠</td>
									<td colspan="2"><input type="number" step="0.1"
										placeholder="공통"></td>
									<td colspan="2"><input type="number" step="0.1"
										placeholder="공통"></td>
								</tr>
								<tr>
									<th>수 위 계</th>
									<td>수위 상태</td>
									<td>-</td>
									<td><input type="text" placeholder="정상"></td>
									<td><input type="text" placeholder="정상"></td>
									<td><input type="text" placeholder="정상"></td>
									<td><input type="text" placeholder="정상"></td>
								</tr>
							</tbody>
						</table>

						<div style="display: flex; gap: 20px; margin-top: 5px;">
							<div style="flex: 1;">
								<div class="section-title">2. 가동 시간 (h)</div>
								<table id="timeTable">
									<thead>
										<tr>
											<th>구분</th>
											<th>일일가동</th>
											<th>월누계</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th class="bg-u1">1호기</th>
											<td><input type="number" step="0.1"></td>
											<td><input type="number" step="0.1"></td>
										</tr>
										<tr>
											<th class="bg-u2">2호기</th>
											<td><input type="number" step="0.1"></td>
											<td><input type="number" step="0.1"></td>
										</tr>
									</tbody>
								</table>
							</div>
							<div style="flex: 1.2;">
								<div class="section-title">3. 계량기 검침 (㎥)</div>
								<table id="meterTable">
									<thead>
										<tr>
											<th>구분</th>
											<th>금일</th>
											<th>전일</th>
											<th>사용량</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<th>가 스</th>
											<td><input type="number" class="calc-gas"></td>
											<td><input type="number" class="calc-gas"></td>
											<td><input type="number" readonly></td>
										</tr>
										<tr>
											<th>급 수</th>
											<td><input type="number" class="calc-water"></td>
											<td><input type="number" class="calc-water"></td>
											<td><input type="number" readonly></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>

						<div class="section-title">4. 일상 점검 사항</div>
						<table id="checkTable">
							<colgroup>
								<col style="width: 8%">
								<col style="width: 52%">
								<col span="2" style="width: 20%">
							</colgroup>
							<thead>
								<tr>
									<th>NO</th>
									<th>점 검 항 목</th>
									<th class="bg-u1">1 호 기</th>
									<th class="bg-u2">2 호 기</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td>1</td>
									<td style="text-align: left; padding-left: 15px;">버너 착화 및
										연소 상태는 양호한가?</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>2</td>
									<td style="text-align: left; padding-left: 15px;">급수 펌프 작동
										및 누수 여부</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>3</td>
									<td style="text-align: left; padding-left: 15px;">각종
										배관(증기, 급수, 가스) 가스 누설 여부</td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
									<td><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
								<tr>
									<td>4</td>
									<td style="text-align: left; padding-left: 15px;">연수기 작동
										상태 및 경도 누설 여부</td>
									<td colspan="2"><select><option>양호</option>
											<option>불량</option></select></td>
								</tr>
							</tbody>
						</table>

						<div class="memo-section">
							<h4
								style="margin: 0 0 10px 0; border-left: 4px solid #1a237e; padding-left: 10px;">📌
								종합 특이사항 및 메모</h4>
							<textarea name="memo" class="memo-area"
								placeholder="보일러 관련 특이사항이나 전달사항을 입력하세요...">${logData.memo}</textarea>
						</div>

						<div class="footer-btns no-print">
							<button type="button" class="btn-action"
								style="background: #666;"
								onclick="location.href='${pageContext.request.contextPath}/logs/list?category=BOILER'">
								<i class="fas fa-list"></i> 목록으로
							</button>
							<button type="button" class="btn-action"
								style="background: #2e7d32" onclick="collectAndSubmit()">
								<i class="fas fa-save"></i> DB 저장하기
							</button>
							<button type="button" class="btn-action"
								style="background: #1b5e20" onclick="downloadExcel()">
								<i class="fas fa-file-excel"></i> 엑셀
							</button>
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

	<%-- [자바스크립트 로직] ========================================== --%>
	<script>
		/**
		 * [1. 시작 신호] 
		 * 웹 브라우저가 페이지의 모든 그림과 글자를 다 읽어들였을 때 
		 * "이제 일을 시작해!"라고 명령을 내리는 함수입니다.
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
			var jsonDiv = document.getElementById('server-data');
			if (jsonDiv && jsonDiv.innerText.trim() !== "") {
				try {
					var data = JSON.parse(jsonDiv.innerText); // 뭉쳐진 글자를 다시 데이터 형태로 풀기
					if (data.main) fillInputs('mainTable', data.main);   // 1번 표 채우기
					if (data.time) fillInputs('timeTable', data.time);   // 2번 표 채우기
					if (data.meter) fillInputs('meterTable', data.meter); // 3번 표 채우기
					if (data.check) fillInputs('checkTable', data.check); // 4번 표 채우기
				} catch (e) {
					console.error("저장된 데이터를 불러오는 중에 에러가 났어요!", e);
				}
			}
			
			// 1-4. [자동 계산기] 가스나 물 사용량을 숫자를 적자마자 바로 계산하도록 감시를 시작합니다.
			setupCalc('calc-gas');   // 가스 사용량 계산기 작동
			setupCalc('calc-water'); // 급수 사용량 계산기 작동
		};

		  /**
	     * [2. 실시간 날씨 도우미]
	     * OpenWeatherMap 기상대에 연락해서 현재 기온을 가져옵니다.
	     */
		function getRealTimeWeather() {
			var savedTemp = "${logData.temp}"; // 이미 저장된 온도가 있는지 확인
			if (!savedTemp || savedTemp === "") {
				var API_KEY = "0c862b868fb02194dd5814a77179567a"; // 기상대 출입 키
				// 위도/경도(서울 중구) 정보(구글 맵 참고)를 가지고 기상대에 데이터를 요청합니다.
				fetch("https://api.openweathermap.org/data/2.5/weather?lat=37.5626&lon=126.9766&appid=" + API_KEY + "&units=metric")
				.then(res => res.json()).then(data => {
						var temp = data.main.temp.toFixed(1); // 소수점 한자리까지만 (예: 15.5)
						var el = document.getElementById('realTimeTemp');
						if (el) {
							el.innerText = temp + "°C";
							// 온도가 너무 낮으면 남색, 높으면 빨간색으로 글자색을 바꿉니다.
							el.style.color = (temp < 10 ? "#1a237e" : (temp > 25 ? "#c62828" : "#007bff"));
						}
						// 나중에 DB에 저장할 수 있게 숨겨진 칸에도 온도를 적어둡니다.
						if (document.getElementById('hidden_temp'))
							document.getElementById('hidden_temp').value = temp + "°C";
					});
			} else {
				// 이미 저장된 온도가 있다면 새로 물어보지 않고 그 값을 보여줍니다.
				if (document.getElementById('hidden_temp'))
					document.getElementById('hidden_temp').value = savedTemp;
			}
		}

		/**
		 * [3. 스마트 계산기] 
		 * '금일 검침'에서 '전일 검침'을 빼서 '사용량'을 자동으로 계산해줍니다.
		 */
		function setupCalc(className) {
			var rows = document.querySelectorAll('#meterTable tbody tr'); // 계량기 표의 줄들을 찾습니다.
			rows.forEach(function(tr) {
				var inputs = tr.querySelectorAll('input'); // 한 줄에 있는 입력칸 3개(금일, 전일, 결과)를 찾습니다.
				if (inputs.length >= 3) {
					var calc = function() {
						var curr = parseFloat(inputs[0].value) || 0; // 금일 숫자 읽기
						var prev = parseFloat(inputs[1].value) || 0; // 전일 숫자 읽기
						var res = curr - prev; // 뺄셈 하기
						inputs[2].value = res >= 0 ? res.toFixed(1) : 0; // 결과 칸에 적기 (음수면 0)
					};
					// 숫자를 입력하는 순간(input 이벤트)마다 바로바로 계산을 수행합니다.
					inputs[0].addEventListener('input', calc);
					inputs[1].addEventListener('input', calc);
				}
			});
		}

		/**
		 * [4. 내용 채우기 도우미] 
		 * 저장되어 있던 데이터 보따리(배열)를 풀어서 
		 * 표 안에 있는 빈칸(input, select)들에 순서대로 쏙쏙 넣어주는 함수입니다.
		 */
		function fillInputs(tableId, values) {
			var inputs = document.querySelectorAll('#' + tableId + ' input, #' + tableId + ' select');
			inputs.forEach(function(input, index) {
				if (values[index] !== undefined)
					input.value = values[index]; // 데이터 보따리의 index번째 값을 입력칸에 넣기
			});
		}

		/**
		 * [5. 데이터 수집 및 전송] 
		 * "DB 저장하기" 버튼을 눌렀을 때 실행됩니다.
		 * 흩어져 있는 표 안의 모든 숫자와 글자를 싹 긁어모아(Scrape) 
		 * JSON에 담아서 서버로 택배를 보냅니다.
		 */
		function collectAndSubmit() {
			// 표 하나를 통째로 훑어서 그 안의 값들을 리스트로 만드는 작은 함수
			var scrape = function(id) {
				var inputs = document.querySelectorAll('#' + id + ' input, #' + id + ' select');
				return Array.from(inputs).map(function(input) { return input.value; });
			};
			
			// 4개의 표 데이터를 하나의 큰 객체(dataObj)로 묶습니다.
			var dataObj = {
				main : scrape('mainTable'),
				time : scrape('timeTable'),
				meter : scrape('meterTable'),
				check : scrape('checkTable')
			};

			// 전송 전, 윗부분에 적힌 날짜, 근무자, 온도 정보를 최종 확인합니다.
			document.getElementById('hidden_date').value = document.getElementById('realTimeDate').innerText;
			document.getElementById('hidden_worker').value = document.getElementById('worker_ui').value;
			if (!document.getElementById('hidden_temp').value)
				document.getElementById('hidden_temp').value = document.getElementById('realTimeTemp').innerText;
			
			// 객체를 JSON 문자열로 변환합니다.
			document.getElementById('hidden_content').value = JSON.stringify(dataObj);
			
			// 서버로 데이터 저장(최종)
			document.getElementById('finalForm').submit();
		}

		/**
		 * [6. 엑셀 변환기] 
		 * 화면에 보이는 표들을 그대로 엑셀 파일(.xlsx)로 만들어서 
		 */
		function downloadExcel() {
			var wb = XLSX.utils.book_new(); // 새 엑셀 문서 만들기
			// 각 표(HTML Table)를 시트(Sheet)로 변환해서 하나씩 추가합니다.
			XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('mainTable')), "운전현황");
			XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('timeTable')), "가동시간");
			XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('meterTable')), "계량기");
			XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('checkTable')), "점검사항");
			// 오늘 날짜를 붙여서 파일 이름을 만들고 저장합니다. (예: 보일러일지_20251230.xlsx)
			XLSX.writeFile(wb, "보일러일지_" + new Date().toLocaleDateString('ko-KR').replace(/[. ]/g, "") + ".xlsx");
		}
</script>
</body>
</html>