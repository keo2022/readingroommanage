<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.format.DateTimeFormatter" %>
<%@page import="java.time.temporal.ChronoUnit" %>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 앞서 만들었던 Time.DAO의 객체를 사용하기위해 선언 -->
<%@ page import="time.Time" %>
<%@ page import="time.TimeDAO" %>
<%@ page import="studytime.Studytime" %>
<%@ page import="studytime.StudytimeDAO" %>
<%@ page import="java.io.PrintWriter" %>
<!-- 22-11-06 캘린더java -->
<%@page import="java.util.Calendar"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%
	request.setCharacterEncoding("utf-8");

	Calendar cal = Calendar.getInstance();
	
	// 시스템 오늘날짜
	int ty = cal.get(Calendar.YEAR);
	int tm = cal.get(Calendar.MONTH)+1;
	int td = cal.get(Calendar.DATE);
	
	int year = cal.get(Calendar.YEAR);
	int month = cal.get(Calendar.MONTH)+1;
	
	// 파라미터 받기
	String sy = request.getParameter("year");
	String sm = request.getParameter("month");
	
	if(sy!=null) { // 넘어온 파라미터가 있으면
		year = Integer.parseInt(sy);
	}
	if(sm!=null) {
		month = Integer.parseInt(sm);
	}
	
	cal.set(year, month-1, 1);
	year = cal.get(Calendar.YEAR);
	month = cal.get(Calendar.MONTH)+1;
	
	int week = cal.get(Calendar.DAY_OF_WEEK); // 1(일)~7(토)
%>
<!-- 22-11-06 캘린더java -->


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width=device-width" , inital-scale="1">
<!--link 태그를 이용해서, stylesheet를 참조선언 해주고, 링크로 css폴더안에 있는 bootstrap.css를 사용해 준다고 명시해준다. jSP내의 디자인 담당-->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>독서실 관리</title>

<!-- 22-11-06 캘린더css -->
<link rel="icon" href="data:;base64,iVBORw0KGgo=">
<style type="text/css">
*{
	margin: 0; padding: 0;
    box-sizing: border-box;
}
.navbar navbar-default{
	width: 896px;	
}

body {
	font-size: 14px;
	font-family: "맑은 고딕", 나눔고딕, 돋움, sans-serif;
}

a {
  color: #000;
  text-decoration: none;
  cursor: pointer;
}
a:active, a:hover {
	text-decoration: underline;
	color: #F28011;
}

.calendar {
	width: 60%;
	margin: 30px auto;
}

.calendar .title{
	height: 37px;
	line-height: 37px;
	table-align: center;
	font-weight: 600;
}

.calendar table {
	width: 100%;
	height: 600px;
	border-collapse: collapse;
	border-spacing: 0;
}


.calendar table thead tr:first-child{
	background: #f6f6f6;
	
}

.calendar table td{
	width: 350px;
	height: 120px;
	padding: 10px;
	text-align: center;
	border: 1px solid #ccc;
}

.calendar table td:nth-child(7n+1){
	color: red;
}
.calendar table td:nth-child(7n){
	color: blue;
}
.calendar table td.gray {
	color: #ccc;
}
.calendar table td.today{
	font-weight:700;
	background: #E6FFFF;
}

