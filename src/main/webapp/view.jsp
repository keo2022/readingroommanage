<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!--javaBeans 들고오기-->
<%@ page import="bbs.Bbs"%>
<!-- db접근객체 가져오기 -->
<%@ page import="bbs.BbsDAO"%>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>독서실 관리</title>
</head>
<body>
	<%
		//로그인한사람이라면	 userID라는 변수에 해당 아이디가 담기고 그렇지 않으면 null값
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		//매개변수및 기본셋팅 처리 하는 부분
		int bbsID = 0;
		//만약에 매개변수로 넘어온 bbsID라는 매개변수가 존재 할 시 
		//(이 매개변수는 bbs.jsp에서 view로 이동하는 a태그에서 넘겨준 값이다.)
		if (request.getParameter("bbsID") != null) {
			//파라미터는 항상 정수형으로 바꿔주는 parseInt를 사용해야 한다. 다음과 같이 정수형으로 변환시켜준다.
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		int pageNumber = 1;
		if(request.getParameter("pageNumber") != null) {
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
		//받아온 bbsID가 0이면 유효하지 않은 글이라고 넣어준다.
		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글 입니다.')");
			//다시 bbs.jsp로 돌려보내주자.
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
			//bbsID가 존재해야지, 특정한 글을 볼 수있도록 하는 거고,
		}
		//해당글의 구체적인 내용을 BbsDAO 내부 만들었던 getBbs함수를 실행시켜주는 부분 
		Bbs bbs = new BbsDAO().getBbs(bbsID);
	%>
	<!-- 웹사이트 공통메뉴 -->
    <nav class ="navbar navbar-default">
        <div class="navbar-header"> <!-- 홈페이지의 로고 -->
            <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expand="false">
                <span class ="icon-bar"></span><!-- 줄였을때 옆에 짝대기 -->
                <span class ="icon-bar"></span>
                <span class ="icon-bar"></span>
            </button>
            <a class ="navbar-brand" href="main.jsp">독서실 관리</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <!-- 현재의 게시판 화면이라는 것을 사용자에게 보여주는 부분 -->
                <li class="active"><a href="bbs.jsp">게시판</a></li>
                <li><a href="seat.jsp">좌석 확인</a></li>
            </ul>
			<%
				if (userID == null) {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
					</ul>
				</li>
			</ul>
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
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			<%
				}
			%>
		</div>
		<!-- 화면 공통메뉴 끝 -->
	</nav>
	<!-- 게시판 틀 -->
	<div class="container">
		<div class="row">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<!--테이블 제목 부분 구현 -->
							<th colspan="3" style="background-color: #eeeeee; text-align: center;">게시판 글 보기</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<!-- 게시판 글 보기 내부 1행 작성 -->
							<td style="width: 20%;"> 글 제목 </td>
							<td colspan="2"><%= bbs.getBbsTitle() %></td>
						</tr>
						<tr>
							<!-- 게시판 글 보기 내부 2행 작성 -->
							<td>작성자</td>	
							<td colspan="2"><%= bbs.getUserID() %></td>
						</tr>
						<tr>
							<!-- 게시판 글 보기 3행 작성 -->
							<td>작성일</td>
							<!-- bbs페이지에서 db에서 일자를 가져오는 소스코드를 참고 하는데 다른점은 내부 글의 데이터니까 아까만든 인스턴스에서 가져온다. -->	
							<td colspan="2"><%= bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시"
							+ bbs.getBbsDate().substring(14, 16) + "분"%></td>
						</tr>
						<tr>
							<!-- 마지막 행 내용 최소 높이를 200px; 지정-->
							<td>내용</td>	
							<!-- 들어갈 내용에 replaceAll을 사용해서 특수문자나 기호가 들어가도 정상 출력이 되게 해 주는 처리를 한다.
							replaceAll("공백","&nbsp;") 공백을 nbsp로 치환해서 출력해 줌 특수문자 치환을 넣어주면 크로스 브라우징 해킹방지도 가능하다.-->
							<td colspan="2" style="min-height: 200px; text-align: left;">
							<%= bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>")%></td>
						</tr>
					</tbody>
				</table>
				
				<form method="post" action="replyAction.jsp?bbsID=<%= bbsID %>">
					<table class="table table-striped"
						style="text-align: center; border: 1px solid #dddddd">
						<%-- 홀,짝 행 구분 --%>
						<thead>
							<tr>
								<th colspan="3"
									style="background-color: #eeeeeee; text-align: center;">댓글</th>
							</tr>
						</thead>
						<tbody>
						
							<%
								ReplyDAO replyDAO=new ReplyDAO();
								ArrayList<Reply> list=replyDAO.getList(bbsID, pageNumber);
								for(int i=list.size()-1;i>=0;i--){
								
							%>
	
							<tr>
								<td style="text-align: left;"><%= list.get(i).getReplyContent() %></td>
								<td style="text-align: right;"><%= list.get(i).getUserID() %>
								<a href="update.jsp?bbsID=<%= bbsID %>" class="btn">수정</a>
								<a href="update.jsp?bbsID=<%= bbsID %>" class="btn ">삭제</a>
								</td>
							</tr>
						
							<%
									}
							%>
							<td><textarea type="text" class="form-control"
									placeholder="댓글을 입력하세요." name="replyContent" maxlength="2048"></textarea></td>
							<td style="text-align: left; "></td>
						
						</tbody>
					</table>
					<input type="submit" class="btn" value="댓글입력">
				</form>
				<br>
				<!-- 목록으로 돌아갈 수 있는 버튼을 테이블 외부에서 작성해준다. -->	
				<a href = "bbs.jsp" class="btn btn-primary">목록</a>
				
				<%
					//만약 글작성자가 본인일시 현재 페이지의 userID와 bbs Db내부의 UserID를 들고와서 비교 후
					if(userID != null && userID.equals(bbs.getUserID())){
				%>
						<!-- 본인이라면 update.jsp에 bbsID를 가져갈 수 있게 해주고, 넘겨준다.-->
						<a href="update.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">수정</a>
						<!-- 삭제는 페이지를 거치지않고 바로 실행될꺼기때문에 Action페이지로 바로 보내준다. -->
						<a onclick="return confirm('정말 삭제하시겠습니까?')" href="deleteAction.jsp?bbsID=<%= bbsID %>" class="btn btn-primary">삭제</a>
				<%					
					}

				%>
		</div>
	</div>
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>