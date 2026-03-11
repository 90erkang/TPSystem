<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 조건문(if, choose)과 데이터 출력을 위해 사용 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 냉동기 운전 일지</title>

<%-- 1. 스타일 및 외부 라이브러리 로드 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">
<%-- FontAwesome: 버튼 아이콘 표시용 --%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<%-- SheetJS: HTML 테이블을 엑셀 파일로 변환 및 다운로드하기 위한 라이브러리 --%>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<style>
/* [레이아웃 스타일 정의] ========================================== */

/* 상단 메타 정보 영역: 일자, 온도, 근무자, 작성자를 4등분 그리드로 배치 */
.log-meta {
	display: grid;
	grid-template-columns: repeat(4, 1fr); /* 1:1:1:1 비율 */
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
	border-right: 1px solid #e0e0e0; /* 항목 사이 세로선 */
}

.meta-item:last-child {
	border-right: none;
} /* 마지막 항목은 선 제거 */
.meta-val {
	font-weight: 800;
	color: #1a237e;
	font-size: 1rem;
}

/* 근무자 성함 입력칸 (배경 투명, 밑줄 스타일) */
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

/* 복합 점검 테이블 스타일 */
.merged-table-container {
	background: #fff;
	border-radius: 8px;
	border: 1px solid #ddd;
	overflow: hidden;
	margin-top: 10px;
}

.merged-table {
	width: 100%;
	border-collapse: collapse;
	text-align: center;
	table-layout: fixed; /* 고정 너비 레이아웃 */
}

/* 테이블 헤더 색상 구분 (메인/1호기/2호기) */
.merged-table thead th {
	background: #f0f2f5;
	color: #444;
	padding: 10px 5px;
	border: 1px solid #ddd;
	font-size: 0.9rem;
	font-weight: bold;
	vertical-align: middle;
}

.merged-table thead th.header-main {
	background: #1a237e;
	color: #fff;
}

.merged-table thead th.header-u1 {
	background: #e8eaf6;
	color: #1a237e;
}

.merged-table thead th.header-u2 {
	background: #e8f5e9;
	color: #2e7d32;
}

.merged-table td {
	padding: 5px;
	border: 1px solid #ddd;
	vertical-align: middle;
}

/* 카테고리열(왼쪽) 및 항목열 스타일 */
.category-col {
	background: #f8f9fa;
	font-weight: bold;
	color: #444;
	font-size: 0.9rem;
}

.item-col {
	text-align: left;
	padding-left: 15px !important;
	font-weight: 500;
	color: #333;
}

/* 테이블 내 입력창 스타일 */
.merged-table input {
	width: 100%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
	text-align: center;
	font-weight: bold;
	font-size: 0.95rem;
}

