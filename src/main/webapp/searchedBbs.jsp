<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="java.util.ArrayList"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>JSP JSW 게시판 웹사이트</title>
<style type="text/css">
a, a:hover {
	color: #000000;
	text-decoration: none;
}
.category{
	margin-left:20%;
	}
</style>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		int pageNumber =1;
		if(request.getParameter("pageNumber")!=null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
			System.out.println("pageNumber="+pageNumber);
		}
		
		String searchWord = null;
		if(request.getParameter("searchWord")!=null){
			searchWord = (String) request.getParameter("searchWord");
			System.out.println("searchword from parameter is :" + searchWord);
		}
		if(session.getAttribute("searchWord")!=null){
			searchWord = (String) session.getAttribute("searchWord");
			System.out.println("searchword from session is :" + searchWord);
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
			<div class="category">
        	<h4>카테고리 선택</h4>
        		<a href="bbs.jsp?category=전체" type="button" class="btn btn-light">전체</a>
        		<a href="bbs.jsp?category=공지사항" type="button" class="btn btn-light">공지사항</a>
        		<a href="bbs.jsp?category=자유" type="button" class="btn btn-light">자유</a>
        		<a href="bbs.jsp?category=자기계발" type="button" class="btn btn-light">자기계발</a>
        		<a href="bbs.jsp?category=질문" type="button" class="btn btn-light">질문</a>
        		<a href="bbs.jsp?category=자료" type="button" class="btn btn-light">자료</a>
            </div><br>
	<div class="container">
		<div class="row">
		<form method="post" action="searchedBbs.jsp">
			<div class="col-lg-4">
				<input type="text" class="form-control pull-right" placeholder="Search" name="searchWord" />
				</div>
				<button class="btn btn-primary" type="submit" >
				<span class="glyphicon glyphicon-search">
				</span>
				</button>
			</form>
			<table class="table table-striped"
				style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<!-- <div>
						<div class=" col-lg-4">
							<input type="text" class="form-control pull-right" placeholder="Search" id="txtSearch" />
						</div>
						<button class="btn btn-primary" type="submit">
							<span class="glyphicon glyphicon-search"></span>
							<a href="searchedBbs.jsp"></a>
						</button>
					</div> -->
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">번호</th>
						<th style="background-color: #eeeeee; text-align: center;">카테고리</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>
				<tbody>
					<%
						String category = null;
			 			category = request.getParameter("category");
						BbsDAO bbsDAO = new BbsDAO(); 
						 ArrayList<Bbs> list = null;
		                	//list 생성 그 값은 현재의 페이지에서 가져온 리스트 게시글목록
		                    if(category == null || category.equals("전체")){
		                    	list = bbsDAO.getSearchedList(pageNumber,searchWord);
		                    }
		                	else{ 
		                	list = bbsDAO.getSearchedcategoryList(pageNumber, searchWord, category);
		                	}
						//System.out.println("here after getlist" + list.get(0).getBbsDate().substring(0,11));
						for(int i=0;i<list.size();i++){
					%>
					<tr>
						<td><%=list.get(i).getBbsID()%></td>
                        <td><%=list.get(i).getBbsCategory() %></td>
						<td><a href="view.jsp?bbsID=<%=list.get(i).getBbsID()%>"><%=list.get(i).getBbsTitle().replaceAll(" ","&nbsp;").replaceAll("<","&lt;").replaceAll("<","&gt;").replaceAll("\n","<br>")%></a></td>
						<td><%= list.get(i).getUserID()%></td>
						<td><%=	list.get(i).getBbsDate().substring(0, 11) + list.get(i).getBbsDate().substring(11,13) + "시" + list.get(i).getBbsDate().substring(14,16) + "분"%></td>
					</tr>
					<% 
					
						}
					
					%>

				</tbody>
			</table>

				<tr>
				
					<td class = "pull-left">
					
					
					
						<% 
						if(category == null || category.equals("전체")){
						if(pageNumber != 1) {
							session.setAttribute("searchWord",searchWord);
					%> <a href="searchedBbs.jsp?pageNumber=<%=pageNumber-1%>"
								class="btn btn-success btn-arrow-left">이전</a> <%		
						} if(bbsDAO.searchedNextPage(pageNumber,searchWord)) {
							session.setAttribute("searchWord",searchWord);
					%> <a href="searchedBbs.jsp?pageNumber=<%=pageNumber+1%>"
								class="btn btn-success btn-arrow-right">다음</a> <% 
						}
					}
					%>
					</td>
					
					<td><a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
					</td>
				</tr>
			
		</div>
	</div>
	<script src="http://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>