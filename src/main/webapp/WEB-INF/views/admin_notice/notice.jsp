<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/resources/css/basis.css" />
<link rel="stylesheet" href="/resources/css/admin_notice.css" />
<style>


#btn1 {
	background: #1b5ac2
}

.menu {
	margin-bottom: 50px
}

/* paging */

table tfoot ol.paging {
    list-style: none;
    text-align: center; /* 가운데 정렬을 위한 변경 */
}
table tfoot ol.paging li {
    display: inline-block; /* 가로 정렬을 위해 float 제거하고 inline-block으로 변경 */
    /* margin-right: 8px; */
}


table tfoot ol.paging li a {
    display: block;
    /* padding: 3px 7px; */
    border: 1px solid #6c98c2;
    color: #2f313e;
    /* font-weight: bold; */
}

table tfoot ol.paging li a:hover {
    background: #6c98c2;
    color: white;
    /* font-weight: bold; */
}

.disable {
    padding: 3px 7px;
    border: 1px solid silver;
    color: silver;
}

.now {
    padding: 3px 7px;
    border: 1px solid #1b5ac2;
    background: #1b5ac2;
    color: white;
    font-weight: bold;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
<script type="text/javascript">
//기간검색-오늘 
function setTodayDate() {
    // 오늘 날짜를 구합니다.
    var today = new Date();
    var year = today.getFullYear();
    var month = (today.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1을 해줍니다.
    var day = today.getDate().toString().padStart(2, '0');

    // 오늘 날짜를 기간 검색 필드에 설정합니다.
    document.getElementById('start1').value = year + '-' + month + '-' + day;
    document.getElementById('close1').value = year + '-' + month + '-' + day;
	}
//기간검색-일주일 
function setOneWeekDate() {
    // 오늘 날짜를 구합니다.
    var today = new Date();
    var year = today.getFullYear();
    var month = (today.getMonth() + 1).toString().padStart(2, '0'); // 월은 0부터 시작하므로 +1을 해줍니다.
    var day = today.getDate().toString().padStart(2, '0');

    // 일주일 전 날짜를 계산합니다.
    var oneWeekAgo = new Date(today);
    oneWeekAgo.setDate(today.getDate() - 7);
    var oneWeekAgoYear = oneWeekAgo.getFullYear();
    var oneWeekAgoMonth = (oneWeekAgo.getMonth() + 1).toString().padStart(2, '0');
    var oneWeekAgoDay = oneWeekAgo.getDate().toString().padStart(2, '0');

    // 오늘 날짜를 기간 검색 필드에 설정합니다.
    document.getElementById('start1').value = oneWeekAgoYear + '-' + oneWeekAgoMonth + '-' + oneWeekAgoDay;
    document.getElementById('close1').value = year + '-' + month + '-' + day;
	}
//기간검색-전체기간(수정해야함 )
function setAllDates() {
    // "전체기간" 버튼을 눌렀을 때, 모든 기간을 표시하도록 설정합니다.
    // 여기서는 작성일 열을 업데이트합니다.
    var rows = document.querySelectorAll(".table_a tbody tr"); // 모든 행을 가져옵니다.
    for (var i = 0; i < rows.length; i++) {
        var row = rows[i];
        var dateCell = row.cells[7]; // 작성일 열(0부터 시작)을 선택합니다.
        // 여기서 dateCell.textContent를 수정하여 작성일을 표시합니다.
        // 예를 들어 작성일이 서버에서 가져온 데이터로 있다고 가정합니다.
        var writtenDate = row.cells[7].textContent; //여기를 실제 작성일로 대체해야 합니다.
        dateCell.textContent = writtenDate; // 작성일을 업데이트합니다.
    }
    document.getElementById('searchTitle').value = ""; // 검색 제목을 '작성일'로 설정
    document.getElementById('startDate').value = ""; // 'start' 필드 초기화
    document.getElementById('close').value = ""; // 'close' 필드 초기화
}
    
//초기화 
function resetFields() {
    document.getElementById('searchKey').value = "제목"; // 검색어 필드 초기화 
    document.getElementById('searchTitleSelect').value = "기간"; // 검색어 필드 초기화 
    document.getElementById('start1').value = ""; // 'start' 필드 초기화
    document.getElementById('close1').value = ""; // 'close' 필드 초기화
}
/* function setStartField() {
    var startDate = document.getElementById('startDate').value;
    document.getElementById('start').value = startDate;
    return true; // 폼 제출을 진행하도록 true 반환
} */
    
// 테이블 게시물 삭제버튼
function deleteRow(rowId) {
	var checkbox = document.getElementById("chkbox_" + rowId);
	if(checkbox.checked) {
		$.ajax({
			url: '/admin_Updaterow.do',
			type: 'POST',
			data: {rowId: rowId},
			success: function(response){
				var row = document.getElementById("row_" + rowId);
				row.style.display = "none";		
			},
			error: function(erroe){
				alert("Error occurred");
			}
		})
		
	} else {
		alert("체크박스가 선택되지 않았습니다.");
		
	}
}
//삭제 게시물 검색
function showDeletedNotices(noticeNum) {
	var noticeNum = 2;
	$.ajax({
		url: '/admin_showdelbtn.do?noticeNum=' + noticeNum,
		type: 'GET',
		success: function(response) {
			console.log("tlqkf3")
			$('#table_wrap').append(response);
			//기존의 모든 내용을 삭제한 후 새로운 내용을 추가합니다:
			//$('#table_wrap').empty().append(response);
			
			//기존의 요소를 새로운 내용으로 완전히 대체합니다:
			//$('#table_wrap').replaceWith(response);
			
			//#table_wrap 내의 특정 요소만 업데이트하고 싶다면, 더 세밀한 DOM 조작이 가능합니다:
			//$('#table_wrap > tbody').append('<tr><td>New Row</td></tr>');

			alert("성공 성공")
		},
		error: function(error) {
			alert("에러 에러");
		}
	});
}

//검색버튼
/*$(".searchbtn").on("click", function() {
    $.ajax({
        url: "/adnotice_search.do",
        method: "post",
        dataType: "xml",
        success: function(xmlData) {
            var rows = '';

            // Parse the XML data
            var notices = $(xmlData).find("Notice");
            
            if (notices.length === 0) {
                rows += '<tr><td colspan="10"><p>자료가 존재하지 않습니다.</p></td></tr>';
            } else {
                notices.each(function(index, notice) {
                    notice = $(notice);  // Convert to jQuery object for easier manipulation
                    rows += '<tr>';
                    rows += '<td><input type="checkbox" name="chk" value="' + notice.find("NOTICE_NUM").text() + '" /></td>';
                    rows += '<td>' + (index + 1) + '</td>';
                    rows += '<td>' + notice.find("NOTICE_SUBJECT").text() + '</td>';
                    rows += '<td>' + notice.find("NOTICE_CONTENT").text() + '</td>';
                    rows += '<td>' + notice.find("NOTICE_FILE").text() + '</td>';
                    rows += '<td>' + notice.find("NOTICE_HIT").text() + '</td>';
                    rows += '<td>' + notice.find("NOTICE_DATE").text() + '</td>';
                    rows += '<td>' + notice.find("NOTICE_UPDATE").text() + '</td>';
                    rows += '<td>' + notice.find("NOTICE_WRITER").text() + '</td>';
                    rows += '<td>' + notice.find("NOTICE_ST").text() + '</td>';
                    rows += '</tr>';
                });
            }
            
            // Append the rows to the table body
            $("#bal").append(rows);
        },
        error: function() {
            alert("Oop~! Sorry~♡♥");
        }
    });
});*/

//검색버튼
$(".searchbtn").on("click", function() {
	$("#bal").empty();
	 
    $.ajax({
        url: "/adnotice_search.do",
        method: "post",
        dataType: "xml",
        success: function(data) {
        	console.log(data);
        	alert("데이터갖고온다")
        	var  table = "<table>";
			table += "<thead><tr><th>선택</th><th>번호</th><th>제목</th><th>내용</th><th>파일</th><th>조회수</th><th>작성일</th><th>수정일</th><th>관리자</th><th>상태</th></tr></thead>";
			table += "<tbody>";
			$(data).find("notice").each(function() {
				var subject = $(this).find("subject").text();
				var content = $(this).find("content").text();
				var  file = $(this).find("file").text();
				var hit = $(this).find("hit").text();
				var date = $(this).find("date").text();
				var update = $(this).find("update").text();
				var writer = $(this).find("writer").text();
			
				table += "<tr>";
				table += "<td>" + subject+ "</td>";
				table += "<td>" + content +"</td>";
				table += "<td>" + file +"</td>";
				table += "<td>" + hit +"</td>";
				table += "<td>" + price +"</td>";
				table += "<td>" + update +"</td>";
				table += "<td>" + writer +"</td>";
				table += "</tr>";
			});
			table += "</tbody>";
			table += "</table>";
			$("#bal").append(table);
        },
        error: function() {
            alert("Oop~! Sorry~♡♥");
        }
    });
});

</script>
</head>
<body>
	<jsp:include page="../admin_main/header.jsp"></jsp:include>

	<!-- 게시판 관리 텍스트 추가 -->
	<h3>게시판 관리</h3>

	<jsp:include page="header.jsp"></jsp:include>

	<!--실시간 현황  -->
	<div class="search_wrap">
		<div
			style="float: left; margin-left: 205px; margin-top: 5%; margin-right: 20px; border: 1px solid black; width: 20%; height: 400px;">
			<p style="margin-top: 130px;">
			<h1 style="text-align: center; font-size: 18px;">전체 공지사항 게시글 :
				125개</h1>
			</p>
			<br>
			<h1 style="text-align: center; font-size: 18px;">등록한 공지사항 게시글 :
				125개</h1>
			</p>
			<br>
			<p>
			<h1 style="text-align: center; font-size: 18px;">삭제한 게시글 : 5개</h1>
			</p>
		</div>

		<!-- 검색 영역 -->

		<form id="searchForm" action="/adnotice_search.do" method="post">
		
			<div
				style="float: left; margin-top: 5%; border: 1px solid black; width: 60%; height: 400px;">
				<div>
					<dl style="margin-top: 40px;">
						<dt></dt>
						<dd>
							<p>
								<span> <span
									style="font-family: '맑은 고딕'; font-size: 16px; float: left; margin-left: 50px;">검색어
										&nbsp</span> <select id="searchKey" name="searchKey" title="검색항목선택"
									class="select_option"
									style="margin-left: 55px; width: 300px; height: 50px; font-size: 20px;">
										<option value="제목">제목</option>
										<option value="작성자">작성자</option>
										<option value="내용">내용</option>
										
								</select>
								<!-- 검색어 입력창  -->
								</span> <span style="margin-left: 10px;"> <input type="text"
									id="fromDate" name="searchText" title="검색어 입력" 
									maxlength="10" style="width: 240px; height: 50px;">
								</span>&nbsp&nbsp&nbsp&nbsp
							</p>
						</dd>
					</dl>
					<dl style="margin-top: 60px;">
						<dt></dt>
						<dd>
							<p>
								<span
									style="font-family: '맑은 고딕'; font-size: 16px; margin-left: 50px; float: left;">기간검색</span>
								<span>
								<select id="searchTitleSelect" name="searchTitle" title="작성일 선택" class="select_option" style="margin-left: 50px; width: 300px; height: 50px; font-size: 20px;">
    								<option value="기간">기간</option>
    								<option value="dateCreated1">작성일</option>
    								<option value="dateCreated2">수정일</option>
								</select>

								</span> <span style="margin-left: 10px;">
								 <!-- 달력 --> 
								 <input
									type="date" id="start1" name="start1"
									style="height: 40px; width: 300px;" />
								</span> <span> <input type="date" id="close1" name="close1"
									style="height: 40px; width: 300px;" />
								</span>
							</p>
						</dd>
					</dl>

					<div>
						<span
							style="float: right; margin-top: 50px; margin-left: 15px; margin-right: 30px;">
							<input type="button" alt="삭제게시물" value="삭제게시물"
							style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
							onclick="showDeletedNotices(2)"></span> 
							
						<span style="float: right; margin-top: 50px; margin-left: 15px;">
							<input type="button" alt="전체기간" value="전체기간"
							style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
							onclick="setAllDates()"></span> 
						<span style="float: right; margin-top: 50px; margin-left: 15px;">
							<input type="button" alt="일주일" value="일주일"
							style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
							onclick="setOneWeekDate()"></span> 
						<span style="float: right; margin-top: 50px; margin-left: 15px;">
							<input type="button" alt="오늘" value="오늘"
							style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
							onclick="setTodayDate()">
						</span>
					</div>
					<dl>
						<dt>
							<div>
								<span style="float: right; margin-top: 130px; margin-right: -659px;">
									<input type="button" alt="초기화" value="초기화"
									style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
									onclick="resetFields()"></span>
								 <span style="float: right; margin-top: 130px; margin-right: -494px;">
								 <input type="hidden" value="공지사항" name="mg_type">
									<!-- <button class="searchbtn" type="submit"
									style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;">검색</button> -->
								<button style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;" class="searchbtn" type="button">검색</button>
								</span>
							</div>
						</dt>
					</dl>
				</div>
			</div>
		</form> 
	</div>
	<!-- 수평선 추가 -->
	<div
		style="clear: both; margin-top: 700px; margin-left: 100px; margin-right: 100px;">
		<hr style="border-top: 1px solid black;">
	</div>

	<!--테이블  -->
	<%-- <div class="table_wrap" style="clear: both; margin-right: 35px;">
		<table class="table_a" style="width: 84%">
			<colgroup>
				<col width="5%">
				<col width="5%">
				<col width="10%">
				<col width="15%">
				<col width="10%">
				<col width="5%">
				<col width="10%">
				<col width="10%">
				<col width="10%">
			</colgroup>
			<thead>
				<tr>
					<td class="column_1">선택</td>
					<td class="column_2">NO.</td>
					<td class="column_3">게시물 제목</td>
					<td class="column_4">내용</td>
					<td class="column_5">파일 이름</td>
					<td class="column_6">조회수</td>
					<td class="column_7">작성일</td>
					<td class="column_8">수정일</td>
					<td class="column_9">작성자</td>
					<td class="column_10">등록상태</td>
				</tr>
			</thead>
			<tbody id="bal">
			
			</tbody> --%>
			<div id="bal"></div>
	<!-- 페이지 번호 출력 부분 -->
<tfoot>
    <tr>
        <td colspan="10">
            <ol class="paging">
                <!-- 이전 버튼 -->
                <c:if test="${paging.beginBlock > paging.pagePerBlock}">
                    <li><a href="/admin_notice.do?cPage=${paging.beginBlock-paging.pagePerBlock}">이전으로</a></li>
                </c:if>
                <c:if test="${paging.beginBlock <= paging.pagePerBlock}">
                    <li class="disable">이전으로</li>
                </c:if>
                
                <!-- 페이지 번호 출력 -->
                <c:forEach begin="${paging.beginBlock }" end="${paging.endBlock }" step="1" var="k">
                    <c:choose>
                        <c:when test="${k == paging.nowPage }">
                            <li class="now">${k }</li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="/admin_notice.do?cPage=${k }"> ${k }</a></li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                
                <!-- 다음 버튼 -->
                <c:if test="${paging.endBlock < paging.totalPage}">
                    <li><a href="/admin_notice.do?cPage=${paging.beginBlock+paging.pagePerBlock }">다음으로</a></li>
                </c:if>
                <c:if test="${paging.endBlock >= paging.totalPage }">
                    <li class="disable">다음으로</li>
                </c:if>
            </ol>
        </td>
    </tr>
</tfoot>
	
	</table>
	</div>
	<!-- 하단 버튼 -->
	<div>
		<span style="float: right; margin-top: 25px; margin-right: 170px;">
			<button type="button" alt="공지사항" value="공지사항"
				style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
				onclick="location.href='/ad_allnotice.do'">공지사항❐</button>
		</span> <span style="float: right; margin-top: 25px; margin-right: 50px;">
			<button type="button" alt="글쓰기" value="글쓰기"
				style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
				onclick="location.href='/ad_noticeform.do'">글쓰기</button>
		</span> <span style="float: right; margin-top: 25px; margin-right: 50px;">
			<button type="button" alt="홈페이지 등록" value="홈페이지 등록"
				style="width: 150px; height: 50px; font-size: 16px; border-radius: 10px; background-color: #505BBD; color: white; border: none;"
				onclick="location.href='/'">홈페이지 등록</button>
		</span>
	</div>


	<jsp:include page="../Semantic/footer.jsp"></jsp:include>
</body>
</html>