.calendar .footer{
	height: 25px;
	line-height: 25px;
	text-align: right;
	font-size: 12px;
}
</style>
<!-- 22-11-06 캘린더css -->
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID")!=null){
			userID = (String) session.getAttribute("userID");
		}
	%>
	<!-- 네비게이션 구현 네비게이션이라는 것은 하나의 웹사이트의 전반적인 구성을 보여주는 역할 -->
	<nav class="navbar navbar-default">
		<!-- header부분을 먼저 구현해 주는데 홈페이지의 로고같은것을 담는 영역이라고 할 수 있다. -->
		<div class="navbar-header">
			<!-- <1>웹사이트 외형 상의 제일 좌측 버튼을 생성해준다. data-target= 타겟명을 지정해주고-->
			<button type="button" class="navbar-toggle collapsed"
				data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
				aria-exmaple="false">
		<!-- 이건 모바일 화면으로 볼때, 요약된 메뉴 목록에 줄을 그려주는부분 그림에서 설명 *1* 별건없고 단지 꾸며주는 용도-->
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			<!-- 여긴 웹페이지의 로고 글자를 지정해준다. 클릭 시 main.jsp로 이동하게 해주는게 국룰 -->
			<a class="navbar-brand" href="main.jsp">독서실 관리</a>
		</div>
		<!-- 여기서 <1>에만든 버튼 내부의 데이터 타겟과 div id가 일치해야한다. -->
		<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
			<!-- div 내부에 ul은 하나의 어떠한 리스트를 보여줄때 사용 -->
			<ul class="nav navbar-nav">
				<!-- 리스트 내부에 li로 원소를 구현 메인으로 이동하게만들고-->
				<li class="active"><a href="main.jsp">메인</a></li>
				<!-- 게시판으로 이동하게 만든다. -->
				<li><a href="bbs.jsp">게시판</a></li>
						<!-- 10-28 프로토타입 위해 추가 -->
				<li><a href="seat.jsp">좌석 확인</a></li>
				
			</ul>
			<%
				if(userID == null){
			%>
				<!-- 원소를 하나 구현해 준다. 네비게이션 우측 슬라이드메뉴 구현  -->
				<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<!-- 안에 a태그를 하나 삽입한다. href="#"은 링크없음을 표시한다. -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">접속하기
						<!-- 이건 하나의 아이콘 같은것 a태그 내부 삽입-->
						<span class="caret"></span></a>
					<!--접속하기 아래에 드랍다운메뉴 생성  -->
					<ul class="dropdown-menu">
						<!-- li class="active" 현재 선택된 홈페이지를 표시해 주게만든다. -->
						<li><a href="login.jsp">로그인</a></li>
					</ul>
				</li>
			</ul>
					</div>
		<!-- 네비게이션 바 구성 끝 -->
	</nav>		
			<% 
				} else if(userID.equals("1111")) {
			%>
			<!-- 원소를 하나 구현해 준다. 네비게이션 우측 슬라이드메뉴 구현  -->
				<ul class="nav navbar-nav navbar-right">
				<li class="dropdown">
					<!-- 안에 a태그를 하나 삽입한다. href="#"은 링크없음을 표시한다. -->
					<a href="#" class="dropdown-toggle"
						data-toggle="dropdown" role="button" aria-haspopup="true"
						aria-expanded="false">회원관리
						<!-- 이건 하나의 아이콘 같은것 a태그 내부 삽입-->
						<span class="caret"></span></a>
					<!--접속하기 아래에 드랍다운메뉴 생성  -->
					<ul class="dropdown-menu">
						<!-- li class="active" 현재 선택된 홈페이지를 표시해 주게만든다. -->
						<!-- 관리자는 회원등록을 할 수 있다. -->
						<li><a href="join.jsp">회원등록</a></li>
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
					</div>
		<!-- 네비게이션 바 구성 끝 -->
	</nav>	
			<%
				}else {

			%>
					<!-- 원소를 하나 구현해 준다. 네비게이션 우측 슬라이드메뉴 구현  -->
						<ul class="nav navbar-nav navbar-right">
						<li class="dropdown">
							<!-- 안에 a태그를 하나 삽입한다. href="#"은 링크없음을 표시한다. -->
							<a href="#" class="dropdown-toggle"
								data-toggle="dropdown" role="button" aria-haspopup="true"
								aria-expanded="false">회원관리
								<!-- 이건 하나의 아이콘 같은것 a태그 내부 삽입-->
								<span class="caret"></span></a>
							<!--접속하기 아래에 드랍다운메뉴 생성  -->
							<ul class="dropdown-menu">
								<!-- li class="active" 현재 선택된 홈페이지를 표시해 주게만든다. -->
								<li><a href="profile.jsp">프로필</a></li>
								<li><a href="logoutAction.jsp">로그아웃</a></li>
							</ul>
						</li>
					</ul>	
							</div>
		<!-- 네비게이션 바 구성 끝 -->
	</nav>
				
					<!-- 캘린더 -->
					<div class="calendar">
					<div class="title">
						<a href="main.jsp?year=<%=year%>&month=<%=month-1%>">&lt;</a>
						<label><%=year%>년 <%=month%>월</label>
						<a href="main.jsp?year=<%=year%>&month=<%=month+1%>">&gt;</a>
					</div>
					
					<table>
						<thead>
							<tr>
								<td>일</td>
								<td>월</td>
								<td>화</td>
								<td>수</td>
								<td>목</td>
								<td>금</td>
								<td>토</td>
							</tr>
						</thead>
						<tbody>
				<%
				
				StudytimeDAO studytimeDAO = new StudytimeDAO();
				
				
				
					// 1일 앞 달
					Calendar preCal = (Calendar)cal.clone();
					preCal.add(Calendar.DATE, -(week-1));
					int preDate = preCal.get(Calendar.DATE);
					
					out.print("<tr>");
					// 1일 앞 부분
					for(int i=1; i<week; i++) {
						//out.print("<td>&nbsp;</td>");
						out.print("<td class='gray'>"+(preDate++)+"</td>");
					}
							
					// 1일부터 말일까지 출력
					int lastDay = cal.getActualMaximum(Calendar.DATE);
					String cls;
					String result;
				
					for(int i=1; i<=lastDay; i++) {
						cls = year==ty && month==tm && i==td ? "today":"";
						result = null;
						result = studytimeDAO.viewmain(userID, year, month, i);
						//out.print("<a href=main.jsp?detail='"+i+"'>");
						out.print("<td class='"+cls+"' onClick=\"location.href='main.jsp?detail="+i+"'\">"+i+"<br>"+result+"</td>");
						//out.print("</a>");
						if(lastDay != i && (++week)%7 == 1) {
							out.print("</tr><tr>");
						}
					}
				
							
					// 마지막 주 마지막 일자 다음 처리
					int n = 1;
					for(int i = (week-1)%7; i<6; i++) {
						// out.print("<td>&nbsp;</td>");
						out.print("<td class='gray'>"+(n++)+"</td>");
					}
					out.print("</tr>");
				%>		
						</tbody>
					</table>
					<!-- 캘린더 -->
					
					
					<% 
						}
					//자동 종료를 위한 함수
					TimeDAO timeDAO = new TimeDAO();
					String limiteduserID = timeDAO.limiteduser();
					int autoend = timeDAO.autoend();
					if(autoend == 1){
						StudytimeDAO studytimeDAO = new StudytimeDAO();
						//시작시간
						String starttime = timeDAO.starttime(limiteduserID);
						//시간차이
						String timediff = timeDAO.timediff(limiteduserID);
						//오늘 처음 공부하는건지 확인
						String firststudy = studytimeDAO.firststudy(limiteduserID, starttime);
						//기존 공부시간 가져오는 함수
						String existing = studytimeDAO.existing(limiteduserID, starttime);
						
						
						if(firststudy.equals("4") || firststudy == null){
						//오늘 처음 시작했으면 시작시간기준으로 연,월,일 정하고 시간차이를 집어넣는다.
						int result1 = studytimeDAO.incalcstudytime(limiteduserID, starttime, timediff);
						}
						else {
						//이미 공부시간이 있기때문에 기존 시간(existing)을 가져와서 새로 가져온 시간(timediff)과 더한다.
						int result2 = studytimeDAO.upcalcstudytime(limiteduserID, starttime, timediff, existing);
						
						}
					}
					//상세화면
					
					int detail = 1;
					if(request.getParameter("detail")!=null){
					TimeDAO detailtimeDAO = new TimeDAO();
					StudytimeDAO detailstudytimeDAO = new StudytimeDAO();
					detail = Integer.parseInt(request.getParameter("detail"));
					String detailstudytime = detailstudytimeDAO.viewmain(userID, year, month, detail);
					String detailstarttime = detailstudytimeDAO.daystart(userID, year, month, detail);
					String detailendtime = detailstudytimeDAO.dayend(userID, year, month, detail);
					String detailbreaktime = detailstudytimeDAO.breaktime(userID, year, month, detail);
					%>
					<div style="  display: flex;
								  justify-content: center;
								  align-items: center;">
					총 공부 시간 : <%= detailstudytime %> &nbsp; 휴식 시간 : <%=detailbreaktime %><br>
					시작 시간 : <%= detailstarttime %> &nbsp; 종료 시간 : <%= detailendtime %>
					</div>
					<%
						}
						else{
					%>
					
					<% 
						}
					%>
					
	
	
	

	<!--이 파일의 애니메이션을 담당할 자바스크립트 참조선언 jquery를 특정 홈페이지에서 호출 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!--js폴더 안에있는 bootstrap.js를 사용선언  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>