/* 자동 계산 결과 필드 (읽기 전용) */
.calc-result {
	background-color: #f1f1f1 !important;
	color: #555;
	cursor: default;
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

/* [인쇄 설정] @media print ======================================= */
@media print {
	@page {
		size: A4 portrait;
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
	.merged-table th, .merged-table td {
		border: 1px solid #000 !important;
		font-size: 11px !important;
		padding: 4px !important;
	}
	input {
		border: none !important;
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
					관리 시스템 > 일지 관리 > 냉동기 운전 일지 목록 > <strong>냉동기 운전 일지</strong>
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
				<div class="card">
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
								value="${logData.worker}" placeholder="이름">
						</div>
						<div class="meta-item">
							<i class="fas fa-user-check" style="color: #666"></i> <span>작성자:</span>
							<span class="meta-val">${not empty logData.writer ? logData.writer : member.username}</span>
						</div>
					</div>

					<form
						action="${pageContext.request.contextPath}/logs/${not empty logData ? 'update' : 'write'}"
						method="post" id="finalForm">
						<%-- 수정 모드일 경우 lno(일지번호) 전달 --%>
						<c:if test="${not empty logData}">
							<input type="hidden" name="lno" value="${logData.lno}">
						</c:if>

						<%-- 히든 필드: DB에 실제로 저장될 데이터들 --%>
						<input type="hidden" name="category" value="CHILLER"> <input
							type="hidden" name="log_date" id="hidden_date"> <input
							type="hidden" name="writer" value="${member.username}"> <input
							type="hidden" name="worker" id="hidden_worker"> <input
							type="hidden" name="temp" id="hidden_temp"> <input
							type="hidden" name="content" id="hidden_content">
						<%-- JSON 데이터 보관함 --%>

						<%-- 서버에서 로드한 기존 JSON 문자열 임시 보관소 --%>
						<div id="server-data" style="display: none;">${logData.content}</div>

						<div class="merged-table-container">
							<table class="merged-table" id="mergedTable">
								<colgroup>
									<col style="width: 15%">
									<col style="width: 25%">
									<col style="width: 30%">
									<col style="width: 30%">
								</colgroup>
								<thead>
									<tr>
										<th colspan="2" class="header-main">구분 / 항목</th>
										<th class="header-u1">터보냉동기 1호기</th>
										<th class="header-u2">터보냉동기 2호기</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td rowspan="4" class="category-col">시간<br>(Time)
										</td>
										<td class="item-col">점검 시간</td>
										<td><input type="time" class="time-auto"></td>
										<td><input type="time" class="time-auto"></td>
									</tr>
									<tr>
										<td class="item-col">가동 시작 시간</td>
										<td><input type="time" class="calc-time start-time-1"
											onchange="calcOperatingTime(1)"></td>
										<td><input type="time" class="calc-time start-time-2"
											onchange="calcOperatingTime(2)"></td>
									</tr>
									<tr>
										<td class="item-col">가동 종료 시간</td>
										<td><input type="time" class="calc-time end-time-1"
											onchange="calcOperatingTime(1)"></td>
										<td><input type="time" class="calc-time end-time-2"
											onchange="calcOperatingTime(2)"></td>
									</tr>
									<tr>
										<td class="item-col">총 가동 시간 (H)</td>
										<td><input type="number" step="0.1"
											class="total-time-1 calc-result" placeholder="자동 계산" readonly></td>
										<td><input type="number" step="0.1"
											class="total-time-2 calc-result" placeholder="자동 계산" readonly></td>
									</tr>

									<tr>
										<td rowspan="3" class="category-col">압축기<br>(Compressor)
										</td>
										<td class="item-col">토출 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
									<tr>
										<td class="item-col">유압 (kPa)</td>
										<td><input type="number" step="1"></td>
										<td><input type="number" step="1"></td>
									</tr>
									<tr>
										<td class="item-col">%FLA (부하율 %)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>

									<tr>
										<td rowspan="7" class="category-col">증발기<br>(Evaporator)
										</td>
										<td class="item-col">냉매 포화 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
									<tr>
										<td class="item-col">증발 압력 (kPa)</td>
										<td><input type="number" step="1"></td>
										<td><input type="number" step="1"></td>
									</tr>
									<tr>
										<td class="item-col">브라인 입구 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
									<tr>
										<td class="item-col">브라인 출구 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
									<tr>
										<td class="item-col">브라인 입구 압력 (MPa)</td>
										<td><input type="number" step="0.01"></td>
										<td><input type="number" step="0.01"></td>
									</tr>
									<tr>
										<td class="item-col">브라인 출구 압력 (MPa)</td>
										<td><input type="number" step="0.01"></td>
										<td><input type="number" step="0.01"></td>
									</tr>
									<tr>
										<td class="item-col">어프로치 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>

									<tr>
										<td rowspan="6" class="category-col">응축기<br>(Condenser)
										</td>
										<td class="item-col">응축 압력 (kPa)</td>
										<td><input type="number" step="1"></td>
										<td><input type="number" step="1"></td>
									</tr>
									<tr>
										<td class="item-col">냉각수 입구 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
									<tr>
										<td class="item-col">냉각수 출구 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
									<tr>
										<td class="item-col">냉각수 입구 압력 (MPa)</td>
										<td><input type="number" step="0.01"></td>
										<td><input type="number" step="0.01"></td>
									</tr>
									<tr>
										<td class="item-col">냉각수 출구 압력 (MPa)</td>
										<td><input type="number" step="0.01"></td>
										<td><input type="number" step="0.01"></td>
									</tr>
									<tr>
										<td class="item-col">어프로치 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>

									<tr>
										<td rowspan="3" class="category-col">모터 및 기타</td>
										<td class="item-col">모터 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
									<tr>
										<td class="item-col">오일 히터 상태</td>
										<td><input type="text" placeholder="ON/OFF"></td>
										<td><input type="text" placeholder="ON/OFF"></td>
									</tr>
									<tr>
										<td class="item-col">배출 과열 온도 (℃)</td>
										<td><input type="number" step="0.1"></td>
										<td><input type="number" step="0.1"></td>
									</tr>
								</tbody>
							</table>
						</div>

						<div class="footer-btns no-print">
							<button type="button" class="btn-action"
								style="background: #666;"
								onclick="location.href='${pageContext.request.contextPath}/logs/list?category=CHILLER'">
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
         * 페이지 로드 시 초기화 작업
         */
        window.onload = function() {
            // 1. 날짜 자동 입력 (데이터가 없을 때만)
            var dateSpan = document.getElementById('realTimeDate');
            if (dateSpan.innerText.trim() === "") {
                dateSpan.innerText = new Date().toLocaleDateString('ko-KR', { year : 'numeric', month : '2-digit', day : '2-digit', weekday : 'short' });
            }
            
            // 2. 현재 시간을 점검 시간 기본값으로 설정
            var timeInputs = document.querySelectorAll('.time-auto');
            timeInputs.forEach(function(input) {
                if (!input.value) {
                    var now = new Date();
                    input.value = String(now.getHours()).padStart(2, '0') + ":" + String(now.getMinutes()).padStart(2, '0');
                }
            });
            
            // 3. 기상 정보(외기온도) 호출
            getRealTimeWeather();

            // 4. 수정 모드일 경우 기존 JSON 데이터를 테이블에 복원
            var jsonDiv = document.getElementById('server-data');
            if (jsonDiv && jsonDiv.innerText.trim() !== "") {
                try {
                    var data = JSON.parse(jsonDiv.innerText);
                    fillMergedTable(data.chiller1, data.chiller2);
                    // 복원 후 가동 시간 재계산
                    calcOperatingTime(1); calcOperatingTime(2);
                } catch (e) { console.error("JSON 복원 실패", e); }
            }
        };

        /**
         * OpenWeatherMap API를 사용한 실시간 온도 조회
         */
        function getRealTimeWeather() {
            var savedTemp = "${logData.temp}"; 
            if (!savedTemp || savedTemp === "") {
                // 사용자 API KEY 적용
                var API_KEY = "0c862b868fb02194dd5814a77179567a"; 
                fetch("https://api.openweathermap.org/data/2.5/weather?lat=37.5626&lon=126.9766&appid=" + API_KEY + "&units=metric")
                    .then(res => res.json())
                    .then(data => {
                        var temp = data.main.temp.toFixed(1);
                        var el = document.getElementById('realTimeTemp');
                        if(el) {
                            el.innerText = temp + "°C";
                            // 온도에 따른 텍스트 색상 분기 (가시성)
                            el.style.color = (temp < 10 ? "#1a237e" : (temp > 25 ? "#c62828" : "#007bff"));
                        }
                        // 서버 저장용 hidden 필드에도 세팅
                        if(document.getElementById('hidden_temp')) document.getElementById('hidden_temp').value = temp + "°C";
                    });
            } else {
                // 이미 저장된 데이터가 있으면 그대로 사용
                if(document.getElementById('hidden_temp')) document.getElementById('hidden_temp').value = savedTemp;
            }
        }

        /**
         * 가동 시작/종료 시간에 따른 총 가동 시간 자동 계산
         */
        function calcOperatingTime(unitNo) {
            var start = document.querySelector('.start-time-' + unitNo).value;
            var end = document.querySelector('.end-time-' + unitNo).value;
            var totalInput = document.querySelector('.total-time-' + unitNo);

            if (start && end) {
                var sDate = new Date("2000-01-01 " + start);
                var eDate = new Date("2000-01-01 " + end);
                // 종료 시간이 시작 시간보다 빠르면 자정을 넘긴 것으로 간주하여 하루 더함
                if (eDate < sDate) eDate.setDate(eDate.getDate() + 1);
                
                var diffHours = ((eDate - sDate) / (1000 * 60 * 60)).toFixed(1);
                totalInput.value = diffHours;
            }
        }

        /**
         * JSON 배열 데이터를 테이블의 입력 필드에 순서대로 채워주는 함수
         */
        function fillMergedTable(c1, c2) {
            var rows = document.querySelectorAll('#mergedTable tbody tr');
            rows.forEach(function(row, idx) {
                var inputs = row.querySelectorAll('input');
                if (inputs.length >= 2) {
                    if (c1 && c1[idx] !== undefined) inputs[0].value = c1[idx];
                    if (c2 && c2[idx] !== undefined) inputs[1].value = c2[idx];
                }
            });
        }

        /**
         * 테이블의 모든 데이터를 수집하여 JSON 형태로 서버에 제출
         */
        function collectAndSubmit() {
            var c1 = [], c2 = [];
            // 모든 테이블 행을 순회하며 입력값을 배열에 저장
            document.querySelectorAll('#mergedTable tbody tr').forEach(function(row) {
                var inputs = row.querySelectorAll('input');
                if (inputs.length >= 2) { 
                    c1.push(inputs[0].value); 
                    c2.push(inputs[1].value); 
                }
            });
            
            // 히든 필드 최종 값 할당
            document.getElementById('hidden_date').value = document.getElementById('realTimeDate').innerText;
            document.getElementById('hidden_worker').value = document.getElementById('worker_ui').value;
            if(!document.getElementById('hidden_temp').value) document.getElementById('hidden_temp').value = document.getElementById('realTimeTemp').innerText;
            
            // 객체를 문자열로 변환하여 전송
            document.getElementById('hidden_content').value = JSON.stringify({ chiller1: c1, chiller2: c2 });
            document.getElementById('finalForm').submit();
        }

        /**
         * SheetJS 라이브러리를 사용하여 현재 테이블을 엑셀로 다운로드
         */
        function downloadExcel() {
            var wb = XLSX.utils.book_new(); // 새 워크북 생성
            var ws = XLSX.utils.table_to_sheet(document.getElementById('mergedTable')); // 테이블 -> 시트 변환
            XLSX.utils.book_append_sheet(wb, ws, "빙축열운전일지");
            XLSX.writeFile(wb, "빙축열일지_" + new Date().toLocaleDateString('ko-KR').replace(/[. ]/g, "") + ".xlsx");
        }
    </script>
</body>
</html>