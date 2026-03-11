<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%-- JSTL Core 태그: 조건문(c:if) 등을 사용하여 화면을 동적으로 제어 --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>태평로빌딩 | 일일 업무 일지</title>

<%-- 사이드바 및 레이아웃 공통 스타일시트 --%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/sidebar.css">
<%-- FontAwesome: 아이콘 라이브러리 --%>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
<%-- SheetJS: HTML 테이블을 엑셀 파일로 추출하는 라이브러리 --%>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>

<style>
/* 1. 상단 메타 정보 (일자, 온도, 근무자, 작성자 4등분 그리드) */
.log-meta {
	display: grid;
	grid-template-columns: repeat(4, 1fr);
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
	border-right: 1px solid #e0e0e0; /* 항목 간 세로 구분선 */
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

/* 근무자 성함 입력칸 스타일 (밑줄 디자인) */
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
	border-bottom: 2px solid #1a237e; /* 포커스 시 테두리 색상 강조 */
}

/* 2. 테이블 기본 디자인 */
table {
	width: 100%;
	border-collapse: collapse;
	margin-bottom: 15px;
	table-layout: fixed; /* 열 너비 고정 */
	background: #fff;
	border: 1px solid #ddd;
}

th {
	background: #f0f2f5;
	padding: 10px;
	border: 1px solid #ddd;
	font-size: 0.9rem;
	text-align: center;
	color: #444;
	font-weight: bold;
}

td {
	padding: 5px;
	border: 1px solid #ddd;
	text-align: center;
	vertical-align: middle;
}

/* 입력 필드 공통 스타일 */
input[type="text"], input[type="number"] {
	width: 100%;
	padding: 8px;
	border: 1px solid #ddd;
	border-radius: 4px;
	box-sizing: border-box;
	font-size: 0.95rem;
	text-align: center;
	background: #fff;
	font-family: "Pretendard", sans-serif;
}

input:focus {
	border-color: #1a237e;
	outline: none;
	background: #fdfdfd;
}

/* 3. 섹션 타이틀 및 버튼 스타일 */
.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin: 25px 0 10px;
}

.section-title {
	font-size: 1.1rem;
	font-weight: bold;
	padding-left: 10px;
	border-left: 5px solid #1a237e; /* 제목 옆 세로바 포인트 */
	color: #333;
}

.btn-add {
	background: #1a237e;
	color: #fff;
	padding: 6px 12px;
	border-radius: 4px;
	border: none;
	cursor: pointer;
	font-weight: bold;
	font-size: 0.85rem;
}

.btn-del {
	background: #c62828;
	color: #fff;
	width: 28px;
	height: 28px;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto;
}

.btn-del:hover {
	background: #b71c1c;
}

/* 2분할 레이아웃 (자재사용 vs 특이사항) */
.flex-row {
	display: flex;
	gap: 20px;
	align-items: stretch;
	margin-top: 20px;
}

.flex-half {
	flex: 1;
	display: flex;
	flex-direction: column;
}

/* 메모(특이사항) 텍스트 영역 */
.memo-area {
	width: 100%;
	border: 1px solid #ddd;
	border-radius: 4px;
	padding: 15px;
	font-size: 1rem;
	min-height: 150px;
	resize: none;
	box-sizing: border-box;
	font-family: "Pretendard", sans-serif;
}

/* 하단 액션 버튼 그룹 */
.footer-btns {
	display: flex;
	justify-content: flex-end;
	gap: 10px;
	margin-top: 40px;
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
	font-size: 0.95rem;
	display: flex;
	align-items: center;
	gap: 6px;
}

