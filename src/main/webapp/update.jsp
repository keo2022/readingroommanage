<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!--javaBeans 들고오기-->
<%@ page import="bbs.Bbs"%>
<!-- db접근객체 가져오기 (함수 갖다쓰기)-->
<%@ page import="bbs.BbsDAO"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		//로그인한사람이라면	 userID라는 변수에 해당 아이디가 담기고 그렇지 않으면 null값
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		} 
		//로그인 안한 경우에 로그인 페이지로 돌려보내 주는 java code 작성
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		int bbsID = 0;
		//view페이지에서 넘겨준 bbsID를 들고오는 소스 코드
		if (request.getParameter("bbsID") != null) {
			//받은 bbsID를 정수형으로 반환해서 bbsID 인스턴스에 저장
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}
		//bbsID가 제대로 들어오지 않았다면,
		if (bbsID == 0) {
			//다시 게시판 메인 페이지로 돌려보낸다.
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글 입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		//현재 작성한 글이 작성자가 일치하는지 확인해주는 소스코드 작성
		//만약 userID와 뷰페이지에서 넘겨받은 bbsID값을 가지고 해당 글을 가져온 후
		Bbs bbs = new BbsDAO().getBbs(bbsID);
		//실제로 이 글의 작성자가 일치하는지 비교해준다. userID는 세션에 있는 값이고, bbs.getUserID는 이글을 작성한 사람의 값이다.
		if (!userID.equals(bbs.getUserID())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			//동일하지 않다면 오류를 출력해 돌려보내준다.
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");				
		}
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
            <a class ="navbar-brand" href="main.jsp">JSP 게시판 웹 사이트</a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
                <li><a href="main.jsp">메인</a></li>
                <!-- 현재의 게시판 화면이라는 것을 사용자에게 보여주는 부분 -->
                <li class="active"><a href="bbs.jsp">게시판</a></li>
            </ul>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown" role="button" aria-haspopup="true"
					aria-expanded="false">회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul>
				</li>
			</ul>
			
		</div>
		<!-- 화면 공통메뉴 끝 -->
	</nav>
	<!-- 게시판 글쓰기 화면 구현-->

	<!-- 게시판 --> 

	<div class="container">
		<div class="row">
			<!-- update 요청을할 때 그 요청을 따로 처리해주는 updateAction 페이지로 bbsID와 함께 넘겨준다. -->
			<form method="post" action="updateAction.jsp?bbsID=<%= bbsID %> ">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<!-- 테이블 제목부분도 게시판 글 수정양식으로 기능에 맞게 바꿔준다. -->
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">글 수정 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<!--이제 글을 수정하려고 페이지에 들어갔으면 수정 하기 전 내용이 뭔지를 봐야하니 value에 전과같이 내용들을 넣어준다. -->
							<td><input type="text" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50" value="<%= bbs.getBbsTitle() %>" ></td>
						</tr>
						<tr>
							<!-- 위와 동일한 이유로 작성 되어있던 내용도 불러와준다. -->
							<td><textarea class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;" ><%= bbs.getBbsContent() %></textarea></td>
						</tr>
					</tbody>
				</table>	
				<input type="submit" class="btn btn-primary pull-right" value="글수정">
			</form>
		</div>
	</div>
	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

	<!-- 부트스트랩 JS  -->

	<script src="js/bootstrap.js"></script>
</body>
</html>