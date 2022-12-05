<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="bbs.Bbs" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<meta name="viewport" content="width=device-width" , inital-scale="1">
<!--link 태그를 이용해서, stylesheet를 참조선언 해주고, 링크로 css폴더안에 있는 bootstrap.css를 사용해 준다고 명시해준다. jSP내의 디자인 담당-->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>독서실 관리</title>
<style type="text/css">
	a, a:hover {
		color: #000000;
		text-decoration: none;
	}
</style>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID")!=null){
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber = 1;
		if(request.getParameter("pageNumber")!=null){
			pageNumber =Integer.parseInt(request.getParameter("pageNumber"));
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
				<li><a href="main.jsp">메인</a></li>
				<!-- 게시판으로 이동하게 만든다. -->
				<li class="active"><a href="bbs.jsp">게시판</a></li>
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
			<%
				}
			%>	
		</div>
		<!-- 네비게이션 바 구성 끝 -->
	</nav>
	<div class="container">
		 <div class="row">
		 	<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
		 		<thead>
		 			<tr>
		 				<th	style="background-color: #eeeeee; text-align: center;">번호</th>
		 				<th	style="background-color: #eeeeee; text-align: center;">제목</th>
		 				<th	style="background-color: #eeeeee; text-align: center;">작성자</th>
		 				<th	style="background-color: #eeeeee; text-align: center;">작성일</th>
		 			</tr>
		 		</thead>
		 		<tbody>
		 		
					<%
                	//게시글을 담을 인스턴스
                    BbsDAO bbsDAO = new BbsDAO();
                	//list 생성 그 값은 현재의 페이지에서 가져온 리스트 게시글목록
                    ArrayList<Bbs> list = bbsDAO.getList(pageNumber);
                    //가져온 목록을 하나씩 출력하도록 선언한다..
                	for(int i = 0; i < list.size(); i++)
                    {
		 			%>
		 			<tr>	
                    	<!-- 현재의 게시글에 대한 정보를 하나씩 데이터를 데이터베이스에서 불러와서 보여준다. -->
                        <td><%=list.get(i).getBbsID() %></td>
                        <!-- 제목을 눌렀을때는 해당 게시글의 내용을 보여주는 페이지로 이동해야하기때문에
                         view.jsp페이지로 해당 게시글번호를 매개변수로 보내서 처리한다. href="주소?변수명 = 값! 이런식으로 처리를 해준다.-->
                        <td><a href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>"><%=list.get(i).getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<","&lt;").replaceAll(">", "&gt;").replaceAll("\n","<br>") %></a></td>
                        <td><%=list.get(i).getUserID() %></td>
                        <!--날짜 데이터를 가져오는것은 substring(index,index) 함수는 DB내부에서 필요한 정보만 잘라서 들고오게 해 주는 함수-->
                        <td><%=list.get(i).getBbsDate().substring(0,11) + list.get(i).getBbsDate().substring(11, 13) + "시" 
                        + list.get(i).getBbsDate().substring(14,16) + "분" %></td>
                    </tr>
		 			<%
		 				}
		 			%> 
		 			
		 			
		 		</tbody>
		 	</table>
		 	            <%
            	//테이블 밑에 이전 버튼과 다음 버튼을 구현해 주는 부분
                if(pageNumber != 1) {
            %>
            	<!--페이지넘버가 1이 아니면 전부다 2페이지 이상이기 때문에 pageN에서 1을뺀값을 넣어서 게시판
            	 메인화면으로 이동하게 한다. class내부 에는 화살표모양으로 버튼이 생기게 하는 소스작성 아마 부트스트랩 기능인듯.-->
                <a href="bbs.jsp?pageNumber=<%=pageNumber - 1 %>" class="btn btn-success btn-arrow-left">이전</a>
            <%
            	//BbsDAO에서 만들었던 함수를 이용해서, 다음페이지가 존재 할 경우
                } if (bbsDAO.nextPage(pageNumber + 1)) {
            %>
            	<!-- a태그를 이용해서 다음페이지로 넘어 갈 수있는 버튼을 만들어 준다. -->
                <a href="bbs.jsp?pageNumber=<%=pageNumber + 1 %>" class="btn btn-success btn-arrow-left">다음</a>
            <%
                }
            %>
		 	<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
		 </div>
	</div>

	
	<!--이 파일의 애니메이션을 담당할 자바스크립트 참조선언 jquery를 특정 홈페이지에서 호출 -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<!--js폴더 안에있는 bootstrap.js를 사용선언  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>