/* [인쇄 전용 미디어 쿼리] 인쇄 시 불필요한 UI 숨김 및 A4 최적화 */
@media print {
	@page {
		size: A4 portrait;
		margin: 10mm;
	}
	.sidebar, .header, .no-print, .btn-del, .btn-add, .footer-btns {
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
	th, td, input, textarea {
		border: 1px solid #000 !important;
		font-size: 11px !important;
	}
	th:last-child, td:last-child {
		display: none;
	} /* 인쇄 시 '삭제' 버튼 열 숨김 */
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
					관리 시스템 > 일지 관리 > 일지 목록 > <strong>일일 업무 일지</strong>
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
							<i class="fas fa-temperature-half" style="color: #666"></i> <span>온도:</span>
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

					<%-- 폼 전송 설정: 신규 등록(write) 또는 수정(update) --%>
					<form
						action="${pageContext.request.contextPath}/logs/${not empty logData ? 'update' : 'write'}"
						method="post" id="finalForm">

						<%-- 수정 시 일지 고유 번호(lno) 전달 --%>
						<c:if test="${not empty logData}">
							<input type="hidden" name="lno" value="${logData.lno}">
						</c:if>

						<%-- 서버 전송용 히든 필드 (화면에 표시되지 않는 실제 저장용 데이터) --%>
						<input type="hidden" name="category" value="DAILY"> <input
							type="hidden" name="log_date" id="hidden_date"> <input
							type="hidden" name="writer" value="${member.username}"> <input
							type="hidden" name="worker" id="hidden_worker"> <input
							type="hidden" name="temp" id="hidden_temp"> <input
							type="hidden" name="content" id="hidden_content">
						<%-- 모든 테이블 데이터가 JSON으로 담길 필드 --%>

						<%-- 서버에서 불러온 기존 JSON 데이터를 스크립트에서 활용하기 위해 숨겨둠 --%>
						<input type="hidden" id="saved_json_data"
							value='${logData.content}'>

						<div class="section-header">
							<div class="section-title">📝 민원 접수 및 처리 현황</div>
							<button type="button" class="btn-add no-print"
								onclick="addRow('complaintBody')">+ 행 추가</button>
						</div>
						<table id="complaintTable">
							<thead>
								<tr>
									<th>NO</th>
									<th>장소</th>
									<th>민원 내용</th>
									<th>처리 결과</th>
									<th class="no-print">삭제</th>
								</tr>
							</thead>
							<tbody id="complaintBody"></tbody>
						</table>

						<div class="section-header">
							<div class="section-title">🛠️ 주요 시설 작업 내용</div>
							<button type="button" class="btn-add no-print"
								onclick="addRow('taskBody')">+ 행 추가</button>
						</div>
						<table id="taskTable">
							<thead>
								<tr>
									<th>NO</th>
									<th>작업구분</th>
									<th>상세 작업 사항</th>
									<th>비고</th>
									<th class="no-print">삭제</th>
								</tr>
							</thead>
							<tbody id="taskBody"></tbody>
						</table>

						<div class="flex-row">
							<div class="flex-half">
								<div class="section-header">
									<div class="section-title">📦 자재 사용 현황</div>
									<button type="button" class="btn-add no-print"
										onclick="addRow('materialBody')">+ 추가</button>
								</div>
								<table id="materialTable">
									<thead>
										<tr>
											<th>NO</th>
											<th>자재명</th>
											<th>수량</th>
											<th class="no-print">삭제</th>
										</tr>
									</thead>
									<tbody id="materialBody"></tbody>
								</table>
							</div>
							<div class="flex-half">
								<div class="section-header">
									<div class="section-title">📌 특이사항 및 인수인계사항</div>
								</div>
								<textarea name="memo" class="memo-area" placeholder="전달사항 입력...">${logData.memo}</textarea>
							</div>
						</div>

						<div class="footer-btns no-print">
							<button type="button" class="btn-action"
								style="background: #666;"
								onclick="location.href='${pageContext.request.contextPath}/logs/list?category=DAILY'">
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

	<script>
		window.onload = function() {
			// 1. 날짜 자동 세팅
			var dateSpan = document.getElementById('realTimeDate');
			if (dateSpan.innerText.trim() === "") {
				dateSpan.innerText = new Date().toLocaleDateString('ko-KR', { year : 'numeric', month : '2-digit', day : '2-digit', weekday : 'short' });
			}

			// 2. 날씨 API 호출
			getRealTimeWeather();

			// 3. 기존 데이터 복구 (JSON 파싱)
			var savedJson = document.getElementById('saved_json_data').value;
			if (savedJson && savedJson.trim() !== "") {
				try {
					var data = JSON.parse(savedJson);
					if (data.complaints) data.complaints.forEach(function(row) { addRowWithData('complaintBody', row); });
					if (data.tasks) data.tasks.forEach(function(row) { addRowWithData('taskBody', row); });
					if (data.materials) data.materials.forEach(function(row) { addRowWithData('materialBody', row); });
				} catch (e) { console.error("JSON 파싱 에러", e); }
			} else {
				// 신규 등록 시 기본 한 줄씩 추가
				addRow('complaintBody'); addRow('taskBody'); addRow('materialBody');
			}
		};

         //실시간 날씨 정보를 가져오는 함수 
        function getRealTimeWeather() {
            var savedTemp = "${logData.temp}"; 
            // 이미 저장된 온도가 없다면 API 호출
            if (!savedTemp || savedTemp === "" || savedTemp === "측정중...") {
                var API_KEY = "0c862b868fb02194dd5814a77179567a"; 
                fetch("https://api.openweathermap.org/data/2.5/weather?lat=37.5626&lon=126.9766&appid=" + API_KEY + "&units=metric")
                    .then(res => {
                        if(!res.ok) throw new Error("API 요청 실패"); // 응답 상태 확인
                        return res.json();
                    })
                    .then(data => {
                        var temp = data.main.temp.toFixed(1);
                        var el = document.getElementById('realTimeTemp');
                        if(el) {
                            el.innerText = temp + "°C";
                            // 온도에 따른 색상 변화 (가독성 향상)
                            el.style.color = (temp < 10 ? "#1a237e" : (temp > 25 ? "#c62828" : "#007bff"));
                        }
                        document.getElementById('hidden_temp').value = temp + "°C";
                    })
                    .catch(err => {
                        console.error("날씨 정보 로드 실패:", err);
                        document.getElementById('realTimeTemp').innerText = "정보 없음"; // 에러 시 표시 문구
                    });
            } else {
                // 기존 데이터가 있으면 해당 값 유지
                document.getElementById('hidden_temp').value = savedTemp;
            }
        }

		/**
		 * 기존 데이터를 바탕으로 행을 생성하는 함수
		 */
		function addRowWithData(id, values) {
			var tb = document.getElementById(id);
			var row = tb.insertRow();
			var html = '<td>' + tb.rows.length + '</td>';
			if (id === 'materialBody') {
				html += '<td><input type="text" value="' + (values[1]||'') + '"></td><td><input type="number" value="' + (values[2]||'') + '"></td>';
			} else {
				html += '<td><input type="text" value="' + (values[1]||'') + '"></td><td><input type="text" value="' + (values[2]||'') + '"></td><td><input type="text" value="' + (values[3]||'') + '"></td>';
			}
			html += '<td class="no-print"><button type="button" class="btn-del" onclick="delRow(this)">X</button></td>';
			row.innerHTML = html;
		}

		 //빈 행을 추가하는 함수
		function addRow(id) {
			var tb = document.getElementById(id);
			var row = tb.insertRow();
			var html = '<td>' + tb.rows.length + '</td>';
			if (id === 'materialBody') {
				html += '<td><input type="text"></td><td><input type="number"></td>';
			} else {
				html += '<td><input type="text"></td><td><input type="text"></td><td><input type="text"></td>';
			}
			html += '<td class="no-print"><button type="button" class="btn-del" onclick="delRow(this)">X</button></td>';
			row.innerHTML = html;
		}

		 // 행 삭제 및 번호 재정렬
		function delRow(btn) {
			var tb = btn.closest('tbody');
			btn.closest('tr').remove();
			// 번호(NO) 다시 매기기
			Array.from(tb.rows).forEach(function(r, i) { r.cells[0].innerText = i + 1; });
		}

		
		// 데이터를 JSON화 하여 제출
		function collectAndSubmit() {
			var scrape = function(id) {
				return Array.from(document.querySelectorAll('#' + id + ' tr')).map(function(tr) {
					var inputs = tr.querySelectorAll('input');
					var vals = [ tr.cells[0].innerText ]; // NO
					inputs.forEach(function(input) { vals.push(input.value); });
					return vals;
				});
			};
			var dataObj = { complaints : scrape('complaintBody'), tasks : scrape('taskBody'), materials : scrape('materialBody') };

			// 히든 필드에 데이터 바인딩
			document.getElementById('hidden_date').value = document.getElementById('realTimeDate').innerText;
			document.getElementById('hidden_worker').value = document.getElementById('worker_ui').value;
			document.getElementById('hidden_content').value = JSON.stringify(dataObj);
			document.getElementById('finalForm').submit();
		}

		// SheetJS를 이용한 엑셀 다운로드
		 function downloadExcel() {
			var wb = XLSX.utils.book_new();
			XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('complaintTable')), "민원");
			XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('taskTable')), "작업");
			XLSX.utils.book_append_sheet(wb, XLSX.utils.table_to_sheet(document.getElementById('materialTable')), "자재");
			XLSX.writeFile(wb, "업무일지_" + new Date().toLocaleDateString('ko-KR').replace(/[. ]/g, "") + ".xlsx");
		}
	</script>
</body>
</html>